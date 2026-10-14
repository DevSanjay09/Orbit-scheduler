import '../generated/protocol.dart';
import '../simulation/constellation_simulator.dart';
import '../runtime/job_runtime.dart';
import '../decision_log/decision_log_manager.dart';
import 'scheduler_interface.dart';

/// The primary intelligent Orbital Workload Scheduler with multi-hour Lookahead forecasting,
/// Ground Station pass awareness, priority preemption, and unplaceable safe hold queue.
class OrbitLookaheadScheduler implements SchedulerInterface {
  @override
  String get name => 'ORBIT_LOOKAHEAD';

  final DecisionLogManager decisionLog;

  OrbitLookaheadScheduler({required this.decisionLog});

  @override
  void schedule({
    required ConstellationSimulator simulator,
    required JobRuntime runtime,
    required List<Policy> activePolicies,
  }) {
    // 1. Proactive Lookahead Check for Running Jobs (Eclipse & Thermal Evacuation)
    _checkRunningJobsForMigration(simulator, runtime, activePolicies);

    // 2. Placement Loop for Pending/Ingesting/Preempted/Unplaceable Jobs with Priority & Preemption
    _placePendingJobs(simulator, runtime, activePolicies);
  }

  void _checkRunningJobsForMigration(
    ConstellationSimulator simulator,
    JobRuntime runtime,
    List<Policy> activePolicies,
  ) {
    for (final job in runtime.jobs.values) {
      if (job.state != 'RUNNING' || job.currentSatelliteId == null) continue;

      final currentSat = simulator.satellites[job.currentSatelliteId];
      if (currentSat == null) continue;

      // Check migration budget and cooldown
      if (job.migrationCount >= job.maxAllowedMigrations) continue;
      if (job.cooldownUntil != null && DateTime.now().isBefore(job.cooldownUntil!)) continue;

      // Remaining runtime (in seconds)
      final remainingRuntimeSec = (1.0 - job.progress) * job.totalRuntimeSeconds;
      final checkpointTransferTimeSec = ((job.checkpointSizeBytes / (1024 * 1024)) * 8.0) / 4000.0; // 4 Gbps cap

      // Get multi-hour telemetry forecast for current satellite
      final forecast = simulator.generateForecast(job.currentSatelliteId!, horizonHours: 2.5);
      final predictedSafeWindowSec = forecast.predictedSafeWindowSeconds;

      // RULE: Migrate if predicted safe window is shorter than remaining runtime plus checkpoint transfer time (with 90s safety margin)
      final requiredSafetySec = remainingRuntimeSec + checkpointTransferTimeSec + 90.0;

      // Also migrate if policy violation predicted (e.g. thermal max)
      final policyThermalMax = _getPolicyLimit(activePolicies, 'THERMAL_MAX', defaultValue: 68.0);
      final predictedOverheat = forecast.temperatureList.any((t) => t > policyThermalMax);

      final needsMigration = (predictedSafeWindowSec < requiredSafetySec && remainingRuntimeSec > 120.0) || predictedOverheat;

      if (needsMigration) {
        // Find best target satellite connected via open ISL link or mesh route
        final targetSat = _findOptimalTargetSatellite(
          job: job,
          currentSatId: job.currentSatelliteId!,
          simulator: simulator,
          activePolicies: activePolicies,
          minSafeDurationSec: requiredSafetySec,
        );

        if (targetSat != null) {
          final success = runtime.initiateMigration(job, targetSat.satelliteId, simulator);
          if (success) {
            final reason = predictedOverheat
                ? 'THERMAL_THROTTLE_EVASION'
                : 'ECLIPSE_BATTERY_EXHAUSTION_PREDICTED';
            decisionLog.logDecision(
              actionType: 'MIGRATION',
              jobId: job.jobId,
              sourceSatelliteId: job.currentSatelliteId,
              targetSatelliteId: targetSat.satelliteId,
              reasonCode: reason,
              explanation:
                  'Proactive migration: ${job.currentSatelliteId} safe window is ${predictedSafeWindowSec.toStringAsFixed(0)}s (requires ${requiredSafetySec.toStringAsFixed(0)}s). Moving to ${targetSat.satelliteId} with ${(targetSat.batterySoC * 100).toStringAsFixed(0)}% battery and open sunlight.',
            );
          }
        }
      }
    }
  }

  void _placePendingJobs(
    ConstellationSimulator simulator,
    JobRuntime runtime,
    List<Policy> activePolicies,
  ) {
    // Sort pending jobs by priority (CRITICAL > HIGH > NORMAL > BATCH)
    final pendingJobs = runtime.jobs.values
        .where((j) =>
            j.state == 'PENDING' ||
            (j.state == 'INGESTING' && j.currentSatelliteId == null) ||
            j.state == 'UNPLACEABLE' ||
            j.state == 'PREEMPTED')
        .toList()
      ..sort((a, b) => _priorityWeight(b.priority).compareTo(_priorityWeight(a.priority)));

    for (final job in pendingJobs) {
      final remainingRuntimeSec = (1.0 - job.progress) * job.totalRuntimeSeconds;

      var targetSat = _findOptimalTargetSatellite(
        job: job,
        currentSatId: null,
        simulator: simulator,
        activePolicies: activePolicies,
        minSafeDurationSec: remainingRuntimeSec,
      );

      // Priority and Preemption rule: If high-priority job cannot be placed safely on empty capacity,
      // search for lower-priority running jobs (BATCH, NORMAL) to preempt.
      if (targetSat == null && (job.priority == 'CRITICAL' || job.priority == 'HIGH')) {
        targetSat = _tryPreemptLowerPriority(job, simulator, runtime, activePolicies);
      }

      if (targetSat != null) {
        // Safe satellite located (or made available via preemption)! Place job
        final wasIngesting = job.state == 'INGESTING';
        job.currentSatelliteId = targetSat.satelliteId;
        targetSat.activeJobIds.add(job.jobId);
        targetSat.allocatedComputeTFlops += job.requiredComputeTFlops;

        // If job was waiting for ingest, start ingesting; otherwise set to RUNNING
        if (wasIngesting) {
          job.state = 'INGESTING';
          final pass = simulator.getActiveGroundPass(targetSat.satelliteId);
          job.targetSatelliteId = pass != null ? '${pass.stationName} (Starting Ingest)' : 'Awaiting Ground Pass on ${targetSat.satelliteId}';
        } else {
          job.state = 'RUNNING';
          job.targetSatelliteId = null;
        }

        decisionLog.logDecision(
          actionType: 'PLACEMENT',
          jobId: job.jobId,
          targetSatelliteId: targetSat.satelliteId,
          reasonCode: 'SAFE_LOOKAHEAD_OPTIMAL',
          explanation:
              'Workload ${job.jobId} (${job.priority}) placed on ${targetSat.satelliteId}. Forecast confirms ${(targetSat.batterySoC * 100).toStringAsFixed(0)}% battery, temp ${targetSat.temperatureC.toStringAsFixed(1)}°C, and safe window >= ${remainingRuntimeSec.toStringAsFixed(0)}s.',
        );
      } else {
        // RULE: A job that can’t be placed safely waits and is reported as unplaceable, rather than being forced onto a risky satellite
        if (job.state != 'UNPLACEABLE' && job.state != 'PREEMPTED') {
          job.state = 'UNPLACEABLE';
          job.targetSatelliteId = 'Awaiting Safe Orbital Window / Pass';
          decisionLog.logDecision(
            actionType: 'REJECTION',
            jobId: job.jobId,
            reasonCode: 'UNPLACEABLE_NO_SAFE_WINDOW_WAITING',
            explanation:
                'Workload ${job.jobId} deferred to safe holding queue: no satellite currently meets the multi-hour safe window requirement without shadow/thermal risks.',
          );
        }
      }
    }
  }

  /// Attempts to preempt a lower-priority running job to free compute on a healthy satellite.
  SimSatellite? _tryPreemptLowerPriority(
    Job highPriorityJob,
    ConstellationSimulator simulator,
    JobRuntime runtime,
    List<Policy> activePolicies,
  ) {
    final highPriorityVal = _priorityWeight(highPriorityJob.priority);

    // Look for running jobs with strictly lower priority (prefer BATCH first, then NORMAL)
    final runningVictims = runtime.jobs.values
        .where((j) => j.state == 'RUNNING' && j.currentSatelliteId != null && _priorityWeight(j.priority) < highPriorityVal)
        .toList()
      ..sort((a, b) => _priorityWeight(a.priority).compareTo(_priorityWeight(b.priority)));

    for (final victim in runningVictims) {
      final sat = simulator.satellites[victim.currentSatelliteId];
      if (sat == null || sat.status == 'OFFLINE') continue;

      // Check if evicting victim provides enough compute headroom
      final potentialAvailable = (sat.totalComputeTFlops - sat.allocatedComputeTFlops) + victim.requiredComputeTFlops;
      if (potentialAvailable < highPriorityJob.requiredComputeTFlops) continue;

      // Check if satellite has good forecast for the incoming high priority job
      final forecast = simulator.generateForecast(sat.satelliteId, horizonHours: 2.0);
      final remainingSec = (1.0 - highPriorityJob.progress) * highPriorityJob.totalRuntimeSeconds;
      if (forecast.predictedSafeWindowSeconds < remainingSec * 0.75) continue;

      // Found suitable preemption target! Evict victim cleanly
      final success = runtime.preemptJob(victim, highPriorityJob, simulator);
      if (success) {
        return sat;
      }
    }

    return null;
  }

  SimSatellite? _findOptimalTargetSatellite({
    required Job job,
    required String? currentSatId,
    required ConstellationSimulator simulator,
    required List<Policy> activePolicies,
    required double minSafeDurationSec,
  }) {
    SimSatellite? bestSat;
    double highestScore = -999999.0;

    final policyThermalMax = _getPolicyLimit(activePolicies, 'THERMAL_MAX', defaultValue: 66.0);
    final policyBatteryMin = _getPolicyLimit(activePolicies, 'BATTERY_MIN', defaultValue: 0.30);

    for (final sat in simulator.satellites.values) {
      if (sat.status == 'OFFLINE') continue;
      if (sat.satelliteId == currentSatId) continue;

      // Check available compute headroom
      final availableCompute = sat.totalComputeTFlops - sat.allocatedComputeTFlops;
      if (availableCompute < job.requiredComputeTFlops) continue;

      // Policy checks
      if (sat.temperatureC > policyThermalMax) continue;
      if (sat.batterySoC < policyBatteryMin) continue;

      // Generate forward forecast for candidate
      final forecast = simulator.generateForecast(sat.satelliteId, horizonHours: 2.0);
      if (forecast.predictedSafeWindowSeconds < minSafeDurationSec * 0.85) {
        // Will not remain safe long enough
        continue;
      }

      // Connectivity score: if migrating, check if ISL link is available
      double connectivityBonus = 0.0;
      if (currentSatId != null) {
        final directLink = simulator.activeLinks.any((l) =>
            (l.sourceSatelliteId == currentSatId && l.targetSatelliteId == sat.satelliteId) ||
            (l.sourceSatelliteId == sat.satelliteId && l.targetSatelliteId == currentSatId));
        if (directLink) {
          connectivityBonus = 50.0; // Direct 10Gbps ISL link
        }
      }

      // Ground pass bonus: if job needs data ingest, heavily favor satellites currently over ground stations
      double groundPassBonus = 0.0;
      if (job.state == 'INGESTING') {
        if (simulator.isSatelliteInGroundContact(sat.satelliteId)) {
          groundPassBonus = 75.0; // Currently in ground contact pass
        } else {
          final timeToPass = simulator.predictTimeToNextGroundPass(sat.satelliteId, horizonSec: 1800.0);
          if (timeToPass < 300.0) {
            groundPassBonus = 35.0; // Pass within 5 minutes
          }
        }
      }

      // Multi-factor fitness score:
      // High battery SoC, cool thermal headroom, safe window, solar flux, low existing load
      final score = (sat.batterySoC * 100.0) +
          (sat.thermalHeadroom * 2.0) +
          (sat.inSunlight ? 40.0 : -30.0) +
          (availableCompute * 0.5) +
          connectivityBonus +
          groundPassBonus -
          (sat.isThrottled ? 200.0 : 0.0);

      if (score > highestScore) {
        highestScore = score;
        bestSat = sat;
      }
    }

    return bestSat;
  }

  @override
  void onFault({
    required FaultEvent fault,
    required ConstellationSimulator simulator,
    required JobRuntime runtime,
  }) {
    final affectedSatId = fault.targetSatelliteId;
    final affectedJobs = runtime.jobs.values
        .where((j) => j.currentSatelliteId == affectedSatId && j.state == 'RUNNING')
        .toList();

    for (final job in affectedJobs) {
      runtime.rollbackJobOnFault(job, fault.description);
    }

    // Trigger immediate re-schedule after fault rollback
    schedule(simulator: simulator, runtime: runtime, activePolicies: []);
  }

  double _getPolicyLimit(List<Policy> policies, String type, {required double defaultValue}) {
    for (final p in policies) {
      if (p.isActive && p.constraintType == type) {
        return p.parameterValue;
      }
    }
    return defaultValue;
  }

  int _priorityWeight(String priority) {
    switch (priority) {
      case 'CRITICAL':
        return 4;
      case 'HIGH':
        return 3;
      case 'NORMAL':
        return 2;
      case 'BATCH':
        return 1;
      default:
        return 0;
    }
  }
}
