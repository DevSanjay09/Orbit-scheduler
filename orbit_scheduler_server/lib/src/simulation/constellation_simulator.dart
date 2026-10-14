import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart';
import '../generated/protocol.dart';
import 'orbital_mechanics.dart';
import 'solar_shadow_model.dart';
import 'thermal_power_model.dart';
import 'isl_mesh_model.dart';
import 'ground_station_model.dart';

/// Simulator container representing an individual satellite's live dynamic state.
class SimSatellite {
  final String satelliteId;
  final int planeIndex;
  final int slotIndex;
  final double altitudeKm;
  final double inclinationDeg;
  final double totalComputeTFlops;

  Vector3 eciPosition;
  double latitude;
  double longitude;
  double trueAnomalyDeg;
  bool inSunlight;
  double solarFluxFraction;
  double batterySoC;
  double batteryPowerNetW;
  double temperatureC;
  double thermalHeadroom;
  bool isThrottled;
  double throttleRatio;
  double allocatedComputeTFlops;
  List<String> activeJobIds;
  String status; // ONLINE, DEGRADED, OFFLINE, FAULTED
  String? lastFaultReason;

  SimSatellite({
    required this.satelliteId,
    required this.planeIndex,
    required this.slotIndex,
    required this.altitudeKm,
    required this.inclinationDeg,
    required this.totalComputeTFlops,
    required this.eciPosition,
    required this.latitude,
    required this.longitude,
    required this.trueAnomalyDeg,
    required this.inSunlight,
    required this.solarFluxFraction,
    required this.batterySoC,
    required this.batteryPowerNetW,
    required this.temperatureC,
    required this.thermalHeadroom,
    required this.isThrottled,
    required this.throttleRatio,
    required this.allocatedComputeTFlops,
    required this.activeJobIds,
    required this.status,
    this.lastFaultReason,
  });

  Satellite toProtocol() {
    return Satellite(
      satelliteId: satelliteId,
      planeIndex: planeIndex,
      slotIndex: slotIndex,
      altitudeKm: altitudeKm,
      inclinationDeg: inclinationDeg,
      trueAnomalyDeg: trueAnomalyDeg,
      latitude: latitude,
      longitude: longitude,
      velocityKmh: 27360.0,
      inSunlight: inSunlight,
      solarFluxFraction: solarFluxFraction,
      batteryCapacityWh: 5000.0,
      batterySoC: batterySoC,
      batteryPowerNetW: batteryPowerNetW,
      temperatureC: temperatureC,
      thermalHeadroom: thermalHeadroom,
      isThrottled: isThrottled,
      throttleRatio: throttleRatio,
      totalComputeTFlops: totalComputeTFlops,
      allocatedComputeTFlops: allocatedComputeTFlops,
      activeJobIds: List<String>.from(activeJobIds),
      status: status,
      lastFaultReason: lastFaultReason,
      updatedAt: DateTime.now(),
    );
  }
}

/// Physics-based Constellation Simulator with ground station contact pass modeling.
class ConstellationSimulator {
  final OrbitalMechanics mechanics;
  final SolarShadowModel solarShadow;
  final ThermalPowerModel thermalPower;
  final IslMeshModel islMesh;
  final GroundStationModel groundStations;

  double simTimeSeconds = 0.0;
  final Map<String, SimSatellite> satellites = {};
  List<LinkWindow> activeLinks = [];
  Map<String, GroundPassWindow> activeGroundPasses = {};
  final Set<String> droppedSatelliteIds = {};

  ConstellationSimulator({
    OrbitalMechanics? mechanics,
    SolarShadowModel? solarShadow,
    ThermalPowerModel? thermalPower,
    IslMeshModel? islMesh,
    GroundStationModel? groundStations,
  })  : mechanics = mechanics ?? OrbitalMechanics(),
        solarShadow = solarShadow ?? SolarShadowModel(),
        thermalPower = thermalPower ?? ThermalPowerModel(),
        islMesh = islMesh ?? IslMeshModel(),
        groundStations = groundStations ?? GroundStationModel() {
    _initConstellation();
  }

  void _initConstellation() {
    satellites.clear();
    for (int p = 0; p < OrbitalMechanics.numPlanes; p++) {
      for (int s = 0; s < OrbitalMechanics.satsPerPlane; s++) {
        final satId = 'SAT-P${p.toString().padLeft(2, '0')}-S${s.toString().padLeft(2, '0')}';
        
        // Initial state at t = 0
        final eci = mechanics.computeEciPosition(p, s, 0.0);
        final latLon = mechanics.eciToLatLong(eci, 0.0);
        final sunVec = solarShadow.getSunUnitVector(0.0);
        final flux = solarShadow.computeSunlightFraction(eci, sunVec);
        final inSun = flux > 0.25;

        // Spread initial temperatures realistically (28°C - 38°C)
        final initialTemp = 32.0 + (s % 3) * 3.0 + (p % 2) * 2.0;
        final initialSoC = 0.75 + ((s + p) % 5) * 0.05; // 75% - 95%

        satellites[satId] = SimSatellite(
          satelliteId: satId,
          planeIndex: p,
          slotIndex: s,
          altitudeKm: mechanics.altitudeKm,
          inclinationDeg: OrbitalMechanics.defaultInclinationDeg,
          totalComputeTFlops: 120.0, // 120 TFlops AI compute per satellite
          eciPosition: eci,
          latitude: latLon['lat']!,
          longitude: latLon['lon']!,
          trueAnomalyDeg: (s * (360.0 / OrbitalMechanics.satsPerPlane)) % 360.0,
          inSunlight: inSun,
          solarFluxFraction: flux,
          batterySoC: initialSoC,
          batteryPowerNetW: inSun ? 400.0 : -350.0,
          temperatureC: initialTemp,
          thermalHeadroom: 68.0 - initialTemp,
          isThrottled: false,
          throttleRatio: 1.0,
          allocatedComputeTFlops: 0.0,
          activeJobIds: [],
          status: 'ONLINE',
        );
      }
    }
  }

  /// Advances physics simulation by [dtSeconds].
  void advanceSimulation(double dtSeconds) {
    simTimeSeconds += dtSeconds;
    final sunVec = solarShadow.getSunUnitVector(simTimeSeconds);

    // 1. Update satellite orbital kinematics, eclipse, thermal, and power
    for (final sat in satellites.values) {
      if (sat.status == 'OFFLINE') continue;

      final eci = mechanics.computeEciPosition(sat.planeIndex, sat.slotIndex, simTimeSeconds);
      final latLon = mechanics.eciToLatLong(eci, simTimeSeconds);
      final flux = solarShadow.computeSunlightFraction(eci, sunVec);
      final inSun = flux > 0.25;

      final computeUtil = (sat.allocatedComputeTFlops / sat.totalComputeTFlops).clamp(0.0, 1.0);

      // Step thermal & power model
      final tpState = thermalPower.step(
        currentSoC: sat.batterySoC,
        currentTempC: sat.temperatureC,
        solarFluxFraction: flux,
        computeUtilization: computeUtil,
        dtSeconds: dtSeconds,
      );

      sat.eciPosition = eci;
      sat.latitude = latLon['lat']!;
      sat.longitude = latLon['lon']!;
      sat.trueAnomalyDeg = ((sat.slotIndex * (360.0 / OrbitalMechanics.satsPerPlane)) +
          (mechanics.meanMotionRadS * simTimeSeconds * 180.0 / math.pi)) % 360.0;
      sat.inSunlight = inSun;
      sat.solarFluxFraction = flux;
      sat.batterySoC = tpState.batterySoC;
      sat.batteryPowerNetW = tpState.batteryPowerNetW;
      sat.temperatureC = tpState.temperatureC;
      sat.thermalHeadroom = tpState.thermalHeadroom;
      sat.isThrottled = tpState.isThrottled;
      sat.throttleRatio = tpState.throttleRatio;
    }

    // 2. Compute live ISL active laser links (inter-satellite line of sight)
    _updateActiveLinks();

    // 3. Compute active Ground Station contact passes
    _updateGroundPasses();
  }

  void _updateActiveLinks() {
    final links = <LinkWindow>[];
    final satList = satellites.values.toList();
    final now = DateTime.now();
    final validUntil = now.add(const Duration(minutes: 5));

    // Connect intra-plane neighbors and closest inter-plane neighbors
    for (int i = 0; i < satList.length; i++) {
      final satA = satList[i];
      if (satA.status == 'OFFLINE' || droppedSatelliteIds.contains(satA.satelliteId)) continue;
      // Realistic optical terminal availability:
      // Nodes undergoing optical terminal re-pointing (slot 4 in each plane) or at polar extremes (>48 deg)
      // cannot sustain optical crosslinks, modeling authentic unlinked satellites in red
      if (satA.slotIndex == 4 || satA.latitude.abs() > 48.0) continue;

      for (int j = i + 1; j < satList.length; j++) {
        final satB = satList[j];
        if (satB.status == 'OFFLINE' || droppedSatelliteIds.contains(satB.satelliteId)) continue;
        if (satB.slotIndex == 4 || satB.latitude.abs() > 48.0) continue;

        // Only evaluate neighbors (same plane adjacent slot, or adjacent plane matching slot)
        final samePlane = satA.planeIndex == satB.planeIndex;
        final adjacentPlane = ((satA.planeIndex - satB.planeIndex).abs() % (OrbitalMechanics.numPlanes - 1)) <= 1;
        final slotDiff = (satA.slotIndex - satB.slotIndex).abs();
        final isAdjacentSlot = slotDiff == 1 || slotDiff == (OrbitalMechanics.satsPerPlane - 1);

        if ((samePlane && isAdjacentSlot) || (adjacentPlane && slotDiff <= 1)) {
          final distance = islMesh.checkLineOfSight(satA.eciPosition, satB.eciPosition);
          if (distance != null) {
            links.add(LinkWindow(
              sourceSatelliteId: satA.satelliteId,
              targetSatelliteId: satB.satelliteId,
              linkType: 'ISL_LASER',
              isOpen: true,
              distanceKm: distance,
              bandwidthMbps: IslMeshModel.nominalIslBandwidthMbps,
              lossRisk: 0.01,
              validUntil: validUntil,
            ));
          }
        }
      }
    }
    activeLinks = links;
  }

  void _updateGroundPasses() {
    final passes = <String, GroundPassWindow>{};
    for (final sat in satellites.values) {
      if (sat.status == 'OFFLINE') continue;
      final active = groundStations.findActivePasses(sat.satelliteId, sat.latitude, sat.longitude);
      if (active.isNotEmpty) {
        passes[sat.satelliteId] = active.first;
      }
    }
    activeGroundPasses = passes;
  }

  bool isSatelliteInGroundContact(String satId) => activeGroundPasses.containsKey(satId);

  GroundPassWindow? getActiveGroundPass(String satId) => activeGroundPasses[satId];

  List<GroundPassWindow> getAllActiveGroundPasses() => activeGroundPasses.values.toList();

  /// Lookahead prediction: calculates seconds until the given satellite next passes over any ground station.
  double predictTimeToNextGroundPass(String satId, {double horizonSec = 3600.0, double stepSec = 30.0}) {
    final sat = satellites[satId];
    if (sat == null) return horizonSec;

    // If currently in pass, next pass is 0s away
    if (activeGroundPasses.containsKey(satId)) return 0.0;

    final steps = (horizonSec / stepSec).round();
    for (int i = 1; i <= steps; i++) {
      final futureTime = simTimeSeconds + (i * stepSec);
      final eci = mechanics.computeEciPosition(sat.planeIndex, sat.slotIndex, futureTime);
      final latLon = mechanics.eciToLatLong(eci, futureTime);

      for (final gs in groundStations.stations) {
        final dist = groundStations.calculateGroundDistanceKm(
          latLon['lat']!,
          latLon['lon']!,
          gs.latitudeDeg,
          gs.longitudeDeg,
        );
        if (dist <= gs.maxSlantRangeKm) {
          return i * stepSec;
        }
      }
    }

    return horizonSec;
  }

  /// Lookahead Forecast: Projects a satellite's battery SoC, temperature, and sunlight over [horizonHours].
  TelemetryForecast generateForecast(String satelliteId, {double horizonHours = 3.0, int steps = 24}) {
    final sat = satellites[satelliteId];
    if (sat == null) {
      throw ArgumentError('Satellite $satelliteId not found');
    }

    final now = DateTime.now();
    final timestamps = <DateTime>[];
    final socList = <double>[];
    final tempList = <double>[];
    final sunList = <bool>[];

    final totalDurationSec = horizonHours * 3600.0;
    final dtSec = totalDurationSec / steps;

    var curSoC = sat.batterySoC;
    var curTemp = sat.temperatureC;
    final computeUtil = (sat.allocatedComputeTFlops / sat.totalComputeTFlops).clamp(0.0, 1.0);

    double predictedSafeWindowSec = totalDurationSec;
    bool foundCutoff = false;

    for (int i = 0; i <= steps; i++) {
      final futureTime = simTimeSeconds + (i * dtSec);
      final futureDate = now.add(Duration(seconds: (i * dtSec).round()));

      final eci = mechanics.computeEciPosition(sat.planeIndex, sat.slotIndex, futureTime);
      final sunVec = solarShadow.getSunUnitVector(futureTime);
      final flux = solarShadow.computeSunlightFraction(eci, sunVec);
      final inSun = flux > 0.25;

      final tpState = thermalPower.step(
        currentSoC: curSoC,
        currentTempC: curTemp,
        solarFluxFraction: flux,
        computeUtilization: computeUtil,
        dtSeconds: dtSec,
      );

      curSoC = tpState.batterySoC;
      curTemp = tpState.temperatureC;

      timestamps.add(futureDate);
      socList.add(curSoC);
      tempList.add(curTemp);
      sunList.add(inSun);

      // Check if satellite will hit unsafe condition (battery < 20% or temp > 72°C)
      if (!foundCutoff && (curSoC < 0.20 || curTemp > 72.0)) {
        predictedSafeWindowSec = i * dtSec;
        foundCutoff = true;
      }
    }

    // Link windows available to this satellite
    final satLinks = activeLinks.where((l) =>
        l.sourceSatelliteId == satelliteId || l.targetSatelliteId == satelliteId).toList();

    return TelemetryForecast(
      satelliteId: satelliteId,
      timestamps: timestamps,
      batterySoCList: socList,
      temperatureList: tempList,
      inSunlightList: sunList,
      predictedSafeWindowSeconds: predictedSafeWindowSec,
      linkWindows: satLinks,
    );
  }
}
