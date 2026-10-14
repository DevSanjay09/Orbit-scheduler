import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../engine/orbit_engine.dart';

class PolicyEndpoint extends Endpoint {
  /// Lists all active and configured operator policies.
  Future<List<Policy>> listPolicies(Session session) async {
    return OrbitEngine.instance.activePolicies;
  }

  /// Sends a natural language policy query to the Gemini Assistant.
  Future<AssistantInteraction> askAssistant(
    Session session, {
    required String prompt,
    String? apiKey,
  }) async {
    final engine = OrbitEngine.instance;
    if (apiKey != null && apiKey.isNotEmpty) {
      engine.assistant.setApiKey(apiKey);
    }
    return engine.assistant.parsePolicyPrompt(prompt);
  }

  /// Operator explicitly confirms and activates a parsed policy.
  Future<Policy> confirmPolicy(Session session, Policy policy) async {
    policy.operatorConfirmed = true;
    policy.isActive = true;

    final engine = OrbitEngine.instance;
    engine.activePolicies.removeWhere((p) => p.policyId == policy.policyId);
    engine.activePolicies.add(policy);

    engine.decisionLog.logDecision(
      actionType: 'POLICY_ENFORCEMENT',
      reasonCode: 'POLICY_OPERATOR_CONFIRMED',
      explanation: 'Operator confirmed and activated policy "${policy.name}" (${policy.constraintType}: ${policy.parameterValue}).',
    );

    return policy;
  }

  /// Toggles an existing policy active/inactive.
  Future<bool> togglePolicy(Session session, String policyId, bool isActive) async {
    final engine = OrbitEngine.instance;
    final policy = engine.activePolicies.firstWhere(
      (p) => p.policyId == policyId,
      orElse: () => throw ArgumentError('Policy $policyId not found'),
    );
    policy.isActive = isActive;

    engine.decisionLog.logDecision(
      actionType: 'POLICY_ENFORCEMENT',
      reasonCode: isActive ? 'POLICY_ACTIVATED' : 'POLICY_DEACTIVATED',
      explanation: 'Policy "${policy.name}" toggled ${isActive ? "ACTIVE" : "INACTIVE"} by operator.',
    );

    return true;
  }

  /// Explains a decision log entry in plain language.
  Future<String> explainDecision(Session session, String entryId) async {
    final engine = OrbitEngine.instance;
    final entry = engine.decisionLog.entries.firstWhere(
      (e) => e.entryId == entryId,
      orElse: () => throw ArgumentError('Entry $entryId not found'),
    );
    return engine.assistant.explainDecision(entry);
  }
}
