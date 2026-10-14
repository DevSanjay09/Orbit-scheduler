import '../generated/protocol.dart';
import '../simulation/constellation_simulator.dart';
import '../runtime/job_runtime.dart';

/// Common interface for scheduler implementations.
abstract class SchedulerInterface {
  String get name;

  /// Runs scheduling loop step: places pending jobs and checks for proactive migrations.
  void schedule({
    required ConstellationSimulator simulator,
    required JobRuntime runtime,
    required List<Policy> activePolicies,
  });

  /// Immediate re-plan triggered upon a fault event.
  void onFault({
    required FaultEvent fault,
    required ConstellationSimulator simulator,
    required JobRuntime runtime,
  });
}
