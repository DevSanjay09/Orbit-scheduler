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
import 'satellite.dart' as _i2;
import 'job.dart' as _i3;
import 'link_window.dart' as _i4;
import 'fault_event.dart' as _i5;
import 'decision_log_entry.dart' as _i6;
import 'package:orbit_scheduler_server/src/generated/protocol.dart' as _i7;

abstract class ConstellationState
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ConstellationState._({
    required this.timestamp,
    required this.simTimeSeconds,
    required this.sunAngleDeg,
    required this.satellites,
    required this.activeJobs,
    required this.activeLinks,
    required this.recentFaults,
    required this.recentDecisions,
    required this.statsTotalComputeTFlops,
    required this.statsUsedComputeTFlops,
    required this.statsAverageTempC,
    required this.statsAverageBatterySoC,
  });

  factory ConstellationState({
    required DateTime timestamp,
    required double simTimeSeconds,
    required double sunAngleDeg,
    required List<_i2.Satellite> satellites,
    required List<_i3.Job> activeJobs,
    required List<_i4.LinkWindow> activeLinks,
    required List<_i5.FaultEvent> recentFaults,
    required List<_i6.DecisionLogEntry> recentDecisions,
    required double statsTotalComputeTFlops,
    required double statsUsedComputeTFlops,
    required double statsAverageTempC,
    required double statsAverageBatterySoC,
  }) = _ConstellationStateImpl;

  factory ConstellationState.fromJson(Map<String, dynamic> jsonSerialization) {
    return ConstellationState(
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      simTimeSeconds: (jsonSerialization['simTimeSeconds'] as num).toDouble(),
      sunAngleDeg: (jsonSerialization['sunAngleDeg'] as num).toDouble(),
      satellites: _i7.Protocol().deserialize<List<_i2.Satellite>>(
        jsonSerialization['satellites'],
      ),
      activeJobs: _i7.Protocol().deserialize<List<_i3.Job>>(
        jsonSerialization['activeJobs'],
      ),
      activeLinks: _i7.Protocol().deserialize<List<_i4.LinkWindow>>(
        jsonSerialization['activeLinks'],
      ),
      recentFaults: _i7.Protocol().deserialize<List<_i5.FaultEvent>>(
        jsonSerialization['recentFaults'],
      ),
      recentDecisions: _i7.Protocol().deserialize<List<_i6.DecisionLogEntry>>(
        jsonSerialization['recentDecisions'],
      ),
      statsTotalComputeTFlops:
          (jsonSerialization['statsTotalComputeTFlops'] as num).toDouble(),
      statsUsedComputeTFlops:
          (jsonSerialization['statsUsedComputeTFlops'] as num).toDouble(),
      statsAverageTempC: (jsonSerialization['statsAverageTempC'] as num)
          .toDouble(),
      statsAverageBatterySoC:
          (jsonSerialization['statsAverageBatterySoC'] as num).toDouble(),
    );
  }

  DateTime timestamp;

  double simTimeSeconds;

  double sunAngleDeg;

  List<_i2.Satellite> satellites;

  List<_i3.Job> activeJobs;

  List<_i4.LinkWindow> activeLinks;

  List<_i5.FaultEvent> recentFaults;

  List<_i6.DecisionLogEntry> recentDecisions;

  double statsTotalComputeTFlops;

  double statsUsedComputeTFlops;

  double statsAverageTempC;

  double statsAverageBatterySoC;

  /// Returns a shallow copy of this [ConstellationState]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ConstellationState copyWith({
    DateTime? timestamp,
    double? simTimeSeconds,
    double? sunAngleDeg,
    List<_i2.Satellite>? satellites,
    List<_i3.Job>? activeJobs,
    List<_i4.LinkWindow>? activeLinks,
    List<_i5.FaultEvent>? recentFaults,
    List<_i6.DecisionLogEntry>? recentDecisions,
    double? statsTotalComputeTFlops,
    double? statsUsedComputeTFlops,
    double? statsAverageTempC,
    double? statsAverageBatterySoC,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ConstellationState',
      'timestamp': timestamp.toJson(),
      'simTimeSeconds': simTimeSeconds,
      'sunAngleDeg': sunAngleDeg,
      'satellites': satellites.toJson(valueToJson: (v) => v.toJson()),
      'activeJobs': activeJobs.toJson(valueToJson: (v) => v.toJson()),
      'activeLinks': activeLinks.toJson(valueToJson: (v) => v.toJson()),
      'recentFaults': recentFaults.toJson(valueToJson: (v) => v.toJson()),
      'recentDecisions': recentDecisions.toJson(valueToJson: (v) => v.toJson()),
      'statsTotalComputeTFlops': statsTotalComputeTFlops,
      'statsUsedComputeTFlops': statsUsedComputeTFlops,
      'statsAverageTempC': statsAverageTempC,
      'statsAverageBatterySoC': statsAverageBatterySoC,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ConstellationState',
      'timestamp': timestamp.toJson(),
      'simTimeSeconds': simTimeSeconds,
      'sunAngleDeg': sunAngleDeg,
      'satellites': satellites.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'activeJobs': activeJobs.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'activeLinks': activeLinks.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'recentFaults': recentFaults.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'recentDecisions': recentDecisions.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'statsTotalComputeTFlops': statsTotalComputeTFlops,
      'statsUsedComputeTFlops': statsUsedComputeTFlops,
      'statsAverageTempC': statsAverageTempC,
      'statsAverageBatterySoC': statsAverageBatterySoC,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ConstellationStateImpl extends ConstellationState {
  _ConstellationStateImpl({
    required DateTime timestamp,
    required double simTimeSeconds,
    required double sunAngleDeg,
    required List<_i2.Satellite> satellites,
    required List<_i3.Job> activeJobs,
    required List<_i4.LinkWindow> activeLinks,
    required List<_i5.FaultEvent> recentFaults,
    required List<_i6.DecisionLogEntry> recentDecisions,
    required double statsTotalComputeTFlops,
    required double statsUsedComputeTFlops,
    required double statsAverageTempC,
    required double statsAverageBatterySoC,
  }) : super._(
         timestamp: timestamp,
         simTimeSeconds: simTimeSeconds,
         sunAngleDeg: sunAngleDeg,
         satellites: satellites,
         activeJobs: activeJobs,
         activeLinks: activeLinks,
         recentFaults: recentFaults,
         recentDecisions: recentDecisions,
         statsTotalComputeTFlops: statsTotalComputeTFlops,
         statsUsedComputeTFlops: statsUsedComputeTFlops,
         statsAverageTempC: statsAverageTempC,
         statsAverageBatterySoC: statsAverageBatterySoC,
       );

  /// Returns a shallow copy of this [ConstellationState]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ConstellationState copyWith({
    DateTime? timestamp,
    double? simTimeSeconds,
    double? sunAngleDeg,
    List<_i2.Satellite>? satellites,
    List<_i3.Job>? activeJobs,
    List<_i4.LinkWindow>? activeLinks,
    List<_i5.FaultEvent>? recentFaults,
    List<_i6.DecisionLogEntry>? recentDecisions,
    double? statsTotalComputeTFlops,
    double? statsUsedComputeTFlops,
    double? statsAverageTempC,
    double? statsAverageBatterySoC,
  }) {
    return ConstellationState(
      timestamp: timestamp ?? this.timestamp,
      simTimeSeconds: simTimeSeconds ?? this.simTimeSeconds,
      sunAngleDeg: sunAngleDeg ?? this.sunAngleDeg,
      satellites:
          satellites ?? this.satellites.map((e0) => e0.copyWith()).toList(),
      activeJobs:
          activeJobs ?? this.activeJobs.map((e0) => e0.copyWith()).toList(),
      activeLinks:
          activeLinks ?? this.activeLinks.map((e0) => e0.copyWith()).toList(),
      recentFaults:
          recentFaults ?? this.recentFaults.map((e0) => e0.copyWith()).toList(),
      recentDecisions:
          recentDecisions ??
          this.recentDecisions.map((e0) => e0.copyWith()).toList(),
      statsTotalComputeTFlops:
          statsTotalComputeTFlops ?? this.statsTotalComputeTFlops,
      statsUsedComputeTFlops:
          statsUsedComputeTFlops ?? this.statsUsedComputeTFlops,
      statsAverageTempC: statsAverageTempC ?? this.statsAverageTempC,
      statsAverageBatterySoC:
          statsAverageBatterySoC ?? this.statsAverageBatterySoC,
    );
  }
}
