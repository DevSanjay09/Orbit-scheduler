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

abstract class BenchmarkRun
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  BenchmarkRun._({
    required this.runId,
    required this.seed,
    required this.schedulerAlgorithm,
    required this.jobCompletionRate,
    required this.deadlineMissRate,
    required this.wastedComputeHours,
    required this.energyUtilization,
    required this.migrationOverheadSec,
    required this.totalJobs,
    required this.completedJobs,
    required this.failedJobs,
    required this.totalSimTimeSec,
    required this.createdAt,
  });

  factory BenchmarkRun({
    required String runId,
    required int seed,
    required String schedulerAlgorithm,
    required double jobCompletionRate,
    required double deadlineMissRate,
    required double wastedComputeHours,
    required double energyUtilization,
    required double migrationOverheadSec,
    required int totalJobs,
    required int completedJobs,
    required int failedJobs,
    required double totalSimTimeSec,
    required DateTime createdAt,
  }) = _BenchmarkRunImpl;

  factory BenchmarkRun.fromJson(Map<String, dynamic> jsonSerialization) {
    return BenchmarkRun(
      runId: jsonSerialization['runId'] as String,
      seed: jsonSerialization['seed'] as int,
      schedulerAlgorithm: jsonSerialization['schedulerAlgorithm'] as String,
      jobCompletionRate: (jsonSerialization['jobCompletionRate'] as num)
          .toDouble(),
      deadlineMissRate: (jsonSerialization['deadlineMissRate'] as num)
          .toDouble(),
      wastedComputeHours: (jsonSerialization['wastedComputeHours'] as num)
          .toDouble(),
      energyUtilization: (jsonSerialization['energyUtilization'] as num)
          .toDouble(),
      migrationOverheadSec: (jsonSerialization['migrationOverheadSec'] as num)
          .toDouble(),
      totalJobs: jsonSerialization['totalJobs'] as int,
      completedJobs: jsonSerialization['completedJobs'] as int,
      failedJobs: jsonSerialization['failedJobs'] as int,
      totalSimTimeSec: (jsonSerialization['totalSimTimeSec'] as num).toDouble(),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  String runId;

  int seed;

  String schedulerAlgorithm;

  double jobCompletionRate;

  double deadlineMissRate;

  double wastedComputeHours;

  double energyUtilization;

  double migrationOverheadSec;

  int totalJobs;

  int completedJobs;

  int failedJobs;

  double totalSimTimeSec;

  DateTime createdAt;

  /// Returns a shallow copy of this [BenchmarkRun]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BenchmarkRun copyWith({
    String? runId,
    int? seed,
    String? schedulerAlgorithm,
    double? jobCompletionRate,
    double? deadlineMissRate,
    double? wastedComputeHours,
    double? energyUtilization,
    double? migrationOverheadSec,
    int? totalJobs,
    int? completedJobs,
    int? failedJobs,
    double? totalSimTimeSec,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BenchmarkRun',
      'runId': runId,
      'seed': seed,
      'schedulerAlgorithm': schedulerAlgorithm,
      'jobCompletionRate': jobCompletionRate,
      'deadlineMissRate': deadlineMissRate,
      'wastedComputeHours': wastedComputeHours,
      'energyUtilization': energyUtilization,
      'migrationOverheadSec': migrationOverheadSec,
      'totalJobs': totalJobs,
      'completedJobs': completedJobs,
      'failedJobs': failedJobs,
      'totalSimTimeSec': totalSimTimeSec,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BenchmarkRun',
      'runId': runId,
      'seed': seed,
      'schedulerAlgorithm': schedulerAlgorithm,
      'jobCompletionRate': jobCompletionRate,
      'deadlineMissRate': deadlineMissRate,
      'wastedComputeHours': wastedComputeHours,
      'energyUtilization': energyUtilization,
      'migrationOverheadSec': migrationOverheadSec,
      'totalJobs': totalJobs,
      'completedJobs': completedJobs,
      'failedJobs': failedJobs,
      'totalSimTimeSec': totalSimTimeSec,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _BenchmarkRunImpl extends BenchmarkRun {
  _BenchmarkRunImpl({
    required String runId,
    required int seed,
    required String schedulerAlgorithm,
    required double jobCompletionRate,
    required double deadlineMissRate,
    required double wastedComputeHours,
    required double energyUtilization,
    required double migrationOverheadSec,
    required int totalJobs,
    required int completedJobs,
    required int failedJobs,
    required double totalSimTimeSec,
    required DateTime createdAt,
  }) : super._(
         runId: runId,
         seed: seed,
         schedulerAlgorithm: schedulerAlgorithm,
         jobCompletionRate: jobCompletionRate,
         deadlineMissRate: deadlineMissRate,
         wastedComputeHours: wastedComputeHours,
         energyUtilization: energyUtilization,
         migrationOverheadSec: migrationOverheadSec,
         totalJobs: totalJobs,
         completedJobs: completedJobs,
         failedJobs: failedJobs,
         totalSimTimeSec: totalSimTimeSec,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [BenchmarkRun]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BenchmarkRun copyWith({
    String? runId,
    int? seed,
    String? schedulerAlgorithm,
    double? jobCompletionRate,
    double? deadlineMissRate,
    double? wastedComputeHours,
    double? energyUtilization,
    double? migrationOverheadSec,
    int? totalJobs,
    int? completedJobs,
    int? failedJobs,
    double? totalSimTimeSec,
    DateTime? createdAt,
  }) {
    return BenchmarkRun(
      runId: runId ?? this.runId,
      seed: seed ?? this.seed,
      schedulerAlgorithm: schedulerAlgorithm ?? this.schedulerAlgorithm,
      jobCompletionRate: jobCompletionRate ?? this.jobCompletionRate,
      deadlineMissRate: deadlineMissRate ?? this.deadlineMissRate,
      wastedComputeHours: wastedComputeHours ?? this.wastedComputeHours,
      energyUtilization: energyUtilization ?? this.energyUtilization,
      migrationOverheadSec: migrationOverheadSec ?? this.migrationOverheadSec,
      totalJobs: totalJobs ?? this.totalJobs,
      completedJobs: completedJobs ?? this.completedJobs,
      failedJobs: failedJobs ?? this.failedJobs,
      totalSimTimeSec: totalSimTimeSec ?? this.totalSimTimeSec,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
