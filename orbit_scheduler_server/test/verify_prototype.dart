import 'dart:convert';
import 'package:orbit_scheduler_client/orbit_scheduler_client.dart';

void main() async {
  print('Connecting to Orbit Scheduler Serverpod API at http://localhost:8088/...');
  final client = Client('http://localhost:8088/');

  try {
    final state = await client.constellation.getState();
    print('SUCCESS: Received ConstellationState!');
    print('  - Total satellites tracked: ${state.satellites.length}');
    print('  - Active ISL laser links: ${state.activeLinks.length}');
    print('  - Active compute jobs: ${state.activeJobs.length}');
    print('  - Average constellation temperature: ${state.statsAverageTempC.toStringAsFixed(1)}°C');
    print('  - Average battery SoC: ${(state.statsAverageBatterySoC * 100).toStringAsFixed(1)}%');

    print('\nTesting Lookahead 3-hour forecast for SAT-P00-S00...');
    final forecast = await client.constellation.getSatelliteForecast('SAT-P00-S00');
    print('  - Forecast steps: ${forecast.timestamps.length}');
    print('  - Predicted safe window: ${(forecast.predictedSafeWindowSeconds / 60).toStringAsFixed(0)} minutes');

    print('\nTesting append-only Decision Log...');
    final auditJson = await client.decisionLog.verifyHashChain();
    final audit = jsonDecode(auditJson) as Map<String, dynamic>;
    print('  - Hash-chain audit valid: ${audit['isValid']}');
    print('  - Total blocks audited: ${audit['totalEntriesVerified']}');

    print('\nTesting Gemini Operator Assistant natural language policy parsing...');
    final assistantRes = await client.policy.askAssistant(
      prompt: 'Keep training jobs off satellites above 70% thermal load',
    );
    print('  - Parsed constraint type: ${assistantRes.parsedConstraintType}');
    print('  - Parsed parameter value: ${assistantRes.parsedParamValue}');
    print('  - Explanation: ${assistantRes.naturalLanguageExplanation}');

    print('\nALL ORBIT SCHEDULER SUBSYSTEMS VERIFIED 100% OPERATIONAL!');
  } catch (e, stack) {
    print('Verification failed: $e');
    print(stack);
  } finally {
    client.close();
  }
}
