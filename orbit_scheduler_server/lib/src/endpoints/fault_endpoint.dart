import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../engine/orbit_engine.dart';

class FaultEndpoint extends Endpoint {
  /// Manually triggers a fault event on demand.
  Future<FaultEvent> triggerFault(
    Session session, {
    required String faultType, // RADIATION_UPSET, LINK_DROP, THERMAL_SPIKE, SATELLITE_LOSS
    String? targetSatelliteId,
  }) async {
    final engine = OrbitEngine.instance;
    switch (faultType) {
      case 'RADIATION_UPSET':
        return engine.faultEngine.triggerRadiationUpset(engine.simulator, targetSatId: targetSatelliteId);
      case 'LINK_DROP':
        return engine.faultEngine.triggerLinkDrop(engine.simulator, satAId: targetSatelliteId);
      case 'THERMAL_SPIKE':
        return engine.faultEngine.triggerThermalSpike(engine.simulator, targetSatId: targetSatelliteId);
      case 'SATELLITE_LOSS':
        return engine.faultEngine.triggerSatelliteLoss(engine.simulator, targetSatId: targetSatelliteId);
      default:
        return engine.faultEngine.triggerRadiationUpset(engine.simulator, targetSatId: targetSatelliteId);
    }
  }

  /// Lists recent fault injection history.
  Future<List<FaultEvent>> listRecentFaults(Session session) async {
    return OrbitEngine.instance.faultEngine.history;
  }

  /// Real-time stream of newly triggered fault events.
  Stream<FaultEvent> streamFaults(Session session) async* {
    yield* OrbitEngine.instance.faultStream;
  }
}
