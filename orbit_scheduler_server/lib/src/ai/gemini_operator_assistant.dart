import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../generated/protocol.dart';

/// Gemini AI Operator Assistant: parses natural language policies into constraints
/// and generates plain-language explanations.
class GeminiOperatorAssistant {
  static String get defaultKey =>
      Platform.environment['GEMINI_API_KEY'] ??
      const String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');

  String? apiKey;

  GeminiOperatorAssistant({String? apiKey}) : apiKey = apiKey ?? defaultKey;

  /// Updates the Gemini API Key.
  void setApiKey(String key) {
    apiKey = key.trim().isEmpty ? defaultKey : key.trim();
  }

  /// Parses typed policy prompt into a structured Policy object.
  Future<AssistantInteraction> parsePolicyPrompt(String prompt) async {
    final activeKey = apiKey ?? defaultKey;

    // If Gemini API key is configured, attempt real Gemini call
    if (activeKey.isNotEmpty) {
      try {
        final geminiResult = await _callGeminiApi(prompt, activeKey);
        if (geminiResult != null) {
          return geminiResult;
        }
      } catch (e) {
        // Fallback to internal NLP parser if API call fails
      }
    }

    // Default smart semantic NLP parser
    return _parseWithBuiltinEngine(prompt);
  }

  AssistantInteraction _parseWithBuiltinEngine(String prompt) {
    final lower = prompt.toLowerCase();

    String constraintType = 'THERMAL_MAX';
    double paramValue = 68.0;
    String policyName = 'Custom Operator Policy';
    String explanation = '';

    final numberRegex = RegExp(r'(\d+(?:\.\d+)?)');
    final match = numberRegex.firstMatch(lower);
    final extractedNumber = match != null ? double.tryParse(match.group(1)!) : null;

    if (lower.contains('thermal') || lower.contains('heat') || lower.contains('temp') || lower.contains('cool')) {
      constraintType = 'THERMAL_MAX';
      paramValue = extractedNumber ?? 68.0;
      if (paramValue > 100) paramValue = 68.0;
      policyName = 'Thermal Ceiling (<= ${paramValue.toStringAsFixed(1)}°C)';
      explanation = 'Restricts job placement and triggers proactive migration for satellites exceeding ${paramValue.toStringAsFixed(1)}°C to prevent thermal throttling in orbit.';
    } else if (lower.contains('battery') || lower.contains('power') || lower.contains('charge') || lower.contains('soc')) {
      constraintType = 'BATTERY_MIN';
      var val = extractedNumber ?? 35.0;
      if (val > 1.0) val = val / 100.0; // convert 35% -> 0.35
      paramValue = val.clamp(0.1, 0.9);
      policyName = 'Battery Energy Floor (>= ${(paramValue * 100).toStringAsFixed(0)}%)';
      explanation = 'Guarantees that compute jobs will only execute on satellites holding at least ${(paramValue * 100).toStringAsFixed(0)}% battery state of charge during eclipse transits.';
    } else if (lower.contains('migration') || lower.contains('move') || lower.contains('hop') || lower.contains('cap')) {
      constraintType = 'MIGRATION_CAP';
      paramValue = extractedNumber ?? 3.0;
      policyName = 'Migration Budget Cap (${paramValue.toInt()} hops)';
      explanation = 'Limits workload movements across the constellation to ${paramValue.toInt()} hops to prevent ping-pong oscillation and minimize ISL network bandwidth consumption.';
    } else if (lower.contains('priority') || lower.contains('critical') || lower.contains('reserve') || lower.contains('preempt')) {
      constraintType = 'PRIORITY_RESERVE';
      paramValue = 1.0;
      policyName = 'Priority Compute Reservation & Preemption';
      explanation = 'Reserves compute capacity on sun-drenched orbital planes exclusively for CRITICAL and HIGH priority models and activates preemption of batch jobs.';
    } else if (lower.contains('ground') || lower.contains('pass') || lower.contains('station') || lower.contains('ingest') || lower.contains('downlink')) {
      constraintType = 'GROUND_PASS_MANDATORY';
      paramValue = 1.0;
      policyName = 'Ground Station Pass Ingest/Egress Gate';
      explanation = 'Mandates that compute workloads must acquire verified Ground Station contact for input weight ingestion before launch, and queue for contact passes upon completion for results egress.';
    } else {
      // Default to thermal headroom
      constraintType = 'THERMAL_MAX';
      paramValue = 68.0;
      policyName = 'General Thermal Safety Bound';
      explanation = 'Parsed general constraint: enqueues safe thermal envelope checks across all Walker constellation nodes.';
    }

    final policyId = 'POL-${DateTime.now().millisecondsSinceEpoch % 100000}';
    final policy = Policy(
      policyId: policyId,
      name: policyName,
      naturalLanguagePrompt: prompt,
      constraintType: constraintType,
      parameterValue: paramValue,
      rawJsonRules: jsonEncode({
        'type': constraintType,
        'value': paramValue,
        'prompt': prompt,
      }),
      isActive: false, // Inactive until operator confirms!
      operatorConfirmed: false,
      createdAt: DateTime.now(),
    );

    return AssistantInteraction(
      userPrompt: prompt,
      parsedConstraintType: constraintType,
      parsedParamValue: paramValue,
      naturalLanguageExplanation: explanation,
      generatedPolicy: policy,
      requiresConfirmation: true, // "Policy changes need operator confirmation."
    );
  }

  Future<AssistantInteraction?> _callGeminiApi(String prompt, String key) async {
    final models = ['gemini-1.5-flash', 'gemini-2.0-flash', 'gemini-1.5-pro'];

    final systemInstruction = '''
You are the AI Operator Assistant for Orbit Scheduler, an autonomous orbital data center operating in LEO.
Turn the user policy into a JSON object with keys:
- constraintType: one of ["THERMAL_MAX", "BATTERY_MIN", "MIGRATION_CAP", "PRIORITY_RESERVE", "GROUND_PASS_MANDATORY"]
- parameterValue: double value (e.g. 70 for 70°C, 0.4 for 40% battery, 3 for 3 migrations, 1.0 for binary rules)
- policyName: concise human-readable policy title
- explanation: plain-language explanation of how the scheduler will enforce this rule in orbit.
Respond ONLY with raw JSON.
''';

    for (final model in models) {
      try {
        final url = Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$key');

        final body = jsonEncode({
          'contents': [
            {
              'role': 'user',
              'parts': [
                {'text': '$systemInstruction\nUser Policy: "$prompt"'}
              ]
            }
          ]
        });

        final res = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: body,
        );

        if (res.statusCode == 200) {
          final jsonRes = jsonDecode(res.body);
          final rawText = jsonRes['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';
          final cleanJson = rawText.replaceAll('```json', '').replaceAll('```', '').trim();
          final parsed = jsonDecode(cleanJson);

          final cType = parsed['constraintType'] ?? 'THERMAL_MAX';
          final pVal = (parsed['parameterValue'] as num?)?.toDouble() ?? 68.0;
          final pName = parsed['policyName'] ?? 'Operator Custom Policy';
          final expl = parsed['explanation'] ?? 'Parsed via Gemini AI assistant.';

          final policy = Policy(
            policyId: 'POL-${DateTime.now().millisecondsSinceEpoch % 100000}',
            name: pName,
            naturalLanguagePrompt: prompt,
            constraintType: cType,
            parameterValue: pVal,
            rawJsonRules: jsonEncode(parsed),
            isActive: false,
            operatorConfirmed: false,
            createdAt: DateTime.now(),
          );

          return AssistantInteraction(
            userPrompt: prompt,
            parsedConstraintType: cType,
            parsedParamValue: pVal,
            naturalLanguageExplanation: expl,
            generatedPolicy: policy,
            requiresConfirmation: true,
          );
        }
      } catch (_) {
        // Try next model or fallback
      }
    }

    return null;
  }

  /// Explains a scheduling decision in natural plain language.
  String explainDecision(DecisionLogEntry entry) {
    switch (entry.reasonCode) {
      case 'SAFE_LOOKAHEAD_OPTIMAL':
        return 'Scheduler verified a continuous safe orbital window for ${entry.jobId} on ${entry.targetSatelliteId}. Solar generation and radiator capacity comfortably exceed requirements.';
      case 'ECLIPSE_BATTERY_EXHAUSTION_PREDICTED':
        return 'Proactive migration: ${entry.sourceSatelliteId} is entering Earth’s shadow cone. Remaining battery is insufficient to sustain compute without brownout, so ${entry.jobId} was moved ahead of the outage.';
      case 'THERMAL_THROTTLE_EVASION':
        return 'Proactive thermal migration: ${entry.sourceSatelliteId} core temperature is climbing toward the throttle limit. Moved ${entry.jobId} to cooler node ${entry.targetSatelliteId} to protect throughput.';
      case 'RADIATION_UPSET_ROLLBACK':
        return 'Single Event Upset detected on compute hardware. Scheduler rolled back ${entry.jobId} to its last verified checkpoint and re-queued it for safe placement.';
      case 'PRIORITY_PREEMPTION_EVICTION':
        return 'Preemption rule enforced: High-priority workload arrived. Evicted lower-priority workload cleanly after recording an immutable checkpoint to preserve completed work.';
      case 'UNPLACEABLE_NO_SAFE_WINDOW_WAITING':
        return 'Workload placed in safe holding queue: No satellite currently offers a long enough shadow-free and cool-temperature window. Waiting for constellation orbit alignment.';
      case 'GROUND_INGEST_COMPLETE':
        return 'Ground station pass established: Input model weights and dataset successfully ingested over feeder link. Compute unlocked.';
      case 'GROUND_DOWNLINK_COMPLETE':
        return 'Ground station egress pass established: Trained weights and output inferences downlinked to ground terminal. Workload complete.';
      case 'COOLDOWN_ACTIVE_SUPPRESSED':
        return 'Anti-ping-pong protection: Migration suppressed because the workload was moved recently. Cooldown prevents wasteful network thrashing.';
      case 'MIGRATION_BUDGET_EXCEEDED':
        return 'Movement limit reached: Workload reached its allotted migration budget, forcing it to maintain its current compute node.';
      default:
        return entry.explanation;
    }
  }
}
