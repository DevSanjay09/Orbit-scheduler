import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../generated/protocol.dart';

/// Cryptographic verification result of the append-only decision log.
class HashChainAuditResult {
  final bool isValid;
  final int totalEntriesVerified;
  final String? brokenEntryId;
  final String? errorDetails;
  final DateTime auditedAt;

  const HashChainAuditResult({
    required this.isValid,
    required this.totalEntriesVerified,
    this.brokenEntryId,
    this.errorDetails,
    required this.auditedAt,
  });
}

/// Append-only, SHA-256 hash-chained Decision Log manager.
class DecisionLogManager {
  static const String genesisHash =
      '0000000000000000000000000000000000000000000000000000000000000000';

  final List<DecisionLogEntry> _entries = [];
  int _sequenceNumber = 0;

  List<DecisionLogEntry> get entries => List.unmodifiable(_entries);

  /// Appends a new verified scheduling decision entry to the cryptographic chain.
  DecisionLogEntry logDecision({
    required String actionType, // PLACEMENT, MIGRATION, REJECTION, ROLLBACK, CHECKPOINT, POLICY_ENFORCEMENT
    String? jobId,
    String? sourceSatelliteId,
    String? targetSatelliteId,
    required String reasonCode,
    required String explanation,
  }) {
    _sequenceNumber++;
    final entryId = 'LOG-${_sequenceNumber.toString().padLeft(6, '0')}';
    final timestamp = DateTime.now();

    final previousHash = _entries.isEmpty ? genesisHash : _entries.last.currentHash;

    final currentHash = computeHash(
      previousHash: previousHash,
      entryId: entryId,
      timestamp: timestamp,
      actionType: actionType,
      jobId: jobId,
      sourceSatelliteId: sourceSatelliteId,
      targetSatelliteId: targetSatelliteId,
      reasonCode: reasonCode,
      explanation: explanation,
    );

    final entry = DecisionLogEntry(
      entryId: entryId,
      timestamp: timestamp,
      actionType: actionType,
      jobId: jobId,
      sourceSatelliteId: sourceSatelliteId,
      targetSatelliteId: targetSatelliteId,
      reasonCode: reasonCode,
      explanation: explanation,
      previousHash: previousHash,
      currentHash: currentHash,
    );

    _entries.add(entry);
    return entry;
  }

  /// Cryptographic SHA-256 hash function.
  static String computeHash({
    required String previousHash,
    required String entryId,
    required DateTime timestamp,
    required String actionType,
    String? jobId,
    String? sourceSatelliteId,
    String? targetSatelliteId,
    required String reasonCode,
    required String explanation,
  }) {
    final payload = [
      previousHash,
      entryId,
      timestamp.toIso8601String(),
      actionType,
      jobId ?? '',
      sourceSatelliteId ?? '',
      targetSatelliteId ?? '',
      reasonCode,
      explanation,
    ].join('|');

    final bytes = utf8.encode(payload);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Verifies cryptographic hash chain integrity across all entries.
  HashChainAuditResult verifyChain() {
    final auditedAt = DateTime.now();

    if (_entries.isEmpty) {
      return HashChainAuditResult(
        isValid: true,
        totalEntriesVerified: 0,
        auditedAt: auditedAt,
      );
    }

    String expectedPrevHash = genesisHash;

    for (int i = 0; i < _entries.length; i++) {
      final entry = _entries[i];

      // 1. Check parent link pointer
      if (entry.previousHash != expectedPrevHash) {
        return HashChainAuditResult(
          isValid: false,
          totalEntriesVerified: i,
          brokenEntryId: entry.entryId,
          errorDetails:
              'Hash link broken at index $i (${entry.entryId}). Expected prevHash $expectedPrevHash but found ${entry.previousHash}',
          auditedAt: auditedAt,
        );
      }

      // 2. Re-compute SHA-256 hash
      final calculatedHash = computeHash(
        previousHash: entry.previousHash,
        entryId: entry.entryId,
        timestamp: entry.timestamp,
        actionType: entry.actionType,
        jobId: entry.jobId,
        sourceSatelliteId: entry.sourceSatelliteId,
        targetSatelliteId: entry.targetSatelliteId,
        reasonCode: entry.reasonCode,
        explanation: entry.explanation,
      );

      if (entry.currentHash != calculatedHash) {
        return HashChainAuditResult(
          isValid: false,
          totalEntriesVerified: i,
          brokenEntryId: entry.entryId,
          errorDetails:
              'Data tampering detected at index $i (${entry.entryId}). Expected hash $calculatedHash but found ${entry.currentHash}',
          auditedAt: auditedAt,
        );
      }

      expectedPrevHash = entry.currentHash;
    }

    return HashChainAuditResult(
      isValid: true,
      totalEntriesVerified: _entries.length,
      auditedAt: auditedAt,
    );
  }

  /// Search and filter decision log.
  List<DecisionLogEntry> search({
    String? query,
    String? actionType,
    String? satelliteId,
    String? jobId,
  }) {
    return _entries.reversed.where((entry) {
      if (actionType != null && entry.actionType != actionType) return false;
      if (jobId != null && entry.jobId != jobId) return false;
      if (satelliteId != null &&
          entry.sourceSatelliteId != satelliteId &&
          entry.targetSatelliteId != satelliteId) {
        return false;
      }
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        final match = entry.entryId.toLowerCase().contains(q) ||
            entry.reasonCode.toLowerCase().contains(q) ||
            entry.explanation.toLowerCase().contains(q) ||
            (entry.jobId?.toLowerCase().contains(q) ?? false);
        if (!match) return false;
      }
      return true;
    }).toList();
  }
}
