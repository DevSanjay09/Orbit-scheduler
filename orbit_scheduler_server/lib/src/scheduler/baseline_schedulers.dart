import '../generated/protocol.dart';
import '../simulation/constellation_simulator.dart';
import '../runtime/job_runtime.dart';
import 'scheduler_interface.dart';

/// Round-Robin baseline scheduler: cyclic assignment ignoring solar/thermal states.
class RoundRobinScheduler implements SchedulerInterface {
  @override
  String get name => 'ROUND_ROBIN';

  int _currentIndex = 0;

  @override
  void schedule({
    required ConstellationSimulator simulator,
    required JobRuntime runtime,
    required List<Policy> activePolicies,
  }) {
    final sats = simulator.satellites.values.where((s) => s.status != 'OFFLINE').toList();
    if (sats.isEmpty) return;

    final pending = runtime.jobs.values.where((j) => j.state == 'PENDING' || j.state == 'UNPLACEABLE').toList();
    for (final job in pending) {
      final sat = sats[_currentIndex % sats.length];
      _currentIndex++;

      if (sat.allocatedComputeTFlops + job.requiredComputeTFlops <= sat.totalComputeTFlops) {
        job.state = 'RUNNING';
        job.currentSatelliteId = sat.satelliteId;
        sat.activeJobIds.add(job.jobId);
        sat.allocatedComputeTFlops += job.requiredComputeTFlops;
      }
    }
  }

  @override
  void onFault({
    required FaultEvent fault,
    required ConstellationSimulator simulator,
    required JobRuntime runtime,
  }) {
    final affectedJobs = runtime.jobs.values
        .where((j) => j.currentSatelliteId == fault.targetSatelliteId && j.state == 'RUNNING')
        .toList();
    for (final job in affectedJobs) {
      runtime.rollbackJobOnFault(job, 'Round-robin fault hit: ${fault.description}');
    }
  }
}

/// Greedy Least-Loaded baseline scheduler: places on lowest current load, no future lookahead.
class GreedyLeastLoadedScheduler implements SchedulerInterface {
  @override
  String get name => 'GREEDY_LEAST_LOADED';

  @override
  void schedule({
    required ConstellationSimulator simulator,
    required JobRuntime runtime,
    required List<Policy> activePolicies,
  }) {
    final pending = runtime.jobs.values.where((j) => j.state == 'PENDING' || j.state == 'UNPLACEABLE').toList();

    for (final job in pending) {
      SimSatellite? bestSat;
      double lowestLoad = 999999.0;

      for (final sat in simulator.satellites.values) {
        if (sat.status == 'OFFLINE') continue;
        if (sat.allocatedComputeTFlops + job.requiredComputeTFlops > sat.totalComputeTFlops) continue;

        if (sat.allocatedComputeTFlops < lowestLoad) {
          lowestLoad = sat.allocatedComputeTFlops;
          bestSat = sat;
        }
      }

      if (bestSat != null) {
        job.state = 'RUNNING';
        job.currentSatelliteId = bestSat.satelliteId;
        bestSat.activeJobIds.add(job.jobId);
        bestSat.allocatedComputeTFlops += job.requiredComputeTFlops;
      }
    }
  }

  @override
  void onFault({
    required FaultEvent fault,
    required ConstellationSimulator simulator,
    required JobRuntime runtime,
  }) {
    final affectedJobs = runtime.jobs.values
        .where((j) => j.currentSatelliteId == fault.targetSatelliteId && j.state == 'RUNNING')
        .toList();
    for (final job in affectedJobs) {
      runtime.rollbackJobOnFault(job, 'Greedy fault hit: ${fault.description}');
    }
  }
}

/// Ablation Baseline: Myopic Scheduler (NO Lookahead).
/// Places jobs on lowest current load, with zero forward forecasting.
/// Only moves jobs reactively AFTER battery drops below 15% or temp exceeds 68°C.
class AblationMyopicScheduler implements SchedulerInterface {
  @override
  String get name => 'ABLATION_NO_LOOKAHEAD';

  @override
  void schedule({
    required ConstellationSimulator simulator,
    required JobRuntime runtime,
    required List<Policy> activePolicies,
  }) {
    // 1. Reactive Emergency Migration (Only after node is ALREADY in danger!)
    for (final job in runtime.jobs.values) {
      if (job.state != 'RUNNING' || job.currentSatelliteId == null) continue;
      final currentSat = simulator.satellites[job.currentSatelliteId];
      if (currentSat == null) continue;

      // Reactive trigger: only triggers when ALREADY failing (SoC < 15% or Temp > 68°C)
      if (currentSat.batterySoC < 0.15 || currentSat.temperatureC > 68.0) {
        // Scramble to find any online satellite
        for (final sat in simulator.satellites.values) {
          if (sat.status != 'OFFLINE' &&
              sat.satelliteId != currentSat.satelliteId &&
              sat.allocatedComputeTFlops + job.requiredComputeTFlops <= sat.totalComputeTFlops &&
              sat.batterySoC > 0.30) {
            runtime.initiateMigration(job, sat.satelliteId, simulator);
            break;
          }
        }
      }
    }

    // 2. Greedy Placement for pending/unplaceable jobs (no lookahead)
    final pending = runtime.jobs.values.where((j) => j.state == 'PENDING' || j.state == 'UNPLACEABLE').toList();
    for (final job in pending) {
      SimSatellite? bestSat;
      double lowestLoad = 999999.0;
      for (final sat in simulator.satellites.values) {
        if (sat.status == 'OFFLINE') continue;
        if (sat.allocatedComputeTFlops + job.requiredComputeTFlops > sat.totalComputeTFlops) continue;
        if (sat.allocatedComputeTFlops < lowestLoad) {
          lowestLoad = sat.allocatedComputeTFlops;
          bestSat = sat;
        }
      }

      if (bestSat != null) {
        job.state = 'RUNNING';
        job.currentSatelliteId = bestSat.satelliteId;
        bestSat.activeJobIds.add(job.jobId);
        bestSat.allocatedComputeTFlops += job.requiredComputeTFlops;
      }
    }
  }

  @override
  void onFault({
    required FaultEvent fault,
    required ConstellationSimulator simulator,
    required JobRuntime runtime,
  }) {
    final affectedJobs = runtime.jobs.values
        .where((j) => j.currentSatelliteId == fault.targetSatelliteId && j.state == 'RUNNING')
        .toList();
    for (final job in affectedJobs) {
      runtime.rollbackJobOnFault(job, 'Ablation reactive fault: ${fault.description}');
    }
  }
}

/// No-Migration baseline scheduler: places jobs and NEVER moves them.
class NoMigrationScheduler implements SchedulerInterface {
  @override
  String get name => 'NO_MIGRATION';

  @override
  void schedule({
    required ConstellationSimulator simulator,
    required JobRuntime runtime,
    required List<Policy> activePolicies,
  }) {
    // Only places pending jobs; NEVER migrates running jobs
    final pending = runtime.jobs.values.where((j) => j.state == 'PENDING' || j.state == 'UNPLACEABLE').toList();

    for (final job in pending) {
      SimSatellite? candidateSat;
      for (final sat in simulator.satellites.values) {
        if (sat.status != 'OFFLINE' &&
            sat.allocatedComputeTFlops + job.requiredComputeTFlops <= sat.totalComputeTFlops) {
          candidateSat = sat;
          break;
        }
      }

      if (candidateSat != null) {
        job.state = 'RUNNING';
        job.currentSatelliteId = candidateSat.satelliteId;
        candidateSat.activeJobIds.add(job.jobId);
        candidateSat.allocatedComputeTFlops += job.requiredComputeTFlops;
      }
    }
  }

  @override
  void onFault({
    required FaultEvent fault,
    required ConstellationSimulator simulator,
    required JobRuntime runtime,
  }) {
    final affectedJobs = runtime.jobs.values
        .where((j) => j.currentSatelliteId == fault.targetSatelliteId && j.state == 'RUNNING')
        .toList();
    for (final job in affectedJobs) {
      runtime.rollbackJobOnFault(job, 'No-migration static failure: ${fault.description}');
    }
  }
}
