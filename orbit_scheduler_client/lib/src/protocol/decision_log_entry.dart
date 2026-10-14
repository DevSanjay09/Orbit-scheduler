/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class DecisionLogEntry implements _i1.SerializableModel {
  DecisionLogEntry._({
    required this.entryId,
    required this.timestamp,
    required this.actionType,
    this.jobId,
    this.sourceSatelliteId,
    this.targetSatelliteId,
    required this.reasonCode,
    required this.explanation,
    required this.previousHash,
    required this.currentHash,
  });

  factory DecisionLogEntry({
    required String entryId,
    required DateTime timestamp,
    required String actionType,
    String? jobId,
    String? sourceSatelliteId,
    String? targetSatelliteId,
    required String reasonCode,
    required String explanation,
    required String previousHash,
    required String currentHash,
  }) = _DecisionLogEntryImpl;

  factory DecisionLogEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return DecisionLogEntry(
      entryId: jsonSerialization['entryId'] as String,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      actionType: jsonSerialization['actionType'] as String,
      jobId: jsonSerialization['jobId'] as String?,
      sourceSatelliteId: jsonSerialization['sourceSatelliteId'] as String?,
      targetSatelliteId: jsonSerialization['targetSatelliteId'] as String?,
      reasonCode: jsonSerialization['reasonCode'] as String,
      explanation: jsonSerialization['explanation'] as String,
      previousHash: jsonSerialization['previousHash'] as String,
      currentHash: jsonSerialization['currentHash'] as String,
    );
  }

  String entryId;

  DateTime timestamp;

  String actionType;

  String? jobId;

  String? sourceSatelliteId;

  String? targetSatelliteId;

  String reasonCode;

  String explanation;

  String previousHash;

  String currentHash;

  /// Returns a shallow copy of this [DecisionLogEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DecisionLogEntry copyWith({
    String? entryId,
    DateTime? timestamp,
    String? actionType,
    String? jobId,
    String? sourceSatelliteId,
    String? targetSatelliteId,
    String? reasonCode,
    String? explanation,
    String? previousHash,
    String? currentHash,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DecisionLogEntry',
      'entryId': entryId,
      'timestamp': timestamp.toJson(),
      'actionType': actionType,
      if (jobId != null) 'jobId': jobId,
      if (sourceSatelliteId != null) 'sourceSatelliteId': sourceSatelliteId,
      if (targetSatelliteId != null) 'targetSatelliteId': targetSatelliteId,
      'reasonCode': reasonCode,
      'explanation': explanation,
      'previousHash': previousHash,
      'currentHash': currentHash,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DecisionLogEntryImpl extends DecisionLogEntry {
  _DecisionLogEntryImpl({
    required String entryId,
    required DateTime timestamp,
    required String actionType,
    String? jobId,
    String? sourceSatelliteId,
    String? targetSatelliteId,
    required String reasonCode,
    required String explanation,
    required String previousHash,
    required String currentHash,
  }) : super._(
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

  /// Returns a shallow copy of this [DecisionLogEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DecisionLogEntry copyWith({
    String? entryId,
    DateTime? timestamp,
    String? actionType,
    Object? jobId = _Undefined,
    Object? sourceSatelliteId = _Undefined,
    Object? targetSatelliteId = _Undefined,
    String? reasonCode,
    String? explanation,
    String? previousHash,
    String? currentHash,
  }) {
    return DecisionLogEntry(
      entryId: entryId ?? this.entryId,
      timestamp: timestamp ?? this.timestamp,
      actionType: actionType ?? this.actionType,
      jobId: jobId is String? ? jobId : this.jobId,
      sourceSatelliteId: sourceSatelliteId is String?
          ? sourceSatelliteId
          : this.sourceSatelliteId,
      targetSatelliteId: targetSatelliteId is String?
          ? targetSatelliteId
          : this.targetSatelliteId,
      reasonCode: reasonCode ?? this.reasonCode,
      explanation: explanation ?? this.explanation,
      previousHash: previousHash ?? this.previousHash,
      currentHash: currentHash ?? this.currentHash,
    );
  }
}
