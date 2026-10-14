import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../engine/orbit_engine.dart';

class JobEndpoint extends Endpoint {
  /// Lists all submitted, active, and completed jobs.
  Future<List<Job>> listJobs(Session session) async {
    return OrbitEngine.instance.runtime.jobs.values.toList();
  }

  /// Submits a new AI workload to the platform.
  Future<Job> submitJob(
    Session session, {
    required String name,
    required String priority,
    required double totalRuntimeSeconds,
    required double requiredComputeTFlops,
    double checkpointIntervalSeconds = 180.0,
  }) async {
    return OrbitEngine.instance.runtime.submitJob(
      name: name,
      priority: priority,
      totalRuntimeSeconds: totalRuntimeSeconds,
      requiredComputeTFlops: requiredComputeTFlops,
      checkpointIntervalSeconds: checkpointIntervalSeconds,
    );
  }

  /// Lists checkpoints for inspection.
  Future<List<Checkpoint>> listCheckpoints(Session session, String? jobId) async {
    final all = OrbitEngine.instance.runtime.checkpoints;
    if (jobId == null || jobId.isEmpty) return all;
    return all.where((c) => c.jobId == jobId).toList();
  }
}
