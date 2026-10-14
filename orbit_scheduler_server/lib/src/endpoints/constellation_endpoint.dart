import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../engine/orbit_engine.dart';

class ConstellationEndpoint extends Endpoint {
  /// Fetches the latest snapshot of the entire constellation.
  Future<ConstellationState> getState(Session session) async {
    return OrbitEngine.instance.buildConstellationState();
  }

  /// Real-time Serverpod streaming endpoint delivering live constellation updates.
  Stream<ConstellationState> streamState(Session session) async* {
    yield OrbitEngine.instance.buildConstellationState();
    yield* OrbitEngine.instance.stateStream;
  }

  /// Generates multi-hour lookahead forecast for a specific satellite.
  Future<TelemetryForecast> getSatelliteForecast(Session session, String satelliteId) async {
    return OrbitEngine.instance.simulator.generateForecast(satelliteId, horizonHours: 3.0);
  }

  /// Adjusts simulation time warp multiplier.
  Future<double> setSimSpeed(Session session, double multiplier) async {
    OrbitEngine.instance.simSpeedMultiplier = multiplier.clamp(0.5, 50.0);
    return OrbitEngine.instance.simSpeedMultiplier;
  }
}
