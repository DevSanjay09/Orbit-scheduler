import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart';

/// Keplerian circular orbital mechanics for a LEO constellation.
class OrbitalMechanics {
  // Earth parameters
  static const double earthRadiusKm = 6371.0;
  static const double earthMu = 398600.4418; // km^3 / s^2 (Standard gravitational parameter)
  static const double earthRotationRateRadS = 7.2921159e-5; // rad / s

  // Nominal constellation parameters (e.g. Walker delta constellation)
  static const double defaultAltitudeKm = 550.0;
  static const double defaultInclinationDeg = 53.0;
  static const int numPlanes = 6;
  static const int satsPerPlane = 12; // 72 satellites total for high-fidelity real-time simulation

  final double altitudeKm;
  final double inclinationRad;
  final double orbitRadiusKm;
  final double orbitalSpeedKmS;
  final double orbitalPeriodSeconds;
  final double meanMotionRadS;

  OrbitalMechanics({
    this.altitudeKm = defaultAltitudeKm,
    double inclinationDeg = defaultInclinationDeg,
  })  : inclinationRad = inclinationDeg * math.pi / 180.0,
        orbitRadiusKm = earthRadiusKm + altitudeKm,
        orbitalSpeedKmS = math.sqrt(earthMu / (earthRadiusKm + altitudeKm)),
        orbitalPeriodSeconds = 2.0 * math.pi * math.sqrt(math.pow(earthRadiusKm + altitudeKm, 3) / earthMu),
        meanMotionRadS = math.sqrt(earthMu / math.pow(earthRadiusKm + altitudeKm, 3));

  /// Calculates satellite 3D position in Earth-Centered Inertial (ECI) coordinates at simulation time [tSec].
  /// [planeIndex]: 0 .. numPlanes - 1
  /// [slotIndex]: 0 .. satsPerPlane - 1
  Vector3 computeEciPosition(int planeIndex, int slotIndex, double tSec) {
    // RAAN (Right Ascension of Ascending Node)
    final raan = (planeIndex * (2.0 * math.pi / numPlanes));
    
    // Walker delta phasing: slots in adjacent planes have a phase offset
    final slotAngle = slotIndex * (2.0 * math.pi / satsPerPlane);
    final phaseOffset = (planeIndex * (math.pi / (numPlanes * satsPerPlane)));
    final trueAnomaly = (slotAngle + phaseOffset + (meanMotionRadS * tSec)) % (2.0 * math.pi);

    // Position in orbital plane
    final xOrb = orbitRadiusKm * math.cos(trueAnomaly);
    final yOrb = orbitRadiusKm * math.sin(trueAnomaly);

    // Rotate to ECI frame:
    // 1. Inclination rotation about x-axis
    // 2. RAAN rotation about z-axis
    final cosRaan = math.cos(raan);
    final sinRaan = math.sin(raan);
    final cosInc = math.cos(inclinationRad);
    final sinInc = math.sin(inclinationRad);

    final xEci = cosRaan * xOrb - sinRaan * cosInc * yOrb;
    final yEci = sinRaan * xOrb + cosRaan * cosInc * yOrb;
    final zEci = sinInc * yOrb;

    return Vector3(xEci, yEci, zEci);
  }

  /// Converts ECI position to Geographic (Latitude, Longitude in degrees) at simulation time [tSec].
  Map<String, double> eciToLatLong(Vector3 eciPos, double tSec) {
    final x = eciPos.x;
    final y = eciPos.y;
    final z = eciPos.z;

    final r = math.sqrt(x * x + y * y + z * z);
    final latRad = math.asin(z / r);
    final latDeg = latRad * 180.0 / math.pi;

    // Greenwich Mean Sidereal Time rotation
    final gmst = (earthRotationRateRadS * tSec) % (2.0 * math.pi);
    var lonRad = math.atan2(y, x) - gmst;

    // Normalize longitude to [-pi, pi]
    lonRad = (lonRad + math.pi) % (2.0 * math.pi) - math.pi;
    final lonDeg = lonRad * 180.0 / math.pi;

    return {
      'lat': latDeg,
      'lon': lonDeg,
    };
  }

  /// Calculates the satellite's current velocity in km/h.
  double get velocityKmh => orbitalSpeedKmS * 3600.0;
}
