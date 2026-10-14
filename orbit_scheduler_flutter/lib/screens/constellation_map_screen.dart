import 'package:flutter/material.dart';
import 'package:orbit_scheduler_client/orbit_scheduler_client.dart';
import '../theme/orbit_theme.dart';
import '../services/orbit_service.dart';
import '../widgets/satellite_hud_dialog.dart';
import '../widgets/constellation_3d_globe.dart';

/// Screen 1: Real 3D Interactive World Globe & Constellation Mesh Orbit View.
/// Supports seamless switching between Real 3D Spherical Globe and 2D Mercator Projection.
class ConstellationMapScreen extends StatefulWidget {
  final Function(String satelliteId)? onSelectForecast;

  const ConstellationMapScreen({super.key, this.onSelectForecast});

  @override
  State<ConstellationMapScreen> createState() => _ConstellationMapScreenState();
}

class _ConstellationMapScreenState extends State<ConstellationMapScreen> {
  bool _is3DView = true; // Default to the Real 3D World Globe
  Satellite? _selectedSat;

  @override
  Widget build(BuildContext context) {
    final service = OrbitService.instance;
    final state = service.latestState;
    final satellites = state?.satellites ?? [];
    final links = state?.activeLinks ?? [];
    final sunAngleDeg = state?.sunAngleDeg ?? 0.0;

    final connectedSatIds = <String>{};
    for (final link in links) {
      if (link.isOpen) {
        connectedSatIds.add(link.sourceSatelliteId);
        connectedSatIds.add(link.targetSatelliteId);
      }
    }
    final connectedCount = satellites.where((s) => s.status != 'OFFLINE' && connectedSatIds.contains(s.satelliteId)).length;
    final unlinkedCount = satellites.length - connectedCount;

    return Container(
      color: const Color(0xFF000000), // Pure OLED black
      child: Column(
        children: [
          // Top Minimalist Metrics & View Switcher Bar (Responsive & Overflow-Safe)
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Left: Metric Chips
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _metricChip(
                              label: 'CONNECTED (ISL)',
                              value: '$connectedCount NODES',
                            ),
                            const SizedBox(width: 10),
                            _metricChip(
                              label: 'UNLINKED NODES',
                              value: '$unlinkedCount NODES',
                            ),
                            const SizedBox(width: 10),
                            _metricChip(
                              label: 'ACTIVE ISL LASER LINKS',
                              value: '${links.length} LINKS',
                            ),
                            const SizedBox(width: 10),
                            _metricChip(
                              label: 'SUNLIGHT / ECLIPSE',
                              value: '${satellites.where((s) => s.inSunlight).length} / ${satellites.where((s) => !s.inSunlight).length}',
                            ),
                            const SizedBox(width: 10),
                            _metricChip(
                              label: 'GROUND TERMINALS',
                              value: '10 STATIONS',
                            ),
                          ],
                        ),
                        const SizedBox(width: 18),

                        // Right: Status Legend & View Switcher
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _legendItem(const Color(0xFF22C55E), 'Connected ($connectedCount)'),
                            const SizedBox(width: 12),
                            _legendItem(const Color(0xFFEF4444), 'Unlinked ($unlinkedCount)'),
                            const SizedBox(width: 12),
                            _legendItem(const Color(0xFF00B0FF), 'Ground Feeder (10 Gbps)'),
                            const SizedBox(width: 16),

                            // 3D Globe vs 2D Mercator Mode Switcher
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: OrbitTheme.cardDark,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: OrbitTheme.cardBorder),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _viewToggleOption(
                                    label: 'REAL 3D GLOBE',
                                    icon: Icons.public,
                                    isSelected: _is3DView,
                                    onTap: () => setState(() => _is3DView = true),
                                  ),
                                  const SizedBox(width: 4),
                                  _viewToggleOption(
                                    label: '2D MERCATOR',
                                    icon: Icons.map_outlined,
                                    isSelected: !_is3DView,
                                    onTap: () => setState(() => _is3DView = false),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Main Constellation Viewport (Real 3D World Globe or 2D Mercator)
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              decoration: BoxDecoration(
                color: const Color(0xFF000000), // OLED black space
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: OrbitTheme.cardBorder, width: 1.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: _is3DView
                  ? Constellation3DGlobe(
                      satellites: satellites,
                      links: links,
                      sunAngleDeg: sunAngleDeg,
                      onSelectSatellite: (satId) {
                        final sat = satellites.firstWhere((s) => s.satelliteId == satId);
                        setState(() => _selectedSat = sat);
                        widget.onSelectForecast?.call(satId);
                      },
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        return GestureDetector(
                          onTapDown: (details) {
                            final sat = _hitTestSatellite(details.localPosition, constraints.biggest, satellites);
                            if (sat != null) {
                              setState(() => _selectedSat = sat);
                              showDialog(
                                context: context,
                                builder: (_) => SatelliteHudDialog(
                                  satellite: sat,
                                  onOpenForecast: () => widget.onSelectForecast?.call(sat.satelliteId),
                                ),
                              );
                            }
                          },
                          child: CustomPaint(
                            size: Size(constraints.maxWidth, constraints.maxHeight),
                            painter: Monochrome2DConstellationPainter(
                              satellites: satellites,
                              links: links,
                              sunAngleDeg: sunAngleDeg,
                              selectedSatId: _selectedSat?.satelliteId,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _viewToggleOption({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? OrbitTheme.white : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isSelected ? const Color(0xFF000000) : OrbitTheme.textSecondary,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF000000) : OrbitTheme.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Satellite? _hitTestSatellite(Offset localPos, Size size, List<Satellite> satellites) {
    const hitRadius = 14.0;
    for (final sat in satellites) {
      final x = ((sat.longitude + 180.0) / 360.0) * size.width;
      final y = ((90.0 - sat.latitude) / 180.0) * size.height;
      final dist = (Offset(x, y) - localPos).distance;
      if (dist <= hitRadius) {
        return sat;
      }
    }
    return null;
  }

  Widget _metricChip({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: OrbitTheme.cardDark,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: OrbitTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: OrbitTheme.textMuted, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(color: OrbitTheme.white, fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.6),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: OrbitTheme.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// 2D Mercator Projection Fallback with high-contrast continents and orbital tracks.
class Monochrome2DConstellationPainter extends CustomPainter {
  final List<Satellite> satellites;
  final List<LinkWindow> links;
  final double sunAngleDeg;
  final String? selectedSatId;

  Monochrome2DConstellationPainter({
    required this.satellites,
    required this.links,
    required this.sunAngleDeg,
    this.selectedSatId,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Grid
    _drawCoordinateGrid(canvas, w, h);

    // 2. High-fidelity continents
    _drawContinents(canvas, w, h);

    // 3. Day/Night Terminator
    _drawDayNightTerminator(canvas, w, h);

    // 4. Ground Stations
    _drawGroundStations(canvas, w, h);

    // 5. Laser Links
    _drawLaserLinks(canvas, w, h);

    // 6. Satellites
    _drawSatellites(canvas, w, h);
  }

  void _drawCoordinateGrid(Canvas canvas, double w, double h) {
    final gridPaint = Paint()
      ..color = const Color(0xFF141416)
      ..strokeWidth = 1.0;

    for (int lat = -60; lat <= 60; lat += 30) {
      final y = ((90.0 - lat) / 180.0) * h;
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
    }

    for (int lon = -120; lon <= 120; lon += 60) {
      final x = ((lon + 180.0) / 360.0) * w;
      canvas.drawLine(Offset(x, 0), Offset(x, h), gridPaint);
    }
  }

  void _drawContinents(Canvas canvas, double w, double h) {
    final landPaint = Paint()
      ..color = const Color(0xFF121215)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = const Color(0xFF2C2C32)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (final poly in EarthContinentsData.continents) {
      final path = Path();
      for (int i = 0; i < poly.length; i++) {
        final lat = poly[i][0];
        final lon = poly[i][1];
        final x = ((lon + 180.0) / 360.0) * w;
        final y = ((90.0 - lat) / 180.0) * h;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, landPaint);
      canvas.drawPath(path, borderPaint);
    }
  }

  void _drawDayNightTerminator(Canvas canvas, double w, double h) {
    final subSolarLon = (sunAngleDeg % 360.0) - 180.0;
    final antiSolarLon = ((subSolarLon + 360.0) % 360.0) - 180.0;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.55)
      ..style = PaintingStyle.fill;

    final shadowCenter = ((antiSolarLon + 180.0) / 360.0) * w;
    final shadowWidth = w * 0.5;

    final left = (shadowCenter - shadowWidth / 2);
    final right = (shadowCenter + shadowWidth / 2);

    if (left < 0) {
      canvas.drawRect(Rect.fromLTRB(0, 0, right, h), shadowPaint);
      canvas.drawRect(Rect.fromLTRB(w + left, 0, w, h), shadowPaint);
    } else if (right > w) {
      canvas.drawRect(Rect.fromLTRB(left, 0, w, h), shadowPaint);
      canvas.drawRect(Rect.fromLTRB(0, 0, right - w, h), shadowPaint);
    } else {
      canvas.drawRect(Rect.fromLTRB(left, 0, right, h), shadowPaint);
    }
  }

  void _drawGroundStations(Canvas canvas, double w, double h) {
    final stationPaint = Paint()..style = PaintingStyle.fill;
    final reachPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final blueFeederPaint = Paint()
      ..color = const Color(0xFF00B0FF).withValues(alpha: 0.90) // Electric blue feeder
      ..strokeWidth = 1.8;

    for (final gs in EarthContinentsData.groundStations) {
      final lat = gs['lat'] as double;
      final lon = gs['lon'] as double;
      final id = gs['id'] as String;

      final x = ((lon + 180.0) / 360.0) * w;
      final y = ((90.0 - lat) / 180.0) * h;

      // 1800 km reach footprint circle in Electric Blue
      reachPaint.color = const Color(0xFF00B0FF).withValues(alpha: 0.25);
      canvas.drawCircle(Offset(x, y), 24.0, reachPaint);

      // Station node
      stationPaint.color = const Color(0xFF00E5FF);
      canvas.drawCircle(Offset(x, y), 3.2, stationPaint);

      // Label in Blue
      final tp = TextPainter(
        text: TextSpan(
          text: id,
          style: const TextStyle(
            color: Color(0xFF38BDF8),
            fontSize: 8,
            fontFamily: 'monospace',
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x + 5, y - 4));

      // Draw Blue feeder connection line to any satellite within reach footprint
      for (final sat in satellites) {
        final satX = ((sat.longitude + 180.0) / 360.0) * w;
        final satY = ((90.0 - sat.latitude) / 180.0) * h;
        final dist = (Offset(x, y) - Offset(satX, satY)).distance;
        if (dist <= 26.0) {
          canvas.drawLine(Offset(x, y), Offset(satX, satY), blueFeederPaint);
          break;
        }
      }
    }
  }

  void _drawLaserLinks(Canvas canvas, double w, double h) {
    final linkPaint = Paint()
      ..color = const Color(0xFF22C55E).withValues(alpha: 0.85) // Green Laser Links
      ..strokeWidth = 1.2;

    final satMap = {for (final s in satellites) s.satelliteId: s};

    for (final link in links) {
      if (!link.isOpen) continue;
      final s1 = satMap[link.sourceSatelliteId];
      final s2 = satMap[link.targetSatelliteId];
      if (s1 == null || s2 == null) continue;

      final x1 = ((s1.longitude + 180.0) / 360.0) * w;
      final y1 = ((90.0 - s1.latitude) / 180.0) * h;
      final x2 = ((s2.longitude + 180.0) / 360.0) * w;
      final y2 = ((90.0 - s2.latitude) / 180.0) * h;

      // Avoid drawing across the antimeridian jump
      if ((x1 - x2).abs() < w * 0.4) {
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), linkPaint);
      }
    }
  }

  void _drawSatellites(Canvas canvas, double w, double h) {
    final satPaint = Paint();

    // Identify connected satellites (via active ISL link)
    final connectedSatIds = <String>{};
    for (final link in links) {
      if (link.isOpen) {
        connectedSatIds.add(link.sourceSatelliteId);
        connectedSatIds.add(link.targetSatelliteId);
      }
    }

    for (final sat in satellites) {
      final x = ((sat.longitude + 180.0) / 360.0) * w;
      final y = ((90.0 - sat.latitude) / 180.0) * h;

      final isConnected = sat.status != 'OFFLINE' && connectedSatIds.contains(sat.satelliteId);
      final isSelected = sat.satelliteId == selectedSatId;

      // Green for Connected, Red for Non-Connected
      final satColor = isConnected
          ? const Color(0xFF22C55E) // Green connected
          : const Color(0xFFEF4444); // Red non-connected

      // Unlinked satellite alert beacon ring
      if (!isConnected) {
        final alertRing = Paint()
          ..color = const Color(0xFFEF4444).withValues(alpha: 0.45)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6;
        canvas.drawCircle(Offset(x, y), 9.5, alertRing);
      }

      // Status aura
      satPaint.color = satColor.withValues(alpha: isConnected ? 0.25 : 0.45);
      canvas.drawCircle(Offset(x, y), isSelected ? 8.0 : (isConnected ? 6.0 : 7.5), satPaint);

      // Satellite core
      satPaint.color = satColor;
      canvas.drawCircle(Offset(x, y), isSelected ? 5.0 : (isConnected ? 3.5 : 4.5), satPaint);

      // Mini solar panels
      final panelPaint = Paint()
        ..color = isConnected ? const Color(0xFF86EFAC) : const Color(0xFFFCA5A5)
        ..style = PaintingStyle.fill;
      canvas.drawRect(Rect.fromCenter(center: Offset(x - 5.0, y), width: 3.8, height: 1.8), panelPaint);
      canvas.drawRect(Rect.fromCenter(center: Offset(x + 5.0, y), width: 3.8, height: 1.8), panelPaint);

      // Distinct unlinked telemetry label in 2D
      if (!isConnected) {
        final tp = TextPainter(
          text: TextSpan(
            text: '${sat.satelliteId.replaceAll("SAT-", "S")} [UNLINKED]',
            style: const TextStyle(
              color: Color(0xFFEF4444),
              fontSize: 8.5,
              fontWeight: FontWeight.w800,
              fontFamily: 'monospace',
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(x + 8, y - 5));
      }
    }
  }

  @override
  bool shouldRepaint(covariant Monochrome2DConstellationPainter oldDelegate) {
    return oldDelegate.satellites != satellites ||
        oldDelegate.links != links ||
        oldDelegate.sunAngleDeg != sunAngleDeg ||
        oldDelegate.selectedSatId != selectedSatId;
  }
}
