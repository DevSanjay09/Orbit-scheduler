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
import 'link_window.dart' as _i2;
import 'package:orbit_scheduler_client/src/protocol/protocol.dart' as _i3;

abstract class TelemetryForecast implements _i1.SerializableModel {
  TelemetryForecast._({
    required this.satelliteId,
    required this.timestamps,
    required this.batterySoCList,
    required this.temperatureList,
    required this.inSunlightList,
    required this.predictedSafeWindowSeconds,
    required this.linkWindows,
  });

  factory TelemetryForecast({
    required String satelliteId,
    required List<DateTime> timestamps,
    required List<double> batterySoCList,
    required List<double> temperatureList,
    required List<bool> inSunlightList,
    required double predictedSafeWindowSeconds,
    required List<_i2.LinkWindow> linkWindows,
  }) = _TelemetryForecastImpl;

  factory TelemetryForecast.fromJson(Map<String, dynamic> jsonSerialization) {
    return TelemetryForecast(
      satelliteId: jsonSerialization['satelliteId'] as String,
      timestamps: _i3.Protocol().deserialize<List<DateTime>>(
        jsonSerialization['timestamps'],
      ),
      batterySoCList: _i3.Protocol().deserialize<List<double>>(
        jsonSerialization['batterySoCList'],
      ),
      temperatureList: _i3.Protocol().deserialize<List<double>>(
        jsonSerialization['temperatureList'],
      ),
      inSunlightList: _i3.Protocol().deserialize<List<bool>>(
        jsonSerialization['inSunlightList'],
      ),
      predictedSafeWindowSeconds:
          (jsonSerialization['predictedSafeWindowSeconds'] as num).toDouble(),
      linkWindows: _i3.Protocol().deserialize<List<_i2.LinkWindow>>(
        jsonSerialization['linkWindows'],
      ),
    );
  }

  String satelliteId;

  List<DateTime> timestamps;

  List<double> batterySoCList;

  List<double> temperatureList;

  List<bool> inSunlightList;

  double predictedSafeWindowSeconds;

  List<_i2.LinkWindow> linkWindows;

  /// Returns a shallow copy of this [TelemetryForecast]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TelemetryForecast copyWith({
    String? satelliteId,
    List<DateTime>? timestamps,
    List<double>? batterySoCList,
    List<double>? temperatureList,
    List<bool>? inSunlightList,
    double? predictedSafeWindowSeconds,
    List<_i2.LinkWindow>? linkWindows,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TelemetryForecast',
      'satelliteId': satelliteId,
      'timestamps': timestamps.toJson(valueToJson: (v) => v.toJson()),
      'batterySoCList': batterySoCList.toJson(),
      'temperatureList': temperatureList.toJson(),
      'inSunlightList': inSunlightList.toJson(),
      'predictedSafeWindowSeconds': predictedSafeWindowSeconds,
      'linkWindows': linkWindows.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _TelemetryForecastImpl extends TelemetryForecast {
  _TelemetryForecastImpl({
    required String satelliteId,
    required List<DateTime> timestamps,
    required List<double> batterySoCList,
    required List<double> temperatureList,
    required List<bool> inSunlightList,
    required double predictedSafeWindowSeconds,
    required List<_i2.LinkWindow> linkWindows,
  }) : super._(
         satelliteId: satelliteId,
         timestamps: timestamps,
         batterySoCList: batterySoCList,
         temperatureList: temperatureList,
         inSunlightList: inSunlightList,
         predictedSafeWindowSeconds: predictedSafeWindowSeconds,
         linkWindows: linkWindows,
       );

  /// Returns a shallow copy of this [TelemetryForecast]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TelemetryForecast copyWith({
    String? satelliteId,
    List<DateTime>? timestamps,
    List<double>? batterySoCList,
    List<double>? temperatureList,
    List<bool>? inSunlightList,
    double? predictedSafeWindowSeconds,
    List<_i2.LinkWindow>? linkWindows,
  }) {
    return TelemetryForecast(
      satelliteId: satelliteId ?? this.satelliteId,
      timestamps: timestamps ?? this.timestamps.map((e0) => e0).toList(),
      batterySoCList:
          batterySoCList ?? this.batterySoCList.map((e0) => e0).toList(),
      temperatureList:
          temperatureList ?? this.temperatureList.map((e0) => e0).toList(),
      inSunlightList:
          inSunlightList ?? this.inSunlightList.map((e0) => e0).toList(),
      predictedSafeWindowSeconds:
          predictedSafeWindowSeconds ?? this.predictedSafeWindowSeconds,
      linkWindows:
          linkWindows ?? this.linkWindows.map((e0) => e0.copyWith()).toList(),
    );
  }
}
