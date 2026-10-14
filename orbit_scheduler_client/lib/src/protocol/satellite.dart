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
import 'package:orbit_scheduler_client/src/protocol/protocol.dart' as _i2;

abstract class Satellite implements _i1.SerializableModel {
  Satellite._({
    required this.satelliteId,
    required this.planeIndex,
    required this.slotIndex,
    required this.altitudeKm,
    required this.inclinationDeg,
    required this.trueAnomalyDeg,
    required this.latitude,
    required this.longitude,
    required this.velocityKmh,
    required this.inSunlight,
    required this.solarFluxFraction,
    required this.batteryCapacityWh,
    required this.batterySoC,
    required this.batteryPowerNetW,
    required this.temperatureC,
    required this.thermalHeadroom,
    required this.isThrottled,
    required this.throttleRatio,
    required this.totalComputeTFlops,
    required this.allocatedComputeTFlops,
    required this.activeJobIds,
    required this.status,
    this.lastFaultReason,
    required this.updatedAt,
  });

  factory Satellite({
    required String satelliteId,
    required int planeIndex,
    required int slotIndex,
    required double altitudeKm,
    required double inclinationDeg,
    required double trueAnomalyDeg,
    required double latitude,
    required double longitude,
    required double velocityKmh,
    required bool inSunlight,
    required double solarFluxFraction,
    required double batteryCapacityWh,
    required double batterySoC,
    required double batteryPowerNetW,
    required double temperatureC,
    required double thermalHeadroom,
    required bool isThrottled,
    required double throttleRatio,
    required double totalComputeTFlops,
    required double allocatedComputeTFlops,
    required List<String> activeJobIds,
    required String status,
    String? lastFaultReason,
    required DateTime updatedAt,
  }) = _SatelliteImpl;

  factory Satellite.fromJson(Map<String, dynamic> jsonSerialization) {
    return Satellite(
      satelliteId: jsonSerialization['satelliteId'] as String,
      planeIndex: jsonSerialization['planeIndex'] as int,
      slotIndex: jsonSerialization['slotIndex'] as int,
      altitudeKm: (jsonSerialization['altitudeKm'] as num).toDouble(),
      inclinationDeg: (jsonSerialization['inclinationDeg'] as num).toDouble(),
      trueAnomalyDeg: (jsonSerialization['trueAnomalyDeg'] as num).toDouble(),
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      velocityKmh: (jsonSerialization['velocityKmh'] as num).toDouble(),
      inSunlight: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['inSunlight'],
      ),
      solarFluxFraction: (jsonSerialization['solarFluxFraction'] as num)
          .toDouble(),
      batteryCapacityWh: (jsonSerialization['batteryCapacityWh'] as num)
          .toDouble(),
      batterySoC: (jsonSerialization['batterySoC'] as num).toDouble(),
      batteryPowerNetW: (jsonSerialization['batteryPowerNetW'] as num)
          .toDouble(),
      temperatureC: (jsonSerialization['temperatureC'] as num).toDouble(),
      thermalHeadroom: (jsonSerialization['thermalHeadroom'] as num).toDouble(),
      isThrottled: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isThrottled'],
      ),
      throttleRatio: (jsonSerialization['throttleRatio'] as num).toDouble(),
      totalComputeTFlops: (jsonSerialization['totalComputeTFlops'] as num)
          .toDouble(),
      allocatedComputeTFlops:
          (jsonSerialization['allocatedComputeTFlops'] as num).toDouble(),
      activeJobIds: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['activeJobIds'],
      ),
      status: jsonSerialization['status'] as String,
      lastFaultReason: jsonSerialization['lastFaultReason'] as String?,
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  String satelliteId;

  int planeIndex;

  int slotIndex;

  double altitudeKm;

  double inclinationDeg;

  double trueAnomalyDeg;

  double latitude;

  double longitude;

  double velocityKmh;

  bool inSunlight;

  double solarFluxFraction;

  double batteryCapacityWh;

  double batterySoC;

  double batteryPowerNetW;

  double temperatureC;

  double thermalHeadroom;

  bool isThrottled;

  double throttleRatio;

  double totalComputeTFlops;

  double allocatedComputeTFlops;

  List<String> activeJobIds;

  String status;

  String? lastFaultReason;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Satellite]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Satellite copyWith({
    String? satelliteId,
    int? planeIndex,
    int? slotIndex,
    double? altitudeKm,
    double? inclinationDeg,
    double? trueAnomalyDeg,
    double? latitude,
    double? longitude,
    double? velocityKmh,
    bool? inSunlight,
    double? solarFluxFraction,
    double? batteryCapacityWh,
    double? batterySoC,
    double? batteryPowerNetW,
    double? temperatureC,
    double? thermalHeadroom,
    bool? isThrottled,
    double? throttleRatio,
    double? totalComputeTFlops,
    double? allocatedComputeTFlops,
    List<String>? activeJobIds,
    String? status,
    String? lastFaultReason,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Satellite',
      'satelliteId': satelliteId,
      'planeIndex': planeIndex,
      'slotIndex': slotIndex,
      'altitudeKm': altitudeKm,
      'inclinationDeg': inclinationDeg,
      'trueAnomalyDeg': trueAnomalyDeg,
      'latitude': latitude,
      'longitude': longitude,
      'velocityKmh': velocityKmh,
      'inSunlight': inSunlight,
      'solarFluxFraction': solarFluxFraction,
      'batteryCapacityWh': batteryCapacityWh,
      'batterySoC': batterySoC,
      'batteryPowerNetW': batteryPowerNetW,
      'temperatureC': temperatureC,
      'thermalHeadroom': thermalHeadroom,
      'isThrottled': isThrottled,
      'throttleRatio': throttleRatio,
      'totalComputeTFlops': totalComputeTFlops,
      'allocatedComputeTFlops': allocatedComputeTFlops,
      'activeJobIds': activeJobIds.toJson(),
      'status': status,
      if (lastFaultReason != null) 'lastFaultReason': lastFaultReason,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SatelliteImpl extends Satellite {
  _SatelliteImpl({
    required String satelliteId,
    required int planeIndex,
    required int slotIndex,
    required double altitudeKm,
    required double inclinationDeg,
    required double trueAnomalyDeg,
    required double latitude,
    required double longitude,
    required double velocityKmh,
    required bool inSunlight,
    required double solarFluxFraction,
    required double batteryCapacityWh,
    required double batterySoC,
    required double batteryPowerNetW,
    required double temperatureC,
    required double thermalHeadroom,
    required bool isThrottled,
    required double throttleRatio,
    required double totalComputeTFlops,
    required double allocatedComputeTFlops,
    required List<String> activeJobIds,
    required String status,
    String? lastFaultReason,
    required DateTime updatedAt,
  }) : super._(
         satelliteId: satelliteId,
         planeIndex: planeIndex,
         slotIndex: slotIndex,
         altitudeKm: altitudeKm,
         inclinationDeg: inclinationDeg,
         trueAnomalyDeg: trueAnomalyDeg,
         latitude: latitude,
         longitude: longitude,
         velocityKmh: velocityKmh,
         inSunlight: inSunlight,
         solarFluxFraction: solarFluxFraction,
         batteryCapacityWh: batteryCapacityWh,
         batterySoC: batterySoC,
         batteryPowerNetW: batteryPowerNetW,
         temperatureC: temperatureC,
         thermalHeadroom: thermalHeadroom,
         isThrottled: isThrottled,
         throttleRatio: throttleRatio,
         totalComputeTFlops: totalComputeTFlops,
         allocatedComputeTFlops: allocatedComputeTFlops,
         activeJobIds: activeJobIds,
         status: status,
         lastFaultReason: lastFaultReason,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Satellite]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Satellite copyWith({
    String? satelliteId,
    int? planeIndex,
    int? slotIndex,
    double? altitudeKm,
    double? inclinationDeg,
    double? trueAnomalyDeg,
    double? latitude,
    double? longitude,
    double? velocityKmh,
    bool? inSunlight,
    double? solarFluxFraction,
    double? batteryCapacityWh,
    double? batterySoC,
    double? batteryPowerNetW,
    double? temperatureC,
    double? thermalHeadroom,
    bool? isThrottled,
    double? throttleRatio,
    double? totalComputeTFlops,
    double? allocatedComputeTFlops,
    List<String>? activeJobIds,
    String? status,
    Object? lastFaultReason = _Undefined,
    DateTime? updatedAt,
  }) {
    return Satellite(
      satelliteId: satelliteId ?? this.satelliteId,
      planeIndex: planeIndex ?? this.planeIndex,
      slotIndex: slotIndex ?? this.slotIndex,
      altitudeKm: altitudeKm ?? this.altitudeKm,
      inclinationDeg: inclinationDeg ?? this.inclinationDeg,
      trueAnomalyDeg: trueAnomalyDeg ?? this.trueAnomalyDeg,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      velocityKmh: velocityKmh ?? this.velocityKmh,
      inSunlight: inSunlight ?? this.inSunlight,
      solarFluxFraction: solarFluxFraction ?? this.solarFluxFraction,
      batteryCapacityWh: batteryCapacityWh ?? this.batteryCapacityWh,
      batterySoC: batterySoC ?? this.batterySoC,
      batteryPowerNetW: batteryPowerNetW ?? this.batteryPowerNetW,
      temperatureC: temperatureC ?? this.temperatureC,
      thermalHeadroom: thermalHeadroom ?? this.thermalHeadroom,
      isThrottled: isThrottled ?? this.isThrottled,
      throttleRatio: throttleRatio ?? this.throttleRatio,
      totalComputeTFlops: totalComputeTFlops ?? this.totalComputeTFlops,
      allocatedComputeTFlops:
          allocatedComputeTFlops ?? this.allocatedComputeTFlops,
      activeJobIds: activeJobIds ?? this.activeJobIds.map((e0) => e0).toList(),
      status: status ?? this.status,
      lastFaultReason: lastFaultReason is String?
          ? lastFaultReason
          : this.lastFaultReason,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
