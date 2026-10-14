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

abstract class FaultEvent implements _i1.SerializableModel {
  FaultEvent._({
    required this.eventId,
    required this.eventType,
    required this.targetSatelliteId,
    this.secondaryTargetSatelliteId,
    required this.description,
    required this.impactSeverity,
    required this.occurredAt,
    required this.resolved,
    this.recoveryActionTaken,
  });

  factory FaultEvent({
    required String eventId,
    required String eventType,
    required String targetSatelliteId,
    String? secondaryTargetSatelliteId,
    required String description,
    required String impactSeverity,
    required DateTime occurredAt,
    required bool resolved,
    String? recoveryActionTaken,
  }) = _FaultEventImpl;

  factory FaultEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return FaultEvent(
      eventId: jsonSerialization['eventId'] as String,
      eventType: jsonSerialization['eventType'] as String,
      targetSatelliteId: jsonSerialization['targetSatelliteId'] as String,
      secondaryTargetSatelliteId:
          jsonSerialization['secondaryTargetSatelliteId'] as String?,
      description: jsonSerialization['description'] as String,
      impactSeverity: jsonSerialization['impactSeverity'] as String,
      occurredAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['occurredAt'],
      ),
      resolved: _i1.BoolJsonExtension.fromJson(jsonSerialization['resolved']),
      recoveryActionTaken: jsonSerialization['recoveryActionTaken'] as String?,
    );
  }

  String eventId;

  String eventType;

  String targetSatelliteId;

  String? secondaryTargetSatelliteId;

  String description;

  String impactSeverity;

  DateTime occurredAt;

  bool resolved;

  String? recoveryActionTaken;

  /// Returns a shallow copy of this [FaultEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FaultEvent copyWith({
    String? eventId,
    String? eventType,
    String? targetSatelliteId,
    String? secondaryTargetSatelliteId,
    String? description,
    String? impactSeverity,
    DateTime? occurredAt,
    bool? resolved,
    String? recoveryActionTaken,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FaultEvent',
      'eventId': eventId,
      'eventType': eventType,
      'targetSatelliteId': targetSatelliteId,
      if (secondaryTargetSatelliteId != null)
        'secondaryTargetSatelliteId': secondaryTargetSatelliteId,
      'description': description,
      'impactSeverity': impactSeverity,
      'occurredAt': occurredAt.toJson(),
      'resolved': resolved,
      if (recoveryActionTaken != null)
        'recoveryActionTaken': recoveryActionTaken,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FaultEventImpl extends FaultEvent {
  _FaultEventImpl({
    required String eventId,
    required String eventType,
    required String targetSatelliteId,
    String? secondaryTargetSatelliteId,
    required String description,
    required String impactSeverity,
    required DateTime occurredAt,
    required bool resolved,
    String? recoveryActionTaken,
  }) : super._(
         eventId: eventId,
         eventType: eventType,
         targetSatelliteId: targetSatelliteId,
         secondaryTargetSatelliteId: secondaryTargetSatelliteId,
         description: description,
         impactSeverity: impactSeverity,
         occurredAt: occurredAt,
         resolved: resolved,
         recoveryActionTaken: recoveryActionTaken,
       );

  /// Returns a shallow copy of this [FaultEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FaultEvent copyWith({
    String? eventId,
    String? eventType,
    String? targetSatelliteId,
    Object? secondaryTargetSatelliteId = _Undefined,
    String? description,
    String? impactSeverity,
    DateTime? occurredAt,
    bool? resolved,
    Object? recoveryActionTaken = _Undefined,
  }) {
    return FaultEvent(
      eventId: eventId ?? this.eventId,
      eventType: eventType ?? this.eventType,
      targetSatelliteId: targetSatelliteId ?? this.targetSatelliteId,
      secondaryTargetSatelliteId: secondaryTargetSatelliteId is String?
          ? secondaryTargetSatelliteId
          : this.secondaryTargetSatelliteId,
      description: description ?? this.description,
      impactSeverity: impactSeverity ?? this.impactSeverity,
      occurredAt: occurredAt ?? this.occurredAt,
      resolved: resolved ?? this.resolved,
      recoveryActionTaken: recoveryActionTaken is String?
          ? recoveryActionTaken
          : this.recoveryActionTaken,
    );
  }
}
