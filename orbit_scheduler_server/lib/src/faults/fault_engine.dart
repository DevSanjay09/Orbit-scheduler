import 'dart:math' as math;
import '../generated/protocol.dart';
import '../simulation/constellation_simulator.dart';

typedef FaultCallback = void Function(FaultEvent event);

/// Seeded, repeatable fault injection engine.
class FaultEngine {
  final int seed;
  late math.Random _random;
  final List<FaultEvent> _faultHistory = [];
  final List<FaultCallback> _listeners = [];

  FaultEngine({this.seed = 42}) {
    _random = math.Random(seed);
  }

  void reset(int newSeed) {
    _random = math.Random(newSeed);
    _faultHistory.clear();
  }

  void addListener(FaultCallback callback) {
    _listeners.add(callback);
  }

  void removeListener(FaultCallback callback) {
    _listeners.remove(callback);
  }

  List<FaultEvent> get history => List.unmodifiable(_faultHistory);

  /// Triggers a radiation upset (SEU: Single Event Upset) on a target satellite.
  FaultEvent triggerRadiationUpset(ConstellationSimulator simulator, {String? targetSatId}) {
    final satId = targetSatId ?? _pickRandomOnlineSatellite(simulator);
    final sat = simulator.satellites[satId];

    final event = FaultEvent(
      eventId: 'FLT-RAD-${DateTime.now().millisecondsSinceEpoch % 100000}',
      eventType: 'RADIATION_UPSET',
      targetSatelliteId: satId,
      description: 'Single Event Upset (SEU) detected in SRAM compute pipeline on $satId. Compute parity corrupted.',
      impactSeverity: 'HIGH',
      occurredAt: DateTime.now(),
      resolved: false,
    );

    if (sat != null) {
      sat.lastFaultReason = 'RADIATION_SEU_CORRUPTION';
    }

    _recordAndNotify(event);
    return event;
  }

  /// Triggers an Inter-Satellite Laser (ISL) link drop.
  FaultEvent triggerLinkDrop(ConstellationSimulator simulator, {String? satAId, String? satBId}) {
    String source = satAId ?? _pickRandomOnlineSatellite(simulator);
    String target = satBId ?? _pickRandomOnlineSatellite(simulator);

    if (simulator.activeLinks.isNotEmpty) {
      final link = simulator.activeLinks[_random.nextInt(simulator.activeLinks.length)];
      source = link.sourceSatelliteId;
      target = link.targetSatelliteId;
    }

    simulator.droppedSatelliteIds.add(source);
    simulator.droppedSatelliteIds.add(target);
    simulator.activeLinks.removeWhere((l) =>
        l.sourceSatelliteId == source ||
        l.targetSatelliteId == source ||
        l.sourceSatelliteId == target ||
        l.targetSatelliteId == target);

    final event = FaultEvent(
      eventId: 'FLT-LNK-${DateTime.now().millisecondsSinceEpoch % 100000}',
      eventType: 'LINK_DROP',
      targetSatelliteId: source,
      secondaryTargetSatelliteId: target,
      description: 'Laser ISL beam tracking lost between $source and $target due to orbital attitude jitter.',
      impactSeverity: 'MEDIUM',
      occurredAt: DateTime.now(),
      resolved: false,
    );

    _recordAndNotify(event);
    return event;
  }

  /// Triggers thermal spike / radiator degradation.
  FaultEvent triggerThermalSpike(ConstellationSimulator simulator, {String? targetSatId}) {
    final satId = targetSatId ?? _pickRandomOnlineSatellite(simulator);
    final sat = simulator.satellites[satId];

    if (sat != null) {
      sat.temperatureC = (sat.temperatureC + 24.0).clamp(0.0, 88.0);
      sat.thermalHeadroom = math.max(0.0, 68.0 - sat.temperatureC);
      sat.lastFaultReason = 'THERMAL_SPIKE_OVERHEAT';
    }

    final event = FaultEvent(
      eventId: 'FLT-THM-${DateTime.now().millisecondsSinceEpoch % 100000}',
      eventType: 'THERMAL_SPIKE',
      targetSatelliteId: satId,
      description: 'Solar flare thermal absorption spike on $satId. Core temperature soared to ${sat?.temperatureC.toStringAsFixed(1)}°C.',
      impactSeverity: 'HIGH',
      occurredAt: DateTime.now(),
      resolved: false,
    );

    _recordAndNotify(event);
    return event;
  }

  /// Triggers full satellite power loss / offline state.
  FaultEvent triggerSatelliteLoss(ConstellationSimulator simulator, {String? targetSatId}) {
    final satId = targetSatId ?? _pickRandomOnlineSatellite(simulator);
    final sat = simulator.satellites[satId];

    if (sat != null) {
      sat.status = 'OFFLINE';
      sat.batterySoC = 0.05;
      sat.lastFaultReason = 'POWER_BUS_FAILURE';
      simulator.droppedSatelliteIds.add(satId);
      simulator.activeLinks.removeWhere((l) =>
          l.sourceSatelliteId == satId || l.targetSatelliteId == satId);
    }

    final event = FaultEvent(
      eventId: 'FLT-LOS-${DateTime.now().millisecondsSinceEpoch % 100000}',
      eventType: 'SATELLITE_LOSS',
      targetSatelliteId: satId,
      description: 'Bus power inverter failure on $satId. Satellite dropped offline.',
      impactSeverity: 'CRITICAL',
      occurredAt: DateTime.now(),
      resolved: false,
    );

    _recordAndNotify(event);
    return event;
  }

  /// Periodic background probabilistic fault check during simulation tick.
  FaultEvent? stepProbabilisticFaults(ConstellationSimulator simulator, double dtSeconds) {
    // Injects fault roughly once every 45-90 seconds of simulation
    final roll = _random.nextDouble();
    final faultProb = (dtSeconds / 60.0) * 0.35; // 35% chance per simulated minute

    if (roll < faultProb) {
      final faultTypeRoll = _random.nextInt(4);
      switch (faultTypeRoll) {
        case 0:
          return triggerRadiationUpset(simulator);
        case 1:
          return triggerLinkDrop(simulator);
        case 2:
          return triggerThermalSpike(simulator);
        case 3:
          return triggerSatelliteLoss(simulator);
      }
    }
    return null;
  }

  String _pickRandomOnlineSatellite(ConstellationSimulator simulator) {
    final onlineSats = simulator.satellites.values.where((s) => s.status != 'OFFLINE').toList();
    if (onlineSats.isEmpty) return 'SAT-P00-S00';
    return onlineSats[_random.nextInt(onlineSats.length)].satelliteId;
  }

  void _recordAndNotify(FaultEvent event) {
    _faultHistory.insert(0, event);
    if (_faultHistory.length > 100) {
      _faultHistory.removeLast();
    }
    for (final listener in _listeners) {
      listener(event);
    }
  }
}
