import 'dart:math' as math;

/// State bundle for power and thermal status of a satellite.
class ThermalPowerState {
  final double batterySoC; // 0.0 to 1.0 (State of Charge)
  final double batteryPowerNetW; // Watts (positive = charging, negative = discharging)
  final double temperatureC; // Celsius
  final double thermalHeadroom; // Degrees until throttle threshold
  final bool isThrottled;
  final double throttleRatio; // 1.0 = normal, < 1.0 = throttled

  const ThermalPowerState({
    required this.batterySoC,
    required this.batteryPowerNetW,
    required this.temperatureC,
    required this.thermalHeadroom,
    required this.isThrottled,
    required this.throttleRatio,
  });
}

/// Physics-based lumped thermal and battery power model.
class ThermalPowerModel {
  // Battery specifications
  final double batteryCapacityWh; // e.g. 5000 Wh
  final double maxSolarPowerW; // e.g. 1500 W max solar generation
  final double basePowerDrawW; // e.g. 200 W for bus avionics, ADCS, telemetry
  final double maxComputePowerDrawW; // e.g. 800 W at 100% compute load
  final double minSafeBatterySoC; // e.g. 0.20 (20% reserve)

  // Thermal specifications
  final double thermalCapacitanceJPerK; // e.g. 120,000 J/K
  final double radiatorAreaM2; // e.g. 2.2 m^2
  final double radiatorEmissivity; // e.g. 0.88
  final double solarAbsorptivity; // e.g. 0.25
  final double maxOperatingTempC; // e.g. 68.0°C (throttles above this)
  final double criticalShutdownTempC; // e.g. 82.0°C

  // Stefan-Boltzmann constant (W / (m^2 * K^4))
  static const double sigma = 5.670374419e-8;
  static const double spaceTempK = 3.0; // Deep space background radiation temperature

  ThermalPowerModel({
    this.batteryCapacityWh = 5000.0,
    this.maxSolarPowerW = 1400.0,
    this.basePowerDrawW = 220.0,
    this.maxComputePowerDrawW = 780.0,
    this.minSafeBatterySoC = 0.20,
    this.thermalCapacitanceJPerK = 110000.0,
    this.radiatorAreaM2 = 2.4,
    this.radiatorEmissivity = 0.90,
    this.solarAbsorptivity = 0.22,
    this.maxOperatingTempC = 68.0,
    this.criticalShutdownTempC = 82.0,
  });

  /// Steps forward the thermal and battery state by [dtSeconds].
  /// [currentSoC]: 0.0 to 1.0
  /// [currentTempC]: Current temperature in Celsius
  /// [solarFluxFraction]: 0.0 (shadow) to 1.0 (sunlight)
  /// [computeUtilization]: 0.0 to 1.0 (fraction of total compute active)
  ThermalPowerState step({
    required double currentSoC,
    required double currentTempC,
    required double solarFluxFraction,
    required double computeUtilization,
    required double dtSeconds,
  }) {
    // 1. Determine Throttling based on current temperature
    double throttleRatio = 1.0;
    bool isThrottled = false;

    if (currentTempC > maxOperatingTempC) {
      isThrottled = true;
      // Linear throttle down to 10% compute at critical temperature
      final overtemp = currentTempC - maxOperatingTempC;
      final maxOvertemp = criticalShutdownTempC - maxOperatingTempC;
      throttleRatio = (1.0 - (overtemp / maxOvertemp) * 0.9).clamp(0.10, 1.0);
    }

    // Also throttle if battery is critically low (< 15%)
    if (currentSoC < 0.15) {
      isThrottled = true;
      throttleRatio = math.min(throttleRatio, 0.20);
    }

    // Effective compute utilization after throttling
    final effectiveComputeUtil = computeUtilization * throttleRatio;

    // 2. Power Balance
    final solarPowerGenerated = maxSolarPowerW * solarFluxFraction;
    final totalPowerDrawn = basePowerDrawW + (maxComputePowerDrawW * effectiveComputeUtil);
    final netPowerW = solarPowerGenerated - totalPowerDrawn;

    // Update battery State of Charge
    // Watt-hours = (Watts * dtSeconds) / 3600
    final energyDeltaWh = (netPowerW * dtSeconds) / 3600.0;
    var newSoC = currentSoC + (energyDeltaWh / batteryCapacityWh);
    newSoC = newSoC.clamp(0.05, 1.0); // Never drop below 5% or exceed 100%

    // 3. Lumped Thermal Model
    // Temperature in Kelvin
    final currentTempK = currentTempC + 273.15;

    // Heat inputs:
    // a. Direct solar radiation absorbed on satellite body
    // Approximate solar constant S = 1361 W/m^2
    const solarConstantWPerM2 = 1361.0;
    final bodyAreaFacingSunM2 = 1.5;
    final qSolarIn = solarConstantWPerM2 * bodyAreaFacingSunM2 * solarAbsorptivity * solarFluxFraction;

    // b. Internal heat dissipation from electronic compute and avionics
    // ~95% of consumed electrical power is converted into heat
    final qInternal = totalPowerDrawn * 0.92;

    // c. Radiative heat rejected to deep space
    // Q_rad = epsilon * sigma * A * (T^4 - T_space^4)
    final qRadiated = radiatorEmissivity * sigma * radiatorAreaM2 * (math.pow(currentTempK, 4) - math.pow(spaceTempK, 4));

    // Net thermal power (Watts = Joules / sec)
    final qNetWatts = qSolarIn + qInternal - qRadiated;

    // Change in temperature: dT = (Q_net * dt) / C_thermal
    final deltaTempK = (qNetWatts * dtSeconds) / thermalCapacitanceJPerK;
    var newTempC = currentTempC + deltaTempK;
    newTempC = newTempC.clamp(-30.0, 95.0); // Physics sanity clamps

    final thermalHeadroom = math.max(0.0, maxOperatingTempC - newTempC);

    return ThermalPowerState(
      batterySoC: newSoC,
      batteryPowerNetW: netPowerW,
      temperatureC: newTempC,
      thermalHeadroom: thermalHeadroom,
      isThrottled: isThrottled,
      throttleRatio: throttleRatio,
    );
  }
}
