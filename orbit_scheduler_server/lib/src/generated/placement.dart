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

import 'package:serverpod/serverpod.dart' as _i1;

abstract class Placement
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  Placement._({
    required this.placementId,
    required this.jobId,
    required this.satelliteId,
    required this.startTime,
    this.endTime,
    required this.predictedSafeWindowSeconds,
    required this.reason,
    required this.status,
  });

  factory Placement({
    required String placementId,
    required String jobId,
    required String satelliteId,
    required DateTime startTime,
    DateTime? endTime,
    required double predictedSafeWindowSeconds,
    required String reason,
    required String status,
  }) = _PlacementImpl;

  factory Placement.fromJson(Map<String, dynamic> jsonSerialization) {
    return Placement(
      placementId: jsonSerialization['placementId'] as String,
      jobId: jsonSerialization['jobId'] as String,
      satelliteId: jsonSerialization['satelliteId'] as String,
      startTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startTime'],
      ),
      endTime: jsonSerialization['endTime'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endTime']),
      predictedSafeWindowSeconds:
          (jsonSerialization['predictedSafeWindowSeconds'] as num).toDouble(),
      reason: jsonSerialization['reason'] as String,
      status: jsonSerialization['status'] as String,
    );
  }

  String placementId;

  String jobId;

  String satelliteId;

  DateTime startTime;

  DateTime? endTime;

  double predictedSafeWindowSeconds;

  String reason;

  String status;

  /// Returns a shallow copy of this [Placement]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Placement copyWith({
    String? placementId,
    String? jobId,
    String? satelliteId,
    DateTime? startTime,
    DateTime? endTime,
    double? predictedSafeWindowSeconds,
    String? reason,
    String? status,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Placement',
      'placementId': placementId,
      'jobId': jobId,
      'satelliteId': satelliteId,
      'startTime': startTime.toJson(),
      if (endTime != null) 'endTime': endTime?.toJson(),
      'predictedSafeWindowSeconds': predictedSafeWindowSeconds,
      'reason': reason,
      'status': status,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Placement',
      'placementId': placementId,
      'jobId': jobId,
      'satelliteId': satelliteId,
      'startTime': startTime.toJson(),
      if (endTime != null) 'endTime': endTime?.toJson(),
      'predictedSafeWindowSeconds': predictedSafeWindowSeconds,
      'reason': reason,
      'status': status,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PlacementImpl extends Placement {
  _PlacementImpl({
    required String placementId,
    required String jobId,
    required String satelliteId,
    required DateTime startTime,
    DateTime? endTime,
    required double predictedSafeWindowSeconds,
    required String reason,
    required String status,
  }) : super._(
         placementId: placementId,
         jobId: jobId,
         satelliteId: satelliteId,
         startTime: startTime,
         endTime: endTime,
         predictedSafeWindowSeconds: predictedSafeWindowSeconds,
         reason: reason,
         status: status,
       );

  /// Returns a shallow copy of this [Placement]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Placement copyWith({
    String? placementId,
    String? jobId,
    String? satelliteId,
    DateTime? startTime,
    Object? endTime = _Undefined,
    double? predictedSafeWindowSeconds,
    String? reason,
    String? status,
  }) {
    return Placement(
      placementId: placementId ?? this.placementId,
      jobId: jobId ?? this.jobId,
      satelliteId: satelliteId ?? this.satelliteId,
      startTime: startTime ?? this.startTime,
      endTime: endTime is DateTime? ? endTime : this.endTime,
      predictedSafeWindowSeconds:
          predictedSafeWindowSeconds ?? this.predictedSafeWindowSeconds,
      reason: reason ?? this.reason,
      status: status ?? this.status,
    );
  }
}
