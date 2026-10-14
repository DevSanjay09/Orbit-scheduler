import 'package:flutter/material.dart';
import 'package:orbit_scheduler_client/orbit_scheduler_client.dart';
import '../theme/orbit_theme.dart';
import '../services/orbit_service.dart';

/// Interactive telemetry HUD modal displaying live status of a selected satellite.
/// Designed in a luxury monochrome aerospace console aesthetic.
class SatelliteHudDialog extends StatelessWidget {
  final Satellite satellite;
  final VoidCallback? onOpenForecast;

  const SatelliteHudDialog({
    super.key,
    required this.satellite,
    this.onOpenForecast,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24.0),
      child: Container(
        width: 520,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: OrbitTheme.cardDark,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: OrbitTheme.cardBorder, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.8),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: OrbitTheme.surfaceElevated,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: OrbitTheme.cardBorder),
                      ),
                      child: const Icon(Icons.satellite_alt, color: OrbitTheme.white, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          satellite.satelliteId,
                          style: const TextStyle(
                            color: OrbitTheme.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'Plane ${satellite.planeIndex} • Slot ${satellite.slotIndex} • Alt ${satellite.altitudeKm.toInt()} km',
                          style: const TextStyle(color: OrbitTheme.textMuted, fontSize: 11.5),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: OrbitTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: OrbitTheme.cardBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: satellite.status == 'ONLINE' ? OrbitTheme.white : OrbitTheme.textMuted,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        satellite.status,
                        style: const TextStyle(
                          color: OrbitTheme.textPrimary,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Divider(color: OrbitTheme.cardBorder, height: 1),
            const SizedBox(height: 18),

            // Live Telemetry Grid
            Row(
              children: [
                Expanded(
                  child: _telemetryCard(
                    title: 'BATTERY SOC',
                    value: '${(satellite.batterySoC * 100).toStringAsFixed(1)}%',
                    subtitle: satellite.batteryPowerNetW >= 0
                        ? '+${satellite.batteryPowerNetW.toStringAsFixed(0)}W Charging'
                        : '${satellite.batteryPowerNetW.toStringAsFixed(0)}W Discharging',
                    icon: Icons.battery_charging_full,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _telemetryCard(
                    title: 'CORE TEMPERATURE',
                    value: '${satellite.temperatureC.toStringAsFixed(1)}°C',
                    subtitle: 'Headroom: ${satellite.thermalHeadroom.toStringAsFixed(1)}°C',
                    icon: Icons.thermostat,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _telemetryCard(
                    title: 'SOLAR EXPOSURE',
                    value: satellite.inSunlight ? 'IN SUNLIGHT' : 'EARTH SHADOW',
                    subtitle: 'Solar Flux: ${(satellite.solarFluxFraction * 100).toStringAsFixed(0)}%',
                    icon: satellite.inSunlight ? Icons.wb_sunny_outlined : Icons.nightlight_round,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _telemetryCard(
                    title: 'COMPUTE UTILIZATION',
                    value: '${satellite.allocatedComputeTFlops.toStringAsFixed(0)} / ${satellite.totalComputeTFlops.toStringAsFixed(0)} TF',
                    subtitle: satellite.isThrottled
                        ? 'Throttled (${(satellite.throttleRatio * 100).toStringAsFixed(0)}%)'
                        : 'Full Throttle (100%)',
                    icon: Icons.memory,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Active Workloads
            const Text(
              'ACTIVE WORKLOADS ON NODE',
              style: TextStyle(
                color: OrbitTheme.textMuted,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: OrbitTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: OrbitTheme.cardBorder),
              ),
              child: satellite.activeJobIds.isEmpty
                  ? const Text(
                      'No active compute workloads assigned to node.',
                      style: TextStyle(color: OrbitTheme.textMuted, fontSize: 12, fontStyle: FontStyle.italic),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: satellite.activeJobIds.map((jobId) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              const Icon(Icons.circle, color: OrbitTheme.white, size: 7),
                              const SizedBox(width: 8),
                              Text(
                                jobId,
                                style: const TextStyle(
                                  color: OrbitTheme.textPrimary,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
            const SizedBox(height: 22),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close', style: TextStyle(color: OrbitTheme.textSecondary, fontSize: 12.5)),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: () {
                    OrbitService.instance.triggerFault(
                      faultType: 'RADIATION_UPSET',
                      targetSatelliteId: satellite.satelliteId,
                    );
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Injected Radiation SEU fault on ${satellite.satelliteId}')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: OrbitTheme.white,
                    side: const BorderSide(color: OrbitTheme.cardBorder),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.flash_on, size: 14),
                  label: const Text('Inject SEU Fault', style: TextStyle(fontSize: 12)),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onOpenForecast?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: OrbitTheme.white,
                    foregroundColor: OrbitTheme.bgDark,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.timeline, size: 15),
                  label: const Text('View 3h Forecast', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _telemetryCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: OrbitTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: OrbitTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: OrbitTheme.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              Icon(icon, color: OrbitTheme.textMuted, size: 14),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: OrbitTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'monospace',
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: const TextStyle(color: OrbitTheme.textSecondary, fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
