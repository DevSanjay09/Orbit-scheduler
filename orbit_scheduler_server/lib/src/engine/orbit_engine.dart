import 'dart:async';
import '../generated/protocol.dart';
import '../simulation/constellation_simulator.dart';
import '../faults/fault_engine.dart';
import '../runtime/job_runtime.dart';
import '../decision_log/decision_log_manager.dart';
import '../scheduler/orbit_lookahead_scheduler.dart';
import '../ai/gemini_operator_assistant.dart';
import '../benchmark/benchmark_harness.dart';

/// Master Engine coordinating simulation, runtime, scheduler, fault injection, and real-time streaming.
class OrbitEngine {
  static OrbitEngine? _instance;
  static OrbitEngine get instance => _instance ??= OrbitEngine._();

  late final ConstellationSimulator simulator;
  late final FaultEngine faultEngine;
  late final DecisionLogManager decisionLog;
  late final JobRuntime runtime;
  late final OrbitLookaheadScheduler scheduler;
  late final GeminiOperatorAssistant assistant;
  late final BenchmarkHarness benchmarkHarness;

  final List<Policy> activePolicies = [];
  Timer? _loopTimer;
  bool isRunning = false;
  double simSpeedMultiplier = 5.0; // 5x real-time for dynamic satellite orbital movement

  // Stream controllers for real-time Serverpod streaming endpoints
  final StreamController<ConstellationState> _stateStreamController =
      StreamController<ConstellationState>.broadcast();
  final StreamController<FaultEvent> _faultStreamController =
      StreamController<FaultEvent>.broadcast();
  final StreamController<DecisionLogEntry> _decisionStreamController =
      StreamController<DecisionLogEntry>.broadcast();

  Stream<ConstellationState> get stateStream => _stateStreamController.stream;
  Stream<FaultEvent> get faultStream => _faultStreamController.stream;
  Stream<DecisionLogEntry> get decisionStream => _decisionStreamController.stream;

  OrbitEngine._() {
    _initEngine();
  }

  void _initEngine() {
    decisionLog = DecisionLogManager();
    simulator = ConstellationSimulator();
    faultEngine = FaultEngine(seed: 42);
    runtime = JobRuntime(decisionLog: decisionLog);
    scheduler = OrbitLookaheadScheduler(decisionLog: decisionLog);
    assistant = GeminiOperatorAssistant(apiKey: GeminiOperatorAssistant.defaultKey);
    benchmarkHarness = BenchmarkHarness();

    // Wire fault listener
    faultEngine.addListener((fault) {
      _faultStreamController.add(fault);
      scheduler.onFault(
        fault: fault,
        simulator: simulator,
        runtime: runtime,
      );
    });

    // Populate initial default policies
    _seedDefaultPolicies();

    // Populate initial realistic workloads
    _seedInitialJobs();

    // Start background simulation loop
    start();
  }

  void _seedDefaultPolicies() {
    activePolicies.add(Policy(
      policyId: 'POL-DEF-01',
      name: 'Orbital Thermal Protection Limit',
      naturalLanguagePrompt: 'Keep training jobs off satellites above 66°C thermal load',
      constraintType: 'THERMAL_MAX',
      parameterValue: 66.0,
      rawJsonRules: '{"type":"THERMAL_MAX","value":66.0}',
      isActive: true,
      operatorConfirmed: true,
      createdAt: DateTime.now(),
    ));

    activePolicies.add(Policy(
      policyId: 'POL-DEF-02',
      name: 'Eclipse Battery Reserve Floor',
      naturalLanguagePrompt: 'Maintain at least 30% battery reserve across eclipse passes',
      constraintType: 'BATTERY_MIN',
      parameterValue: 0.30,
      rawJsonRules: '{"type":"BATTERY_MIN","value":0.30}',
      isActive: true,
      operatorConfirmed: true,
      createdAt: DateTime.now(),
    ));

    activePolicies.add(Policy(
      policyId: 'POL-DEF-03',
      name: 'Anti Ping-Pong Migration Ceiling',
      naturalLanguagePrompt: 'Limit migrations to maximum 3 hops per workload',
      constraintType: 'MIGRATION_CAP',
      parameterValue: 3.0,
      rawJsonRules: '{"type":"MIGRATION_CAP","value":3.0}',
      isActive: true,
      operatorConfirmed: true,
      createdAt: DateTime.now(),
    ));

    activePolicies.add(Policy(
      policyId: 'POL-DEF-04',
      name: 'Priority Preemption Enforcement',
      naturalLanguagePrompt: 'Preempt BATCH jobs when CRITICAL or HIGH workloads arrive without capacity',
      constraintType: 'PRIORITY_RESERVE',
      parameterValue: 1.0,
      rawJsonRules: '{"type":"PRIORITY_RESERVE","value":1.0}',
      isActive: true,
      operatorConfirmed: true,
      createdAt: DateTime.now(),
    ));

    activePolicies.add(Policy(
      policyId: 'POL-DEF-05',
      name: 'Ground Station Pass Ingest & Egress',
      naturalLanguagePrompt: 'Require ground-station pass contact for data ingest and results egress',
      constraintType: 'GROUND_PASS_MANDATORY',
      parameterValue: 1.0,
      rawJsonRules: '{"type":"GROUND_PASS_MANDATORY","value":1.0}',
      isActive: true,
      operatorConfirmed: true,
      createdAt: DateTime.now(),
    ));
  }

  void _seedInitialJobs() {
    runtime.submitJob(
      name: 'GPT-Shard-Alpha',
      priority: 'CRITICAL',
      totalRuntimeSeconds: 1200.0,
      requiredComputeTFlops: 45.0,
      checkpointIntervalSeconds: 180.0,
    );

    runtime.submitJob(
      name: 'ResNet-Vision-Embed',
      priority: 'HIGH',
      totalRuntimeSeconds: 900.0,
      requiredComputeTFlops: 30.0,
      checkpointIntervalSeconds: 150.0,
    );

    runtime.submitJob(
      name: 'Climate-ERA5-Inference',
      priority: 'NORMAL',
      totalRuntimeSeconds: 1800.0,
      requiredComputeTFlops: 25.0,
      checkpointIntervalSeconds: 240.0,
    );

    runtime.submitJob(
      name: 'Astro-Transient-Search',
      priority: 'BATCH',
      totalRuntimeSeconds: 2400.0,
      requiredComputeTFlops: 20.0,
      checkpointIntervalSeconds: 300.0,
    );
  }

  void start() {
    if (isRunning) return;
    isRunning = true;

    _loopTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      _tick();
    });
  }

  void stop() {
    isRunning = false;
    _loopTimer?.cancel();
    _loopTimer = null;
  }

  void _tick() {
    final dtSeconds = 1.0 * simSpeedMultiplier;

    // 1. Advance Constellation physical simulation
    simulator.advanceSimulation(dtSeconds);

    // 2. Step probabilistic faults
    faultEngine.stepProbabilisticFaults(simulator, dtSeconds);

    // 3. Advance job runtime progress & checkpoint transfers
    runtime.advanceRuntime(simulator, dtSeconds);

    // 4. Run Lookahead Scheduler loop
    scheduler.schedule(
      simulator: simulator,
      runtime: runtime,
      activePolicies: activePolicies,
    );

    // 5. Broadcast live state snapshot to streaming clients
    final snapshot = buildConstellationState();
    _stateStreamController.add(snapshot);
  }

  ConstellationState buildConstellationState() {
    final sats = simulator.satellites.values.map((s) => s.toProtocol()).toList();
    final jobsList = runtime.jobs.values.toList();
    final links = List<LinkWindow>.from(simulator.activeLinks);
    final faults = faultEngine.history.take(15).toList();
    final decisions = decisionLog.entries.reversed.take(20).toList();

    double totalTFlops = 0.0;
    double usedTFlops = 0.0;
    double totalTemp = 0.0;
    double totalSoC = 0.0;

    for (final s in sats) {
      totalTFlops += s.totalComputeTFlops;
      usedTFlops += s.allocatedComputeTFlops;
      totalTemp += s.temperatureC;
      totalSoC += s.batterySoC;
    }

    final avgTemp = sats.isNotEmpty ? (totalTemp / sats.length) : 0.0;
    final avgSoC = sats.isNotEmpty ? (totalSoC / sats.length) : 0.0;

    // Approximate sun angle in degrees for 2D terminator visualization
    final sunAngleDeg = ((simulator.simTimeSeconds / 86400.0) * 360.0) % 360.0;

    return ConstellationState(
      timestamp: DateTime.now(),
      simTimeSeconds: simulator.simTimeSeconds,
      sunAngleDeg: sunAngleDeg,
      satellites: sats,
      activeJobs: jobsList,
      activeLinks: links,
      recentFaults: faults,
      recentDecisions: decisions,
      statsTotalComputeTFlops: totalTFlops,
      statsUsedComputeTFlops: usedTFlops,
      statsAverageTempC: avgTemp,
      statsAverageBatterySoC: avgSoC,
    );
  }
}
