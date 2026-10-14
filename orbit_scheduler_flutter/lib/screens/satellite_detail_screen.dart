import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:orbit_scheduler_client/orbit_scheduler_client.dart';
import '../services/orbit_service.dart';

/// Screen 3: Professional Aerospace Flight Telemetry Forecast & ISL Link Schedule.
class SatelliteDetailScreen extends StatefulWidget {
  final String? initialSatelliteId;

  const SatelliteDetailScreen({super.key, this.initialSatelliteId});

  @override
  State<SatelliteDetailScreen> createState() => _SatelliteDetailScreenState();
}

class _SatelliteDetailScreenState extends State<SatelliteDetailScreen> {
  late String _selectedSatId;
  TelemetryForecast? _forecast;
  bool _isLoading = false;

  // Professional flight console tokens
  static const Color _consoleBg = Color(0xFF090D14);
  static const Color _cardBg = Color(0xFF0F172A);
  static const Color _cardBorder = Color(0xFF1E293B);
  static const Color _textHeader = Color(0xFFE2E8F0);
  static const Color _textSub = Color(0xFF94A3B8);
  static const Color _telemetryCyan = Color(0xFF38BDF8);
  static const Color _telemetryAmber = Color(0xFFF59E0B);
  static const Color _telemetryGreen = Color(0xFF10B981);
  static const Color _telemetryRed = Color(0xFFEF4444);

  @override
  void initState() {
    super.initState();
    _selectedSatId = widget.initialSatelliteId ?? 'SAT-P00-S00';
    _loadForecast();
  }

  void _loadForecast() async {
    setState(() => _isLoading = true);
    final fc = await OrbitService.instance.fetchForecast(_selectedSatId);
    if (mounted) {
      setState(() {
        _forecast = fc;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = OrbitService.instance;
    final state = service.latestState;
    final satellites = state?.satellites ?? [];

    final currentSat = satellites.firstWhere(
      (s) => s.satelliteId == _selectedSatId,
      orElse: () => satellites.isNotEmpty
          ? satellites.first
          : Satellite(
              satelliteId: _selectedSatId,
              planeIndex: 0,
              slotIndex: 0,
              altitudeKm: 550.0,
              inclinationDeg: 53.0,
              trueAnomalyDeg: 0.0,
              latitude: 0.0,
              longitude: 0.0,
              velocityKmh: 27360.0,
              inSunlight: true,
              solarFluxFraction: 1.0,
              batteryCapacityWh: 5000.0,
              batterySoC: 0.85,
              batteryPowerNetW: 350.0,
              temperatureC: 36.0,
              thermalHeadroom: 32.0,
              isThrottled: false,
              throttleRatio: 1.0,
              totalComputeTFlops: 120.0,
              allocatedComputeTFlops: 30.0,
              activeJobIds: [],
              status: 'ONLINE',
              updatedAt: DateTime.now(),
            ),
    );

    return Container(
      color: _consoleBg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flight Telemetry Header & Node Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _telemetryCyan.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: _telemetryCyan.withValues(alpha: 0.3)),
                      ),
                      child: const Icon(Icons.satellite_alt, color: _telemetryCyan, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'ORBITAL FLIGHT TELEMETRY',
                              style: TextStyle(
                                color: _textSub,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.4,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: currentSat.status == 'ONLINE'
                                    ? _telemetryGreen.withValues(alpha: 0.15)
                                    : _telemetryRed.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: currentSat.status == 'ONLINE'
                                      ? _telemetryGreen.withValues(alpha: 0.4)
                                      : _telemetryRed.withValues(alpha: 0.4),
                                ),
                              ),
                              child: Text(
                                currentSat.status,
                                style: TextStyle(
                                  color: currentSat.status == 'ONLINE' ? _telemetryGreen : _telemetryRed,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _selectedSatId,
                          style: const TextStyle(
                            color: _textHeader,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: _cardBg,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: satellites.any((s) => s.satelliteId == _selectedSatId)
                          ? _selectedSatId
                          : (satellites.isNotEmpty ? satellites.first.satelliteId : _selectedSatId),
                      dropdownColor: _cardBg,
                      style: const TextStyle(color: _textHeader, fontWeight: FontWeight.w600, fontSize: 12),
                      items: satellites.map((s) {
                        return DropdownMenuItem(
                          value: s.satelliteId,
                          child: Text('${s.satelliteId} (P${s.planeIndex}-S${s.slotIndex})'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedSatId = val);
                          _loadForecast();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 4 Telemetry Metric Gauges
            Row(
              children: [
                Expanded(
                  child: _gaugeCard(
                    'BATTERY SoC',
                    '${(currentSat.batterySoC * 100).toStringAsFixed(1)}%',
                    currentSat.batteryPowerNetW >= 0
                        ? '+${currentSat.batteryPowerNetW.toStringAsFixed(0)}W Solar Input'
                        : '${currentSat.batteryPowerNetW.toStringAsFixed(0)}W Net Drain',
                    _telemetryCyan,
                    Icons.battery_charging_full,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _gaugeCard(
                    'CORE THERMAL',
                    '${currentSat.temperatureC.toStringAsFixed(1)}°C',
                    'Margin to Throttle: ${currentSat.thermalHeadroom.toStringAsFixed(1)}°C',
                    currentSat.temperatureC > 58 ? _telemetryRed : _telemetryAmber,
                    Icons.thermostat,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _gaugeCard(
                    'SOLAR ILLUMINATION',
                    currentSat.inSunlight ? 'IN SUNLIGHT' : 'ECLIPSE SHADOW',
                    'Solar Flux: ${(currentSat.solarFluxFraction * 100).toStringAsFixed(0)}%',
                    currentSat.inSunlight ? _telemetryAmber : _textSub,
                    currentSat.inSunlight ? Icons.wb_sunny : Icons.nightlight_round,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _gaugeCard(
                    'SAFE LOOKAHEAD HORIZON',
                    _forecast != null
                        ? '${(_forecast!.predictedSafeWindowSeconds / 60).toStringAsFixed(0)} min'
                        : 'Simulating...',
                    'Trajectory lookahead',
                    _telemetryGreen,
                    Icons.timelapse,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Forecast Line Charts
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(color: _telemetryCyan, strokeWidth: 2),
                ),
              )
            else ...[
              // Chart 1: Battery SoC Forecast
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(width: 3, height: 14, color: _telemetryCyan),
                            const SizedBox(width: 8),
                            const Text(
                              'BATTERY STATE OF CHARGE (%) • 3-HOUR PREDICTIVE HORIZON',
                              style: TextStyle(
                                color: _textHeader,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _legendItem(_telemetryCyan, 'Predicted SoC'),
                            const SizedBox(width: 16),
                            _legendItem(_telemetryRed, '20% Cutoff Reserve', isDashed: true),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 190,
                      child: _buildSocChart(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Chart 2: Temperature Forecast
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(width: 3, height: 14, color: _telemetryAmber),
                            const SizedBox(width: 8),
                            const Text(
                              'CORE THERMAL PROFILE (°C) • 3-HOUR PREDICTIVE HORIZON',
                              style: TextStyle(
                                color: _textHeader,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _legendItem(_telemetryAmber, 'Predicted Temp (°C)'),
                            const SizedBox(width: 16),
                            _legendItem(_telemetryRed, '68°C Throttle Threshold', isDashed: true),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 190,
                      child: _buildTempChart(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // ISL Link Schedule
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(width: 3, height: 14, color: _telemetryGreen),
                        const SizedBox(width: 8),
                        const Text(
                          'INTER-SATELLITE LASER (ISL) CROSSLINK SCHEDULE',
                          style: TextStyle(
                            color: _textHeader,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (_forecast?.linkWindows.isEmpty ?? true)
                      const Text(
                        'No direct laser links within current line-of-sight cone.',
                        style: TextStyle(color: _textSub, fontSize: 12),
                      )
                    else
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _forecast!.linkWindows.map((lw) {
                          final peerId = lw.sourceSatelliteId == _selectedSatId
                              ? lw.targetSatelliteId
                              : lw.sourceSatelliteId;
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF131D2E),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFF23354E)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.link, color: _telemetryCyan, size: 16),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      peerId,
                                      style: const TextStyle(
                                        color: _textHeader,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                    Text(
                                      '${lw.distanceKm.toInt()} km • 10 Gbps ISL Optical',
                                      style: const TextStyle(color: _textSub, fontSize: 10),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 14),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: _telemetryGreen.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: _telemetryGreen.withValues(alpha: 0.4)),
                                  ),
                                  child: const Text(
                                    'TRACKING',
                                    style: TextStyle(
                                      color: _telemetryGreen,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSocChart() {
    final socs = _forecast?.batterySoCList ?? [0.85, 0.80, 0.72, 0.58, 0.44, 0.62, 0.78, 0.88];
    final spots = <FlSpot>[];
    for (int i = 0; i < socs.length; i++) {
      spots.add(FlSpot(i.toDouble(), socs[i] * 100.0));
    }

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (v) => const FlLine(color: Color(0xFF1E293B), strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, meta) => Text(
                '+${(v * 22.5).toInt()}m',
                style: const TextStyle(color: _textSub, fontSize: 10, fontFamily: 'monospace'),
              ),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              getTitlesWidget: (v, meta) => Text(
                '${v.toInt()}%',
                style: const TextStyle(color: _textSub, fontSize: 10, fontFamily: 'monospace'),
              ),
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: _telemetryCyan,
            barWidth: 2.5,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: _telemetryCyan.withValues(alpha: 0.12),
            ),
          ),
          LineChartBarData(
            spots: [
              FlSpot(0, 20),
              FlSpot((spots.length - 1).toDouble(), 20),
            ],
            color: _telemetryRed,
            barWidth: 1.5,
            dashArray: [5, 5],
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildTempChart() {
    final temps = _forecast?.temperatureList ?? [34.0, 41.0, 50.0, 58.0, 52.0, 44.0, 36.0];
    final spots = <FlSpot>[];
    for (int i = 0; i < temps.length; i++) {
      spots.add(FlSpot(i.toDouble(), temps[i]));
    }

    return LineChart(
      LineChartData(
        minY: 20,
        maxY: 80,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (v) => const FlLine(color: Color(0xFF1E293B), strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, meta) => Text(
                '+${(v * 25).toInt()}m',
                style: const TextStyle(color: _textSub, fontSize: 10, fontFamily: 'monospace'),
              ),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              getTitlesWidget: (v, meta) => Text(
                '${v.toInt()}°C',
                style: const TextStyle(color: _textSub, fontSize: 10, fontFamily: 'monospace'),
              ),
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: _telemetryAmber,
            barWidth: 2.5,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: _telemetryAmber.withValues(alpha: 0.12),
            ),
          ),
          LineChartBarData(
            spots: [
              FlSpot(0, 68),
              FlSpot((spots.length - 1).toDouble(), 68),
            ],
            color: _telemetryRed,
            barWidth: 1.5,
            dashArray: [5, 5],
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _gaugeCard(String label, String value, String sub, Color accentColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: _textSub,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              Icon(icon, color: accentColor, size: 14),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: _textHeader,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: const TextStyle(color: _textSub, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label, {bool isDashed = false}) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: _textSub, fontSize: 11)),
      ],
    );
  }
}
