import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart';
import 'orbital_mechanics.dart';

/// Models the solar position and Earth shadow geometry (eclipse).
class SolarShadowModel {
  // Approximate obliquity of the ecliptic (23.44 degrees)
  static const double eclipticObliquityRad = 23.44 * math.pi / 180.0;

  /// Returns unit vector towards the Sun in ECI coordinates at simulation time [tSec].
  /// Assumes an arbitrary starting epoch with solar progression ~365.25 days per revolution.
  Vector3 getSunUnitVector(double tSec) {
    // Solar longitude (annual variation)
    // 1 year = 31557600 seconds. For simulation dynamic visualization, we can also add a diurnal modulation
    final solarLongRad = (2.0 * math.pi * (tSec / 86400.0 / 365.25)) % (2.0 * math.pi);
    
    final sx = math.cos(solarLongRad);
    final sy = math.sin(solarLongRad) * math.cos(eclipticObliquityRad);
    final sz = math.sin(solarLongRad) * math.sin(eclipticObliquityRad);

    final sunVec = Vector3(sx, sy, sz);
    return sunVec.normalized();
  }

  /// Calculates the fraction of direct sunlight (0.0 = total umbra/eclipse, 1.0 = direct sunlight).
  /// Uses a cylindrical shadow approximation with penumbra boundary smoothing.
  double computeSunlightFraction(Vector3 eciPosition, Vector3 sunUnitVector) {
    // Project satellite position along sun vector
    final dot = eciPosition.dot(sunUnitVector);

    // If satellite is on the sunward side of Earth, it's always in full sunlight
    if (dot > 0) {
      return 1.0;
    }

    // Distance perpendicular to the Earth-Sun line
    // pos_perp = pos - (dot * sun_hat)
    final parallelComp = sunUnitVector.scaled(dot);
    final perpComp = eciPosition - parallelComp;
    final perpDistKm = perpComp.length;

    const rEarth = OrbitalMechanics.earthRadiusKm;
    const penumbraMarginKm = 75.0; // Atmospheric / penumbral transition band

    if (perpDistKm < rEarth - penumbraMarginKm) {
      // Deep umbra (full eclipse)
      return 0.0;
    } else if (perpDistKm < rEarth + penumbraMarginKm) {
      // Penumbra (partial sunlight transition)
      final fraction = (perpDistKm - (rEarth - penumbraMarginKm)) / (2.0 * penumbraMarginKm);
      return fraction.clamp(0.0, 1.0);
    } else {
      // Satellite passes outside Earth's shadow cylinder
      return 1.0;
    }
  }

  /// Returns true if satellite is in eclipse (solar flux < 0.25).
  bool isInEclipse(Vector3 eciPosition, Vector3 sunUnitVector) {
    return computeSunlightFraction(eciPosition, sunUnitVector) < 0.25;
  }
}
