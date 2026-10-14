import 'dart:math' as math;
import '../generated/protocol.dart';
import '../simulation/constellation_simulator.dart';
import '../decision_log/decision_log_manager.dart';

/// Runtime execution engine managing workloads, checkpoints, migrations,
/// ground station ingest/egress passes, priority preemption, and rollbacks.
class JobRuntime {
  final Map<String, Job> jobs = {};
  final List<Checkpoint> checkpoints = [];
  final DecisionLogManager decisionLog;

  JobRuntime({required this.decisionLog});

  /// Submits a new compute job to the platform.
  Job submitJob({
    required String name,
    required String priority, // CRITICAL, HIGH, NORMAL, BATCH
    required double totalRuntimeSeconds,
    required double requiredComputeTFlops,
    double checkpointIntervalSeconds = 180.0,
    double checkpointSizeBytes = 2.0e9, // 2 GB
    Duration? deadlineDuration,
  }) {
    final jobId = 'JOB-${name.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '')}-${DateTime.now().millisecondsSinceEpoch % 10000}';
    final now = DateTime.now();

    final job = Job(
      jobId: jobId,
      name: name,
      priority: priority,
      totalRuntimeSeconds: totalRuntimeSeconds,
      completedRuntimeSeconds: 0.0,
      progress: 0.0,
      requiredComputeTFlops: requiredComputeTFlops,
      state: 'INGESTING', // Ground pass required to ingest data in before compute
      currentSatelliteId: null,
      targetSatelliteId: 'Awaiting Ground Station Contact Pass',
      migrationCount: 0,
      maxAllowedMigrations: priority == 'CRITICAL' ? 5 : 3,
      checkpointIntervalSeconds: checkpointIntervalSeconds,
      lastCheckpointTime: now,
      lastCheckpointProgress: 0.0,
      checkpointSizeBytes: checkpointSizeBytes,
      cooldownUntil: null,
      wastedComputeSeconds: 0.0,
      createdAt: now,
      deadline: deadlineDuration != null ? now.add(deadlineDuration) : null,
      missedDeadline: false,
    );

    jobs[jobId] = job;

    decisionLog.logDecision(
      actionType: 'PLACEMENT',
      jobId: jobId,
      reasonCode: 'JOB_QUEUED_AWAITING_INGEST',
      explanation: 'Workload $jobId ("$name", $requiredComputeTFlops TFlops, priority $priority) queued. Awaiting Ground Station contact pass for input weight/data ingestion.',
    );

    return job;
  }

  /// Advances runtime for all active jobs by [dtSeconds].
  void advanceRuntime(ConstellationSimulator simulator, double dtSeconds) {
    final now = DateTime.now();

    for (final job in jobs.values) {
      if (job.state == 'COMPLETED' || job.state == 'FAILED') continue;

      // Check deadline
      if (job.deadline != null && now.isAfter(job.deadline!) && !job.missedDeadline) {
        job.missedDeadline = true;
      }

      // 1. Check INGESTING state (Data In phase via ground pass)
      if (job.state == 'INGESTING') {
        _advanceDataIngest(job, simulator, dtSeconds);
        continue;
      }

      // 2. Check migrating state (Checkpoint / weights moving over ISL)
      if (job.state == 'MIGRATING') {
        _advanceMigration(job, dtSeconds);
        continue;
      }

      // 3. Check DOWNLINKING state (Results egress / Data Out phase via ground pass)
      if (job.state == 'DOWNLINKING') {
        _advanceDataEgress(job, simulator, dtSeconds);
        continue;
      }

      // 4. If running on a satellite
      if (job.state == 'RUNNING' && job.currentSatelliteId != null) {
        final sat = simulator.satellites[job.currentSatelliteId];
        if (sat == null || sat.status == 'OFFLINE') {
          // Satellite went offline! Trigger failure/recovery
          handleSatelliteOutage(job, simulator);
          continue;
        }

        // Progress calculation: throttled by satellite power/temperature
        final effectiveSpeed = sat.throttleRatio; // 0.1 to 1.0
        final progressDelta = (effectiveSpeed * dtSeconds) / job.totalRuntimeSeconds;

        job.progress = (job.progress + progressDelta).clamp(0.0, 1.0);
        job.completedRuntimeSeconds += (effectiveSpeed * dtSeconds);

        // Check if compute completed -> transition to DOWNLINKING (Data Out)
        if (job.progress >= 1.0) {
          job.state = 'DOWNLINKING';
          job.completedRuntimeSeconds = 0.0; // Reuse as egress progress counter
          // Release compute resources while holding in memory for downlink
          sat.allocatedComputeTFlops = math.max(0.0, sat.allocatedComputeTFlops - job.requiredComputeTFlops);
          job.targetSatelliteId = 'Awaiting Ground Pass for Downlink';

          decisionLog.logDecision(
            actionType: 'PLACEMENT',
            jobId: job.jobId,
            sourceSatelliteId: sat.satelliteId,
            reasonCode: 'COMPUTE_COMPLETE_AWAITING_DOWNLINK',
            explanation: 'Compute finished 100% on ${sat.satelliteId}. Workload transitioned to DOWNLINKING: awaiting Ground Station pass to downlink output weights and inferences.',
          );
          continue;
        }

        // Periodic Checkpointing
        final timeSinceCheckpoint = now.difference(job.lastCheckpointTime ?? job.createdAt).inSeconds.toDouble();
        if (timeSinceCheckpoint >= job.checkpointIntervalSeconds) {
          _createCheckpoint(job);
        }
      }
    }
  }

  void _advanceDataIngest(Job job, ConstellationSimulator simulator, double dtSeconds) {
    // If not yet assigned to a satellite, scheduler will place it once a node is selected
    if (job.currentSatelliteId == null) return;

    final sat = simulator.satellites[job.currentSatelliteId];
    if (sat == null) return;

    final activePass = simulator.getActiveGroundPass(sat.satelliteId);

    // If satellite has active ground pass or connected to an ISL peer in ground pass
    if (activePass != null) {
      job.completedRuntimeSeconds += dtSeconds;
      const ingestTargetSec = 8.0; // Ingest takes ~8 seconds of link time
      final ingestFraction = (job.completedRuntimeSeconds / ingestTargetSec).clamp(0.0, 1.0);
      job.targetSatelliteId = '${activePass.stationName} (Ingest ${(ingestFraction * 100).toInt()}%)';

      if (ingestFraction >= 1.0) {
        job.state = 'RUNNING';
        job.completedRuntimeSeconds = 0.0;
        job.targetSatelliteId = null;

        decisionLog.logDecision(
          actionType: 'PLACEMENT',
          jobId: job.jobId,
          sourceSatelliteId: sat.satelliteId,
          reasonCode: 'GROUND_INGEST_COMPLETE',
          explanation: 'Data Ingest complete via ${activePass.stationName}. Model weights and data payload uploaded over 10 Gbps feeder link. Compute initiated on ${sat.satelliteId}.',
        );
      }
    } else {
      job.targetSatelliteId = 'Awaiting Ground Station Contact Pass';
    }
  }

  void _advanceDataEgress(Job job, ConstellationSimulator simulator, double dtSeconds) {
    if (job.currentSatelliteId == null) return;

    final sat = simulator.satellites[job.currentSatelliteId];
    if (sat == null) return;

    final activePass = simulator.getActiveGroundPass(sat.satelliteId);

    if (activePass != null) {
      job.completedRuntimeSeconds += dtSeconds;
      const egressTargetSec = 6.0; // Egress takes ~6 seconds of link time
      final egressFraction = (job.completedRuntimeSeconds / egressTargetSec).clamp(0.0, 1.0);
      job.targetSatelliteId = '${activePass.stationName} (Downlink ${(egressFraction * 100).toInt()}%)';

      if (egressFraction >= 1.0) {
        job.state = 'COMPLETED';
        sat.activeJobIds.remove(job.jobId);
        job.targetSatelliteId = 'Downlinked to ${activePass.stationName}';

        decisionLog.logDecision(
          actionType: 'PLACEMENT',
          jobId: job.jobId,
          sourceSatelliteId: sat.satelliteId,
          reasonCode: 'GROUND_DOWNLINK_COMPLETE',
          explanation: 'Results egress complete via ${activePass.stationName}. Trained weights and model output artifacts successfully downlinked. Overall workload lifecycle 100% finished.',
        );
      }
    } else {
      job.targetSatelliteId = 'Awaiting Ground Station Contact Pass';
    }
  }

  /// Preempts a running lower-priority job to free compute for a higher-priority arrival.
  bool preemptJob(Job victim, Job preemptor, ConstellationSimulator simulator) {
    if (victim.currentSatelliteId == null) return false;

    final sat = simulator.satellites[victim.currentSatelliteId];
    if (sat == null) return false;

    // 1. Take clean emergency checkpoint of the victim before evicting
    _createCheckpoint(victim);

    // 2. Free compute on satellite
    sat.activeJobIds.remove(victim.jobId);
    sat.allocatedComputeTFlops = math.max(0.0, sat.allocatedComputeTFlops - victim.requiredComputeTFlops);

    // 3. Mark victim as PREEMPTED
    victim.state = 'PREEMPTED';
    victim.targetSatelliteId = 'Preempted by ${preemptor.jobId} (${preemptor.priority})';
    final evictedFrom = victim.currentSatelliteId;
    victim.currentSatelliteId = null;

    decisionLog.logDecision(
      actionType: 'EVICTION',
      jobId: victim.jobId,
      sourceSatelliteId: evictedFrom,
      reasonCode: 'PRIORITY_PREEMPTION_EVICTION',
      explanation: 'Priority Preemption: High-priority workload ${preemptor.jobId} (${preemptor.priority}) preempted lower-priority workload ${victim.jobId} (${victim.priority}) on $evictedFrom. Checkpoint cleanly preserved at ${(victim.progress * 100).toStringAsFixed(1)}% progress. Victim queued to resume.',
    );

    return true;
  }

  void _createCheckpoint(Job job) {
    final now = DateTime.now();
    final chkId = 'CHK-${job.jobId}-${(job.progress * 100).toInt()}';

    final checkpoint = Checkpoint(
      checkpointId: chkId,
      jobId: job.jobId,
      satelliteId: job.currentSatelliteId ?? 'UNASSIGNED',
      progress: job.progress,
      sizeMb: (job.checkpointSizeBytes / (1024 * 1024)),
      state: 'STORED',
      transferBandwidthMbps: 0.0,
      transferProgress: 1.0,
      timestamp: now,
    );

    checkpoints.insert(0, checkpoint);
    if (checkpoints.length > 100) checkpoints.removeLast();

    job.lastCheckpointTime = now;
    job.lastCheckpointProgress = job.progress;

    decisionLog.logDecision(
      actionType: 'CHECKPOINT',
      jobId: job.jobId,
      sourceSatelliteId: job.currentSatelliteId,
      reasonCode: 'PERIODIC_CHECKPOINT_SAVED',
      explanation: 'State checkpoint $chkId saved at ${(job.progress * 100).toStringAsFixed(1)}% progress (${checkpoint.sizeMb.toStringAsFixed(1)} MB).',
    );
  }

  /// Begins migration of a job from current satellite to [targetSatelliteId].
  bool initiateMigration(Job job, String targetSatelliteId, ConstellationSimulator simulator) {
    if (job.migrationCount >= job.maxAllowedMigrations) {
      decisionLog.logDecision(
        actionType: 'REJECTION',
        jobId: job.jobId,
        sourceSatelliteId: job.currentSatelliteId,
        targetSatelliteId: targetSatelliteId,
        reasonCode: 'MIGRATION_BUDGET_EXCEEDED',
        explanation: 'Migration blocked: ${job.jobId} reached max migration cap (${job.migrationCount}/${job.maxAllowedMigrations}).',
      );
      return false;
    }

    final now = DateTime.now();
    if (job.cooldownUntil != null && now.isBefore(job.cooldownUntil!)) {
      decisionLog.logDecision(
        actionType: 'REJECTION',
        jobId: job.jobId,
        sourceSatelliteId: job.currentSatelliteId,
        targetSatelliteId: targetSatelliteId,
        reasonCode: 'COOLDOWN_ACTIVE_SUPPRESSED',
        explanation: 'Anti ping-pong cooldown active until ${job.cooldownUntil!.toIso8601String()}. Migration suppressed.',
      );
      return false;
    }

    final sourceSat = simulator.satellites[job.currentSatelliteId];
    final targetSat = simulator.satellites[targetSatelliteId];

    if (targetSat == null || targetSat.status == 'OFFLINE') return false;

    // Transition job to MIGRATING
    final prevSatId = job.currentSatelliteId;
    job.state = 'MIGRATING';
    job.targetSatelliteId = targetSatelliteId;
    job.migrationCount++;

    // Free compute from source
    if (sourceSat != null) {
      sourceSat.activeJobIds.remove(job.jobId);
      sourceSat.allocatedComputeTFlops = math.max(0.0, sourceSat.allocatedComputeTFlops - job.requiredComputeTFlops);
    }

    // Reserve compute on target
    targetSat.allocatedComputeTFlops += job.requiredComputeTFlops;

    // Checkpoint in transit
    final chkId = 'CHK-MIG-${job.jobId}-${DateTime.now().millisecondsSinceEpoch % 10000}';
    final checkpoint = Checkpoint(
      checkpointId: chkId,
      jobId: job.jobId,
      satelliteId: targetSatelliteId,
      progress: job.progress,
      sizeMb: (job.checkpointSizeBytes / (1024 * 1024)),
      state: 'IN_TRANSIT',
      transferBandwidthMbps: 4000.0, // Capped ISL laser transfer bandwidth (4 Gbps)
      transferProgress: 0.0,
      sourceSatelliteId: prevSatId,
      destinationSatelliteId: targetSatelliteId,
      timestamp: now,
    );
    checkpoints.insert(0, checkpoint);

    decisionLog.logDecision(
      actionType: 'MIGRATION',
      jobId: job.jobId,
      sourceSatelliteId: prevSatId,
      targetSatelliteId: targetSatelliteId,
      reasonCode: 'PROACTIVE_LOOKAHEAD_MIGRATION',
      explanation: 'Initiated proactive migration from $prevSatId to $targetSatelliteId. Syncing checkpoint over ISL laser mesh.',
    );

    return true;
  }

  void _advanceMigration(Job job, double dtSeconds) {
    // Checkpoint transfer time: e.g. 2GB @ 4 Gbps = 4 seconds
    final sizeMb = (job.checkpointSizeBytes / (1024 * 1024));
    final transferDurationSec = math.max(2.0, (sizeMb * 8.0) / 4000.0);

    // Find active transit checkpoint
    final chk = checkpoints.firstWhere(
      (c) => c.jobId == job.jobId && c.state == 'IN_TRANSIT',
      orElse: () => Checkpoint(
        checkpointId: 'CHK-NONE',
        jobId: job.jobId,
        satelliteId: job.targetSatelliteId ?? '',
        progress: job.progress,
        sizeMb: 100.0,
        state: 'IN_TRANSIT',
        transferBandwidthMbps: 4000.0,
        transferProgress: 1.0,
        timestamp: DateTime.now(),
      ),
    );

    chk.transferProgress = (chk.transferProgress + (dtSeconds / transferDurationSec)).clamp(0.0, 1.0);

    if (chk.transferProgress >= 1.0) {
      // Migration complete!
      chk.state = 'STORED';
      job.state = 'RUNNING';
      job.currentSatelliteId = job.targetSatelliteId;
      job.targetSatelliteId = null;
      // Set cooldown (e.g. 120s cooldown to prevent ping-pong)
      job.cooldownUntil = DateTime.now().add(const Duration(seconds: 120));

      decisionLog.logDecision(
        actionType: 'PLACEMENT',
        jobId: job.jobId,
        targetSatelliteId: job.currentSatelliteId,
        reasonCode: 'MIGRATION_TRANSFER_COMPLETED',
        explanation: 'Checkpoint transfer finished. Workload ${job.jobId} resumed execution on ${job.currentSatelliteId}.',
      );
    }
  }

  /// Handles failure / radiation upset / satellite loss: rolls back job to last checkpoint.
  void rollbackJobOnFault(Job job, String faultDescription) {
    final wasted = (job.progress - job.lastCheckpointProgress) * job.totalRuntimeSeconds;
    job.wastedComputeSeconds += math.max(0.0, wasted);
    job.progress = job.lastCheckpointProgress;
    job.completedRuntimeSeconds = job.progress * job.totalRuntimeSeconds;
    job.state = 'UNPLACEABLE'; // Re-queue into safe holding queue to avoid re-faulting on same damaged node
    job.currentSatelliteId = null;
    job.targetSatelliteId = 'Rolled back to checkpoint • Awaiting safe node';

    decisionLog.logDecision(
      actionType: 'ROLLBACK',
      jobId: job.jobId,
      reasonCode: 'RADIATION_UPSET_ROLLBACK',
      explanation: 'Fault alert ("$faultDescription"). Rolled back ${job.jobId} to last checkpoint at ${(job.lastCheckpointProgress * 100).toStringAsFixed(1)}%. Wasted ${wasted.toStringAsFixed(1)}s compute. Deferred to safe queue.',
    );
  }

  void handleSatelliteOutage(Job job, ConstellationSimulator simulator) {
    rollbackJobOnFault(job, 'Satellite ${job.currentSatelliteId} sudden power loss/offline outage');
  }
}
