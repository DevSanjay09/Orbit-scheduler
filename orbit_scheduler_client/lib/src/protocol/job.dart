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

abstract class Job implements _i1.SerializableModel {
  Job._({
    required this.jobId,
    required this.name,
    required this.priority,
    required this.totalRuntimeSeconds,
    required this.completedRuntimeSeconds,
    required this.progress,
    required this.requiredComputeTFlops,
    required this.state,
    this.currentSatelliteId,
    this.targetSatelliteId,
    required this.migrationCount,
    required this.maxAllowedMigrations,
    required this.checkpointIntervalSeconds,
    this.lastCheckpointTime,
    required this.lastCheckpointProgress,
    required this.checkpointSizeBytes,
    this.cooldownUntil,
    required this.wastedComputeSeconds,
    required this.createdAt,
    this.deadline,
    required this.missedDeadline,
  });

  factory Job({
    required String jobId,
    required String name,
    required String priority,
    required double totalRuntimeSeconds,
    required double completedRuntimeSeconds,
    required double progress,
    required double requiredComputeTFlops,
    required String state,
    String? currentSatelliteId,
    String? targetSatelliteId,
    required int migrationCount,
    required int maxAllowedMigrations,
    required double checkpointIntervalSeconds,
    DateTime? lastCheckpointTime,
    required double lastCheckpointProgress,
    required double checkpointSizeBytes,
    DateTime? cooldownUntil,
    required double wastedComputeSeconds,
    required DateTime createdAt,
    DateTime? deadline,
    required bool missedDeadline,
  }) = _JobImpl;

  factory Job.fromJson(Map<String, dynamic> jsonSerialization) {
    return Job(
      jobId: jsonSerialization['jobId'] as String,
      name: jsonSerialization['name'] as String,
      priority: jsonSerialization['priority'] as String,
      totalRuntimeSeconds: (jsonSerialization['totalRuntimeSeconds'] as num)
          .toDouble(),
      completedRuntimeSeconds:
          (jsonSerialization['completedRuntimeSeconds'] as num).toDouble(),
      progress: (jsonSerialization['progress'] as num).toDouble(),
      requiredComputeTFlops: (jsonSerialization['requiredComputeTFlops'] as num)
          .toDouble(),
      state: jsonSerialization['state'] as String,
      currentSatelliteId: jsonSerialization['currentSatelliteId'] as String?,
      targetSatelliteId: jsonSerialization['targetSatelliteId'] as String?,
      migrationCount: jsonSerialization['migrationCount'] as int,
      maxAllowedMigrations: jsonSerialization['maxAllowedMigrations'] as int,
      checkpointIntervalSeconds:
          (jsonSerialization['checkpointIntervalSeconds'] as num).toDouble(),
      lastCheckpointTime: jsonSerialization['lastCheckpointTime'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastCheckpointTime'],
            ),
      lastCheckpointProgress:
          (jsonSerialization['lastCheckpointProgress'] as num).toDouble(),
      checkpointSizeBytes: (jsonSerialization['checkpointSizeBytes'] as num)
          .toDouble(),
      cooldownUntil: jsonSerialization['cooldownUntil'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['cooldownUntil'],
            ),
      wastedComputeSeconds: (jsonSerialization['wastedComputeSeconds'] as num)
          .toDouble(),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      deadline: jsonSerialization['deadline'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deadline']),
      missedDeadline: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['missedDeadline'],
      ),
    );
  }

  String jobId;

  String name;

  String priority;

  double totalRuntimeSeconds;

  double completedRuntimeSeconds;

  double progress;

  double requiredComputeTFlops;

  String state;

  String? currentSatelliteId;

  String? targetSatelliteId;

  int migrationCount;

  int maxAllowedMigrations;

  double checkpointIntervalSeconds;

  DateTime? lastCheckpointTime;

  double lastCheckpointProgress;

  double checkpointSizeBytes;

  DateTime? cooldownUntil;

  double wastedComputeSeconds;

  DateTime createdAt;

  DateTime? deadline;

  bool missedDeadline;

  /// Returns a shallow copy of this [Job]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Job copyWith({
    String? jobId,
    String? name,
    String? priority,
    double? totalRuntimeSeconds,
    double? completedRuntimeSeconds,
    double? progress,
    double? requiredComputeTFlops,
    String? state,
    String? currentSatelliteId,
    String? targetSatelliteId,
    int? migrationCount,
    int? maxAllowedMigrations,
    double? checkpointIntervalSeconds,
    DateTime? lastCheckpointTime,
    double? lastCheckpointProgress,
    double? checkpointSizeBytes,
    DateTime? cooldownUntil,
    double? wastedComputeSeconds,
    DateTime? createdAt,
    DateTime? deadline,
    bool? missedDeadline,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Job',
      'jobId': jobId,
      'name': name,
      'priority': priority,
      'totalRuntimeSeconds': totalRuntimeSeconds,
      'completedRuntimeSeconds': completedRuntimeSeconds,
      'progress': progress,
      'requiredComputeTFlops': requiredComputeTFlops,
      'state': state,
      if (currentSatelliteId != null) 'currentSatelliteId': currentSatelliteId,
      if (targetSatelliteId != null) 'targetSatelliteId': targetSatelliteId,
      'migrationCount': migrationCount,
      'maxAllowedMigrations': maxAllowedMigrations,
      'checkpointIntervalSeconds': checkpointIntervalSeconds,
      if (lastCheckpointTime != null)
        'lastCheckpointTime': lastCheckpointTime?.toJson(),
      'lastCheckpointProgress': lastCheckpointProgress,
      'checkpointSizeBytes': checkpointSizeBytes,
      if (cooldownUntil != null) 'cooldownUntil': cooldownUntil?.toJson(),
      'wastedComputeSeconds': wastedComputeSeconds,
      'createdAt': createdAt.toJson(),
      if (deadline != null) 'deadline': deadline?.toJson(),
      'missedDeadline': missedDeadline,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _JobImpl extends Job {
  _JobImpl({
    required String jobId,
    required String name,
    required String priority,
    required double totalRuntimeSeconds,
    required double completedRuntimeSeconds,
    required double progress,
    required double requiredComputeTFlops,
    required String state,
    String? currentSatelliteId,
    String? targetSatelliteId,
    required int migrationCount,
    required int maxAllowedMigrations,
    required double checkpointIntervalSeconds,
    DateTime? lastCheckpointTime,
    required double lastCheckpointProgress,
    required double checkpointSizeBytes,
    DateTime? cooldownUntil,
    required double wastedComputeSeconds,
    required DateTime createdAt,
    DateTime? deadline,
    required bool missedDeadline,
  }) : super._(
         jobId: jobId,
         name: name,
         priority: priority,
         totalRuntimeSeconds: totalRuntimeSeconds,
         completedRuntimeSeconds: completedRuntimeSeconds,
         progress: progress,
         requiredComputeTFlops: requiredComputeTFlops,
         state: state,
         currentSatelliteId: currentSatelliteId,
         targetSatelliteId: targetSatelliteId,
         migrationCount: migrationCount,
         maxAllowedMigrations: maxAllowedMigrations,
         checkpointIntervalSeconds: checkpointIntervalSeconds,
         lastCheckpointTime: lastCheckpointTime,
         lastCheckpointProgress: lastCheckpointProgress,
         checkpointSizeBytes: checkpointSizeBytes,
         cooldownUntil: cooldownUntil,
         wastedComputeSeconds: wastedComputeSeconds,
         createdAt: createdAt,
         deadline: deadline,
         missedDeadline: missedDeadline,
       );

  /// Returns a shallow copy of this [Job]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Job copyWith({
    String? jobId,
    String? name,
    String? priority,
    double? totalRuntimeSeconds,
    double? completedRuntimeSeconds,
    double? progress,
    double? requiredComputeTFlops,
    String? state,
    Object? currentSatelliteId = _Undefined,
    Object? targetSatelliteId = _Undefined,
    int? migrationCount,
    int? maxAllowedMigrations,
    double? checkpointIntervalSeconds,
    Object? lastCheckpointTime = _Undefined,
    double? lastCheckpointProgress,
    double? checkpointSizeBytes,
    Object? cooldownUntil = _Undefined,
    double? wastedComputeSeconds,
    DateTime? createdAt,
    Object? deadline = _Undefined,
    bool? missedDeadline,
  }) {
    return Job(
      jobId: jobId ?? this.jobId,
      name: name ?? this.name,
      priority: priority ?? this.priority,
      totalRuntimeSeconds: totalRuntimeSeconds ?? this.totalRuntimeSeconds,
      completedRuntimeSeconds:
          completedRuntimeSeconds ?? this.completedRuntimeSeconds,
      progress: progress ?? this.progress,
      requiredComputeTFlops:
          requiredComputeTFlops ?? this.requiredComputeTFlops,
      state: state ?? this.state,
      currentSatelliteId: currentSatelliteId is String?
          ? currentSatelliteId
          : this.currentSatelliteId,
      targetSatelliteId: targetSatelliteId is String?
          ? targetSatelliteId
          : this.targetSatelliteId,
      migrationCount: migrationCount ?? this.migrationCount,
      maxAllowedMigrations: maxAllowedMigrations ?? this.maxAllowedMigrations,
      checkpointIntervalSeconds:
          checkpointIntervalSeconds ?? this.checkpointIntervalSeconds,
      lastCheckpointTime: lastCheckpointTime is DateTime?
          ? lastCheckpointTime
          : this.lastCheckpointTime,
      lastCheckpointProgress:
          lastCheckpointProgress ?? this.lastCheckpointProgress,
      checkpointSizeBytes: checkpointSizeBytes ?? this.checkpointSizeBytes,
      cooldownUntil: cooldownUntil is DateTime?
          ? cooldownUntil
          : this.cooldownUntil,
      wastedComputeSeconds: wastedComputeSeconds ?? this.wastedComputeSeconds,
      createdAt: createdAt ?? this.createdAt,
      deadline: deadline is DateTime? ? deadline : this.deadline,
      missedDeadline: missedDeadline ?? this.missedDeadline,
    );
  }
}
