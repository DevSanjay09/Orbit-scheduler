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

abstract class Checkpoint implements _i1.SerializableModel {
  Checkpoint._({
    required this.checkpointId,
    required this.jobId,
    required this.satelliteId,
    required this.progress,
    required this.sizeMb,
    required this.state,
    required this.transferBandwidthMbps,
    required this.transferProgress,
    this.sourceSatelliteId,
    this.destinationSatelliteId,
    required this.timestamp,
  });

  factory Checkpoint({
    required String checkpointId,
    required String jobId,
    required String satelliteId,
    required double progress,
    required double sizeMb,
    required String state,
    required double transferBandwidthMbps,
    required double transferProgress,
    String? sourceSatelliteId,
    String? destinationSatelliteId,
    required DateTime timestamp,
  }) = _CheckpointImpl;

  factory Checkpoint.fromJson(Map<String, dynamic> jsonSerialization) {
    return Checkpoint(
      checkpointId: jsonSerialization['checkpointId'] as String,
      jobId: jsonSerialization['jobId'] as String,
      satelliteId: jsonSerialization['satelliteId'] as String,
      progress: (jsonSerialization['progress'] as num).toDouble(),
      sizeMb: (jsonSerialization['sizeMb'] as num).toDouble(),
      state: jsonSerialization['state'] as String,
      transferBandwidthMbps: (jsonSerialization['transferBandwidthMbps'] as num)
          .toDouble(),
      transferProgress: (jsonSerialization['transferProgress'] as num)
          .toDouble(),
      sourceSatelliteId: jsonSerialization['sourceSatelliteId'] as String?,
      destinationSatelliteId:
          jsonSerialization['destinationSatelliteId'] as String?,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
    );
  }

  String checkpointId;

  String jobId;

  String satelliteId;

  double progress;

  double sizeMb;

  String state;

  double transferBandwidthMbps;

  double transferProgress;

  String? sourceSatelliteId;

  String? destinationSatelliteId;

  DateTime timestamp;

  /// Returns a shallow copy of this [Checkpoint]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Checkpoint copyWith({
    String? checkpointId,
    String? jobId,
    String? satelliteId,
    double? progress,
    double? sizeMb,
    String? state,
    double? transferBandwidthMbps,
    double? transferProgress,
    String? sourceSatelliteId,
    String? destinationSatelliteId,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Checkpoint',
      'checkpointId': checkpointId,
      'jobId': jobId,
      'satelliteId': satelliteId,
      'progress': progress,
      'sizeMb': sizeMb,
      'state': state,
      'transferBandwidthMbps': transferBandwidthMbps,
      'transferProgress': transferProgress,
      if (sourceSatelliteId != null) 'sourceSatelliteId': sourceSatelliteId,
      if (destinationSatelliteId != null)
        'destinationSatelliteId': destinationSatelliteId,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CheckpointImpl extends Checkpoint {
  _CheckpointImpl({
    required String checkpointId,
    required String jobId,
    required String satelliteId,
    required double progress,
    required double sizeMb,
    required String state,
    required double transferBandwidthMbps,
    required double transferProgress,
    String? sourceSatelliteId,
    String? destinationSatelliteId,
    required DateTime timestamp,
  }) : super._(
         checkpointId: checkpointId,
         jobId: jobId,
         satelliteId: satelliteId,
         progress: progress,
         sizeMb: sizeMb,
         state: state,
         transferBandwidthMbps: transferBandwidthMbps,
         transferProgress: transferProgress,
         sourceSatelliteId: sourceSatelliteId,
         destinationSatelliteId: destinationSatelliteId,
         timestamp: timestamp,
       );

  /// Returns a shallow copy of this [Checkpoint]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Checkpoint copyWith({
    String? checkpointId,
    String? jobId,
    String? satelliteId,
    double? progress,
    double? sizeMb,
    String? state,
    double? transferBandwidthMbps,
    double? transferProgress,
    Object? sourceSatelliteId = _Undefined,
    Object? destinationSatelliteId = _Undefined,
    DateTime? timestamp,
  }) {
    return Checkpoint(
      checkpointId: checkpointId ?? this.checkpointId,
      jobId: jobId ?? this.jobId,
      satelliteId: satelliteId ?? this.satelliteId,
      progress: progress ?? this.progress,
      sizeMb: sizeMb ?? this.sizeMb,
      state: state ?? this.state,
      transferBandwidthMbps:
          transferBandwidthMbps ?? this.transferBandwidthMbps,
      transferProgress: transferProgress ?? this.transferProgress,
      sourceSatelliteId: sourceSatelliteId is String?
          ? sourceSatelliteId
          : this.sourceSatelliteId,
      destinationSatelliteId: destinationSatelliteId is String?
          ? destinationSatelliteId
          : this.destinationSatelliteId,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
