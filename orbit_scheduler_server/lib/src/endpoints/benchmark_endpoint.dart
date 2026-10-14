import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../engine/orbit_engine.dart';

class BenchmarkEndpoint extends Endpoint {
  /// Runs the comparative benchmark suite across seeded fault sequences.
  Future<List<BenchmarkRun>> runBenchmarks(Session session, List<int>? seeds) async {
    final harness = OrbitEngine.instance.benchmarkHarness;
    final seedList = seeds ?? [42, 101, 777];

    final reports = harness.runComparativeSuite(seeds: seedList, jobsPerRun: 15, simDurationSeconds: 1800.0);
    final allRuns = <BenchmarkRun>[];
    for (final report in reports) {
      allRuns.addAll(report.individualRuns);
    }
    return allRuns;
  }
}
