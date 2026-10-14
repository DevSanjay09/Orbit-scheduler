import 'dart:math' as math;

/// Physical Ground Station representing Earth uplink/downlink terminals.
class GroundStation {
  final String stationId;
  final String name;
  final double latitudeDeg;
  final double longitudeDeg;
  final double elevationMaskDeg; // typically 10 degrees minimum
  final double maxSlantRangeKm; // typically ~1800 km for 550 km LEO
  final double uplinkBandwidthGbps;
  final double downlinkBandwidthGbps;

  const GroundStation({
    required this.stationId,
    required this.name,
    required this.latitudeDeg,
    required this.longitudeDeg,
    this.elevationMaskDeg = 10.0,
    this.maxSlantRangeKm = 1850.0,
    this.uplinkBandwidthGbps = 10.0,
    this.downlinkBandwidthGbps = 10.0,
  });
}

/// Represents an active or predicted contact pass between a satellite and ground station.
class GroundPassWindow {
  final String stationId;
  final String stationName;
  final String satelliteId;
  final double distanceKm;
  final double elevationDeg;
  final bool isActive;
  final double estimatedDurationSec;

  const GroundPassWindow({
    required this.stationId,
    required this.stationName,
    required this.satelliteId,
    required this.distanceKm,
    required this.elevationDeg,
    required this.isActive,
    required this.estimatedDurationSec,
  });
}

/// Earth Ground Station Network model for orbital compute data ingest and results egress.
class GroundStationModel {
  static const double earthRadiusKm = 6371.0;

  final List<GroundStation> stations = const [
    GroundStation(
      stationId: 'GS-SVALBARD',
      name: 'Svalbard Arctic Terminal (Norway)',
      latitudeDeg: 78.22,
      longitudeDeg: 15.65,
    ),
    GroundStation(
      stationId: 'GS-TROMSO',
      name: 'Tromsø High-Latitude Station (Norway)',
      latitudeDeg: 69.65,
      longitudeDeg: 18.96,
    ),
    GroundStation(
      stationId: 'GS-FAIRBANKS',
      name: 'Fairbanks Facility (Alaska)',
      latitudeDeg: 64.84,
      longitudeDeg: -147.72,
    ),
    GroundStation(
      stationId: 'GS-MADRID',
      name: 'Madrid Deep Terminal (Spain)',
      latitudeDeg: 40.43,
      longitudeDeg: -4.25,
    ),
    GroundStation(
      stationId: 'GS-GOLDSTONE',
      name: 'Goldstone Complex (California)',
      latitudeDeg: 35.43,
      longitudeDeg: -116.89,
    ),
    GroundStation(
      stationId: 'GS-SINGAPORE',
      name: 'Singapore Equatorial Gateway',
      latitudeDeg: 1.35,
      longitudeDeg: 103.82,
    ),
    GroundStation(
      stationId: 'GS-CANBERRA',
      name: 'Canberra Southern Terminal (Australia)',
      latitudeDeg: -35.40,
      longitudeDeg: 148.98,
    ),
    GroundStation(
      stationId: 'GS-SANTIAGO',
      name: 'Santiago Station (Chile)',
      latitudeDeg: -33.45,
      longitudeDeg: -70.67,
    ),
    GroundStation(
      stationId: 'GS-HAWAII',
      name: 'Hawaii Pacific Terminal',
      latitudeDeg: 21.31,
      longitudeDeg: -157.86,
    ),
    GroundStation(
      stationId: 'GS-MCMURDO',
      name: 'McMurdo Polar Gateway (Antarctica)',
      latitudeDeg: -77.85,
      longitudeDeg: 166.67,
    ),
  ];

  /// Checks if a satellite at [satLatDeg], [satLonDeg] is in line-of-sight contact with [station].
  bool isSatelliteInPass(double satLatDeg, double satLonDeg, GroundStation station) {
    final distKm = calculateGroundDistanceKm(satLatDeg, satLonDeg, station.latitudeDeg, station.longitudeDeg);
    return distKm <= station.maxSlantRangeKm;
  }

  /// Calculates spherical great-circle surface distance in kilometers.
  double calculateGroundDistanceKm(double lat1Deg, double lon1Deg, double lat2Deg, double lon2Deg) {
    final phi1 = lat1Deg * math.pi / 180.0;
    final phi2 = lat2Deg * math.pi / 180.0;
    final deltaPhi = (lat2Deg - lat1Deg) * math.pi / 180.0;
    final deltaLambda = (lon2Deg - lon1Deg) * math.pi / 180.0;

    final a = math.sin(deltaPhi / 2) * math.sin(deltaPhi / 2) +
        math.cos(phi1) * math.cos(phi2) * math.sin(deltaLambda / 2) * math.sin(deltaLambda / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadiusKm * c;
  }

  /// Finds all ground stations currently in active contact with a satellite.
  List<GroundPassWindow> findActivePasses(String satId, double satLatDeg, double satLonDeg) {
    final active = <GroundPassWindow>[];
    for (final gs in stations) {
      final distKm = calculateGroundDistanceKm(satLatDeg, satLonDeg, gs.latitudeDeg, gs.longitudeDeg);
      if (distKm <= gs.maxSlantRangeKm) {
        // Approximate elevation: 90 deg at 0 km, 10 deg at maxSlantRangeKm
        final elev = math.max(10.0, 90.0 - (distKm / gs.maxSlantRangeKm) * 80.0);
        active.add(GroundPassWindow(
          stationId: gs.stationId,
          stationName: gs.name,
          satelliteId: satId,
          distanceKm: distKm,
          elevationDeg: elev,
          isActive: true,
          estimatedDurationSec: (1.0 - (distKm / gs.maxSlantRangeKm)) * 480.0 + 60.0, // typical 5-10 min pass
        ));
      }
    }
    return active;
  }

  /// Evaluates whether any satellite in [satellitesLatLon] is currently over a ground station.
  GroundPassWindow? findNearestGroundContact(Map<String, List<double>> satellitesLatLon) {
    GroundPassWindow? bestPass;
    double minDistance = 999999.0;

    for (final entry in satellitesLatLon.entries) {
      final satId = entry.key;
      final lat = entry.value[0];
      final lon = entry.value[1];

      for (final gs in stations) {
        final distKm = calculateGroundDistanceKm(lat, lon, gs.latitudeDeg, gs.longitudeDeg);
        if (distKm <= gs.maxSlantRangeKm && distKm < minDistance) {
          minDistance = distKm;
          bestPass = GroundPassWindow(
            stationId: gs.stationId,
            stationName: gs.name,
            satelliteId: satId,
            distanceKm: distKm,
            elevationDeg: math.max(10.0, 90.0 - (distKm / gs.maxSlantRangeKm) * 80.0),
            isActive: true,
            estimatedDurationSec: 360.0,
          );
        }
      }
    }

    return bestPass;
  }
}
