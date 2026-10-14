import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../engine/orbit_engine.dart';

class DecisionLogEndpoint extends Endpoint {
  /// Searches and filters the append-only cryptographic decision log.
  Future<List<DecisionLogEntry>> search(
    Session session, {
    String? query,
    String? actionType,
    String? satelliteId,
    String? jobId,
  }) async {
    return OrbitEngine.instance.decisionLog.search(
      query: query,
      actionType: actionType,
      satelliteId: satelliteId,
      jobId: jobId,
    );
  }

  /// Cryptographically audits and verifies the SHA-256 hash chain from genesis to tail.
  Future<String> verifyHashChain(Session session) async {
    final audit = OrbitEngine.instance.decisionLog.verifyChain();
    return jsonEncode({
      'isValid': audit.isValid,
      'totalEntriesVerified': audit.totalEntriesVerified,
      'brokenEntryId': audit.brokenEntryId,
      'errorDetails': audit.errorDetails,
      'auditedAt': audit.auditedAt.toIso8601String(),
    });
  }

  /// Real-time stream of newly appended decision entries.
  Stream<DecisionLogEntry> streamDecisions(Session session) async* {
    yield* OrbitEngine.instance.decisionStream;
  }
}
