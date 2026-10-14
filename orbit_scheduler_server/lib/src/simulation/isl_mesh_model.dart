import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart';
import 'orbital_mechanics.dart';

/// Represents a Ground Station location.
class GroundStation {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  const GroundStation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  /// Converts latitude / longitude to ECEF coordinates.
  Vector3 toEcef() {
    final latRad = latitude * math.pi / 180.0;
    final lonRad = longitude * math.pi / 180.0;
    const r = OrbitalMechanics.earthRadiusKm;

    final x = r * math.cos(latRad) * math.cos(lonRad);
    final y = r * math.cos(latRad) * math.sin(lonRad);
    final z = r * math.sin(latRad);

    return Vector3(x, y, z);
  }
}

/// Computes Inter-Satellite Laser Links (ISL) line of sight and Ground Station passes.
class IslMeshModel {
  // Maximum optical cross-link range for LEO satellites
  static const double maxIslRangeKm = 4800.0;
  // Earth radius plus atmospheric buffer (100km) to avoid optical refraction/extinction
  static const double earthOccultationRadiusKm = OrbitalMechanics.earthRadiusKm + 100.0;
  // Nominal laser link bandwidth
  static const double nominalIslBandwidthMbps = 10000.0; // 10 Gbps

  // Major global ground stations
  static const List<GroundStation> standardGroundStations = [
    GroundStation(id: 'GS-SVALBARD', name: 'Svalbard Arctic Station', latitude: 78.22, longitude: 15.65),
    GroundStation(id: 'GS-TEXAS', name: 'Boca Chica Ground Gate', latitude: 25.99, longitude: -97.15),
    GroundStation(id: 'GS-MADRID', name: 'Madrid Deep Space Facility', latitude: 40.42, longitude: -3.70),
    GroundStation(id: 'GS-TOKYO', name: 'Tokyo Pacific Uplink', latitude: 35.68, longitude: 139.76),
    GroundStation(id: 'GS-SYDNEY', name: 'Sydney Oceanic Gateway', latitude: -33.86, longitude: 151.20),
    GroundStation(id: 'GS-HAWAII', name: 'Hawaii Mid-Pacific Node', latitude: 21.30, longitude: -157.85),
  ];

  /// Checks line of sight between two satellite 3D ECI positions.
  /// Returns null if link is closed/occluded, or returns distance in km if open.
  double? checkLineOfSight(Vector3 posA, Vector3 posB) {
    final diff = posB - posA;
    final distance = diff.length;

    // Range threshold
    if (distance > maxIslRangeKm) {
      return null;
    }

    // Line segment ray from posA to posB
    // Closest point on the line segment to Earth's origin (0, 0, 0):
    // r(t) = posA + t * (posB - posA), for t in [0, 1]
    final diffLenSq = diff.length2;
    if (diffLenSq < 1e-6) {
      return null; // Same satellite
    }

    // Projection parameter t
    final t = (-posA.dot(diff)) / diffLenSq;

    double closestDistToOrigin;
    if (t <= 0.0) {
      closestDistToOrigin = posA.length;
    } else if (t >= 1.0) {
      closestDistToOrigin = posB.length;
    } else {
      final closestPoint = posA + diff.scaled(t);
      closestDistToOrigin = closestPoint.length;
    }

    // Occultation check: does the line of sight pass through Earth's atmosphere?
    if (closestDistToOrigin < earthOccultationRadiusKm) {
      return null; // Earth blocks the laser link
    }

    return distance;
  }

  /// Checks if satellite is in direct line of sight of a ground station (elevation > 10 degrees).
  bool isGroundStationVisible(Map<String, double> satLatLon, GroundStation station) {
    final satLat = satLatLon['lat']!;
    final satLon = satLatLon['lon']!;

    // Spherical great circle angular distance
    final phi1 = satLat * math.pi / 180.0;
    final phi2 = station.latitude * math.pi / 180.0;
    final deltaLambda = (satLon - station.longitude) * math.pi / 180.0;

    final cosDist = math.sin(phi1) * math.sin(phi2) + math.cos(phi1) * math.cos(phi2) * math.cos(deltaLambda);
    final angularDistRad = math.acos(cosDist.clamp(-1.0, 1.0));
    final surfaceDistKm = angularDistRad * OrbitalMechanics.earthRadiusKm;

    // Direct horizon visibility at 550km altitude: ~2500 km radius
    return surfaceDistKm < 2200.0;
  }
}
