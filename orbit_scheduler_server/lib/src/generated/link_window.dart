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

abstract class LinkWindow
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  LinkWindow._({
    required this.sourceSatelliteId,
    required this.targetSatelliteId,
    required this.linkType,
    required this.isOpen,
    required this.distanceKm,
    required this.bandwidthMbps,
    required this.lossRisk,
    required this.validUntil,
  });

  factory LinkWindow({
    required String sourceSatelliteId,
    required String targetSatelliteId,
    required String linkType,
    required bool isOpen,
    required double distanceKm,
    required double bandwidthMbps,
    required double lossRisk,
    required DateTime validUntil,
  }) = _LinkWindowImpl;

  factory LinkWindow.fromJson(Map<String, dynamic> jsonSerialization) {
    return LinkWindow(
      sourceSatelliteId: jsonSerialization['sourceSatelliteId'] as String,
      targetSatelliteId: jsonSerialization['targetSatelliteId'] as String,
      linkType: jsonSerialization['linkType'] as String,
      isOpen: _i1.BoolJsonExtension.fromJson(jsonSerialization['isOpen']),
      distanceKm: (jsonSerialization['distanceKm'] as num).toDouble(),
      bandwidthMbps: (jsonSerialization['bandwidthMbps'] as num).toDouble(),
      lossRisk: (jsonSerialization['lossRisk'] as num).toDouble(),
      validUntil: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['validUntil'],
      ),
    );
  }

  String sourceSatelliteId;

  String targetSatelliteId;

  String linkType;

  bool isOpen;

  double distanceKm;

  double bandwidthMbps;

  double lossRisk;

  DateTime validUntil;

  /// Returns a shallow copy of this [LinkWindow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LinkWindow copyWith({
    String? sourceSatelliteId,
    String? targetSatelliteId,
    String? linkType,
    bool? isOpen,
    double? distanceKm,
    double? bandwidthMbps,
    double? lossRisk,
    DateTime? validUntil,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LinkWindow',
      'sourceSatelliteId': sourceSatelliteId,
      'targetSatelliteId': targetSatelliteId,
      'linkType': linkType,
      'isOpen': isOpen,
      'distanceKm': distanceKm,
      'bandwidthMbps': bandwidthMbps,
      'lossRisk': lossRisk,
      'validUntil': validUntil.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LinkWindow',
      'sourceSatelliteId': sourceSatelliteId,
      'targetSatelliteId': targetSatelliteId,
      'linkType': linkType,
      'isOpen': isOpen,
      'distanceKm': distanceKm,
      'bandwidthMbps': bandwidthMbps,
      'lossRisk': lossRisk,
      'validUntil': validUntil.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _LinkWindowImpl extends LinkWindow {
  _LinkWindowImpl({
    required String sourceSatelliteId,
    required String targetSatelliteId,
    required String linkType,
    required bool isOpen,
    required double distanceKm,
    required double bandwidthMbps,
    required double lossRisk,
    required DateTime validUntil,
  }) : super._(
         sourceSatelliteId: sourceSatelliteId,
         targetSatelliteId: targetSatelliteId,
         linkType: linkType,
         isOpen: isOpen,
         distanceKm: distanceKm,
         bandwidthMbps: bandwidthMbps,
         lossRisk: lossRisk,
         validUntil: validUntil,
       );

  /// Returns a shallow copy of this [LinkWindow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LinkWindow copyWith({
    String? sourceSatelliteId,
    String? targetSatelliteId,
    String? linkType,
    bool? isOpen,
    double? distanceKm,
    double? bandwidthMbps,
    double? lossRisk,
    DateTime? validUntil,
  }) {
    return LinkWindow(
      sourceSatelliteId: sourceSatelliteId ?? this.sourceSatelliteId,
      targetSatelliteId: targetSatelliteId ?? this.targetSatelliteId,
      linkType: linkType ?? this.linkType,
      isOpen: isOpen ?? this.isOpen,
      distanceKm: distanceKm ?? this.distanceKm,
      bandwidthMbps: bandwidthMbps ?? this.bandwidthMbps,
      lossRisk: lossRisk ?? this.lossRisk,
      validUntil: validUntil ?? this.validUntil,
    );
  }
}
