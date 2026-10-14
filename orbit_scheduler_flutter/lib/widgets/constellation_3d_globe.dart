import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:orbit_scheduler_client/orbit_scheduler_client.dart';
import '../theme/orbit_theme.dart';
import 'satellite_hud_dialog.dart';

/// 3D Vector utility for spherical globe projection.
class Vector3D {
  final double x;
  final double y;
  final double z;

  const Vector3D(this.x, this.y, this.z);

  double get length => math.sqrt(x * x + y * y + z * z);

  Vector3D normalized() {
    final l = length;
    if (l == 0) return const Vector3D(0, 0, 1);
    return Vector3D(x / l, y / l, z / l);
  }

  double dot(Vector3D other) => x * other.x + y * other.y + z * other.z;

  Vector3D operator *(double scalar) => Vector3D(x * scalar, y * scalar, z * scalar);
  Vector3D operator +(Vector3D other) => Vector3D(x + other.x, y + other.y, z + other.z);
  Vector3D operator -(Vector3D other) => Vector3D(x - other.x, y - other.y, z - other.z);
}

/// Comprehensive high-fidelity coastline dataset of Earth continents and major islands.
class EarthContinentsData {
  static const List<List<List<double>>> continents = [
    // North America (Alaska, Canada, US West Coast, Baja, Mexico, Central America, Gulf, US East Coast, Canadian Arctic)
    [
      [71.3, -156.5], [70.5, -161.8], [65.6, -168.1], [60.1, -165.2], [55.1, -162.8],
      [58.6, -157.0], [59.9, -149.8], [61.2, -146.4], [59.5, -139.7], [55.3, -131.6],
      [54.3, -130.3], [50.8, -127.9], [49.2, -123.1], [48.4, -124.7], [43.3, -124.4],
      [38.0, -123.0], [34.0, -119.0], [32.5, -117.1], [31.5, -116.6], [28.0, -114.2],
      [24.5, -111.7], [22.9, -109.9], [24.1, -110.3], [27.5, -112.5], [31.3, -114.8],
      [31.9, -113.1], [29.0, -112.1], [24.1, -107.3], [19.2, -104.7], [16.3, -98.1],
      [14.6, -92.2], [10.0, -85.8], [8.4, -82.9], [7.7, -81.2], [8.9, -79.5],
      [9.5, -78.8], [9.3, -82.5], [10.9, -83.7], [15.2, -83.4], [15.9, -85.0],
      [15.8, -87.8], [18.5, -88.3], [21.5, -87.1], [21.3, -89.6], [19.8, -90.5],
      [18.7, -91.5], [18.2, -94.5], [22.2, -97.8], [25.9, -97.1], [29.7, -93.9],
      [29.3, -89.4], [30.4, -86.5], [29.8, -84.0], [27.8, -82.6], [25.1, -80.4],
      [25.8, -80.1], [28.4, -80.6], [32.0, -80.8], [34.7, -76.8], [36.9, -76.0],
      [38.9, -74.9], [40.5, -73.9], [41.3, -71.9], [42.4, -70.9], [44.4, -68.0],
      [45.1, -67.0], [43.6, -65.9], [45.8, -64.2], [47.0, -64.8], [48.0, -69.7],
      [50.2, -63.6], [51.4, -57.1], [47.5, -53.5], [51.6, -55.5], [53.5, -55.9],
      [58.8, -62.6], [60.5, -64.8], [58.3, -68.4], [62.2, -75.0], [62.5, -77.8],
      [58.6, -78.5], [55.0, -82.3], [51.3, -80.5], [54.0, -89.0], [58.8, -94.1],
      [63.3, -90.7], [68.8, -89.8], [69.5, -82.5], [72.3, -80.2], [73.8, -85.0],
      [71.5, -95.5], [69.0, -114.5], [69.8, -129.5], [69.6, -141.0], [71.3, -156.5]
    ],
    // South America (Colombia, Andes, Chile, Patagonia, Argentina, Brazil Bulge, Amazon, Guianas, Venezuela)
    [
      [12.4, -71.7], [11.0, -74.8], [8.9, -76.9], [7.2, -77.9], [2.0, -78.7],
      [-1.3, -80.6], [-4.7, -81.3], [-9.3, -78.6], [-14.3, -76.0], [-18.5, -70.3],
      [-23.6, -70.4], [-30.0, -71.4], [-37.0, -73.5], [-43.6, -74.8], [-48.0, -75.4],
      [-53.5, -73.9], [-55.0, -67.2], [-54.8, -65.0], [-52.0, -68.4], [-46.0, -65.5],
      [-41.0, -62.8], [-38.0, -57.5], [-35.0, -56.0], [-34.4, -53.5], [-31.0, -51.0],
      [-26.0, -48.6], [-23.0, -43.2], [-18.0, -39.5], [-13.0, -38.5], [-8.5, -34.8],
      [-5.1, -35.3], [-2.5, -44.3], [-0.5, -50.0], [4.5, -51.6], [5.8, -55.2],
      [7.5, -58.7], [8.6, -60.5], [10.6, -61.8], [10.7, -67.0], [11.5, -71.6], [12.4, -71.7]
    ],
    // Eurasia (Scandinavia, Baltic, Western Europe, Iberia, Mediterranean, Black Sea, Siberia, Pacific Coast, China, Indochina, India, Arabia)
    [
      [71.2, 25.8], [69.6, 18.0], [62.4, 5.0], [58.0, 7.0], [59.0, 10.5],
      [56.0, 12.5], [55.5, 14.5], [63.0, 21.5], [65.5, 24.5], [60.0, 27.0],
      [54.5, 19.5], [54.0, 10.5], [53.5, 7.0], [51.0, 2.5], [48.5, -4.7],
      [46.0, -1.2], [43.5, -1.8], [43.7, -7.9], [42.1, -8.9], [37.0, -9.0],
      [36.0, -5.6], [36.7, -2.2], [41.0, 1.0], [43.0, 3.1], [43.5, 7.0],
      [44.0, 9.8], [41.0, 14.2], [38.0, 15.6], [39.0, 17.0], [40.5, 18.0],
      [45.5, 12.3], [45.5, 14.0], [42.5, 18.5], [39.5, 20.0], [36.5, 22.5],
      [38.0, 24.0], [40.5, 23.0], [41.0, 28.5], [44.0, 28.7], [46.5, 31.0],
      [45.2, 36.5], [43.5, 39.8], [41.5, 41.6], [42.0, 35.0], [41.0, 29.0],
      // Middle East & Arabia
      [36.5, 36.0], [33.5, 35.0], [31.5, 34.5], [28.0, 34.5], [22.0, 39.0],
      [15.5, 41.8], [12.7, 43.5], [12.8, 45.0], [14.5, 49.0], [17.0, 54.0],
      [22.5, 59.8], [25.5, 56.5], [24.0, 52.5], [27.0, 49.5], [30.0, 48.0],
      [27.0, 52.0], [25.3, 57.0], [25.2, 62.0],
      // India & South Asia
      [24.8, 67.0], [23.0, 70.0], [20.0, 72.8], [15.0, 73.8], [10.0, 76.0],
      [8.1, 77.5], [10.5, 79.8], [13.0, 80.3], [17.0, 82.3], [21.5, 87.0],
      [22.0, 91.5], [20.0, 92.8], [16.0, 94.2], [16.0, 97.5], [12.0, 98.6],
      [8.0, 98.3], [1.3, 103.8], [4.5, 103.5], [8.0, 102.0], [13.5, 100.5],
      [10.5, 105.0], [11.0, 107.5], [16.0, 108.2], [21.0, 108.0], [21.5, 109.5],
      // China & East Asia
      [22.5, 114.0], [24.5, 118.5], [28.0, 121.5], [31.5, 121.8], [34.5, 119.8],
      [37.5, 122.5], [39.0, 118.0], [39.0, 122.0], [38.0, 125.0], [34.5, 126.5],
      [35.0, 129.0], [38.0, 128.5], [40.0, 128.0], [42.5, 131.0], [47.5, 139.0],
      [53.5, 141.5], [59.0, 143.5], [59.5, 150.5], [62.5, 161.0], [56.0, 163.0],
      [51.0, 157.0], [57.5, 157.0], [60.0, 166.0], [65.5, 172.0], [66.0, -169.8],
      // Arctic Siberia & Russia
      [69.0, 179.0], [70.0, 160.0], [73.0, 140.0], [76.0, 112.0], [77.5, 105.0],
      [73.5, 80.0], [68.5, 74.0], [69.5, 60.0], [69.0, 40.0], [70.0, 32.0], [71.2, 25.8]
    ],
    // Africa (Mediterranean, Egypt, Red Sea, Horn, East Africa, South Africa, West Africa, Atlantic Coast)
    [
      [36.8, -5.4], [37.3, 10.0], [34.0, 11.5], [32.0, 13.5], [32.5, 20.0],
      [31.5, 26.0], [31.2, 32.3], [27.5, 33.5], [22.0, 36.8], [15.5, 39.5],
      [12.0, 43.5], [11.8, 51.3], [9.5, 50.8], [2.0, 45.3], [-4.0, 39.5],
      [-10.5, 40.5], [-16.0, 39.8], [-25.0, 33.0], [-28.0, 32.5], [-34.0, 25.5],
      [-34.8, 20.0], [-34.0, 18.5], [-29.0, 16.8], [-22.5, 14.4], [-16.0, 11.8],
      [-9.0, 13.0], [-5.0, 12.0], [4.5, 6.0], [5.5, 0.0], [5.0, -5.0],
      [4.5, -7.5], [6.5, -11.0], [9.5, -13.5], [12.0, -16.0], [15.0, -17.0],
      [21.0, -17.5], [28.0, -12.5], [33.0, -8.5], [36.0, -5.5], [36.8, -5.4]
    ],
    // Australia & Tasmania
    [
      [-11.5, 142.5], [-15.0, 145.3], [-20.0, 148.5], [-24.5, 153.0], [-28.5, 153.6],
      [-34.0, 151.2], [-37.5, 150.0], [-38.8, 146.5], [-38.0, 141.0], [-35.5, 138.5],
      [-32.0, 132.5], [-34.0, 123.0], [-35.0, 117.0], [-31.5, 115.5], [-26.0, 113.0],
      [-21.8, 114.2], [-20.0, 119.0], [-16.5, 123.0], [-14.0, 126.0], [-12.5, 131.0],
      [-12.0, 136.5], [-15.0, 136.0], [-17.5, 139.5], [-16.0, 141.5], [-11.5, 142.5]
    ],
    // Greenland
    [
      [83.6, -30.0], [81.5, -12.0], [76.0, -18.0], [70.0, -22.0], [65.0, -38.0],
      [59.8, -44.0], [64.0, -52.0], [70.0, -54.0], [76.0, -68.0], [78.5, -73.0],
      [82.0, -60.0], [83.6, -30.0]
    ],
    // Antarctica (Ice Perimeter)
    [
      [-63.5, -57.0], [-66.0, -63.0], [-71.0, -74.0], [-74.0, -100.0], [-75.0, -135.0],
      [-80.0, -165.0], [-77.0, 170.0], [-70.0, 165.0], [-66.0, 140.0], [-66.0, 110.0],
      [-67.0, 80.0], [-69.0, 40.0], [-70.0, 10.0], [-72.0, -15.0], [-75.0, -45.0],
      [-63.5, -57.0]
    ],
    // Great Britain & Ireland
    [
      [58.6, -3.1], [55.0, -1.5], [51.5, 1.4], [50.0, -5.2], [52.0, -5.0],
      [55.0, -5.8], [58.6, -3.1]
    ],
    // Japan Main Arc
    [
      [45.4, 141.8], [43.5, 145.5], [42.0, 141.0], [38.5, 141.5], [35.5, 140.5],
      [33.5, 135.5], [31.5, 131.0], [33.5, 130.0], [36.0, 136.0], [40.5, 140.0], [45.4, 141.8]
    ],
    // Madagascar
    [
      [-12.0, 49.3], [-15.5, 50.4], [-25.0, 47.0], [-25.5, 45.0], [-16.0, 44.0], [-12.0, 49.3]
    ],
  ];

  /// Major metropolitan city centers that glow with night-lights when in Earth shadow.
  static const List<List<dynamic>> nightCities = [
    ['Tokyo', 35.68, 139.76, 1.0],
    ['New York', 40.71, -74.01, 1.0],
    ['London', 51.51, -0.13, 0.9],
    ['Paris', 48.86, 2.35, 0.9],
    ['Shanghai', 31.23, 121.47, 1.0],
    ['Beijing', 39.90, 116.40, 0.9],
    ['Singapore', 1.35, 103.82, 0.8],
    ['Los Angeles', 34.05, -118.24, 0.9],
    ['Chicago', 41.88, -87.63, 0.8],
    ['San Francisco', 37.77, -122.42, 0.8],
    ['Delhi', 28.61, 77.21, 0.9],
    ['Mumbai', 19.08, 72.88, 0.9],
    ['Dubai', 25.20, 55.27, 0.8],
    ['Seoul', 37.57, 126.98, 0.9],
    ['Hong Kong', 22.32, 114.17, 0.9],
    ['Sydney', -33.87, 151.21, 0.8],
    ['Sao Paulo', -23.55, -46.63, 0.8],
    ['Buenos Aires', -34.60, -58.38, 0.7],
    ['Cairo', 30.04, 31.24, 0.8],
    ['Johannesburg', -26.20, 28.04, 0.7],
    ['Frankfurt', 50.11, 8.68, 0.8],
    ['Moscow', 55.76, 37.62, 0.8],
  ];

  /// 10 Physical Ground Station locations on Earth.
  static const List<Map<String, dynamic>> groundStations = [
    {'id': 'GS-SVALBARD', 'name': 'Svalbard Arctic Terminal', 'country': 'NOR', 'lat': 78.22, 'lon': 15.65},
    {'id': 'GS-TROMSO', 'name': 'Tromsø High-Latitude', 'country': 'NOR', 'lat': 69.65, 'lon': 18.96},
    {'id': 'GS-FAIRBANKS', 'name': 'Fairbanks Facility', 'country': 'USA', 'lat': 64.84, 'lon': -147.72},
    {'id': 'GS-MADRID', 'name': 'Madrid Deep Terminal', 'country': 'ESP', 'lat': 40.43, 'lon': -4.25},
    {'id': 'GS-GOLDSTONE', 'name': 'Goldstone Complex', 'country': 'USA', 'lat': 35.43, 'lon': -116.89},
    {'id': 'GS-SINGAPORE', 'name': 'Singapore Gateway', 'country': 'SGP', 'lat': 1.35, 'lon': 103.82},
    {'id': 'GS-CANBERRA', 'name': 'Canberra Southern', 'country': 'AUS', 'lat': -35.40, 'lon': 148.98},
    {'id': 'GS-SANTIAGO', 'name': 'Santiago Station', 'country': 'CHL', 'lat': -33.45, 'lon': -70.67},
    {'id': 'GS-HAWAII', 'name': 'Hawaii Pacific Station', 'country': 'USA', 'lat': 19.89, 'lon': -155.58},
    {'id': 'GS-MCMURDO', 'name': 'McMurdo Antarctic Base', 'country': 'AQ', 'lat': -77.85, 'lon': 166.67},
  ];
}

/// Interactive 3D Constellation with Realistic Satellite Orbiting and Physics-Based Coloring.
class Constellation3DGlobe extends StatefulWidget {
  final List<Satellite> satellites;
  final List<LinkWindow> links;
  final double sunAngleDeg;
  final Function(String satelliteId)? onSelectSatellite;

  const Constellation3DGlobe({
    super.key,
    required this.satellites,
    required this.links,
    required this.sunAngleDeg,
    this.onSelectSatellite,
  });

  @override
  State<Constellation3DGlobe> createState() => _Constellation3DGlobeState();
}

class _Constellation3DGlobeState extends State<Constellation3DGlobe> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  final Stopwatch _stopwatch = Stopwatch();

  // Camera angles in radians
  double _camYaw = -0.35; // horizontal orbit
  double _camPitch = 0.38; // camera elevation tilt (~22 degrees)
  double _zoomScale = 1.0; // zoom factor

  bool _autoRotateEarth = true;
  bool _showPlanes = true;
  bool _showLasers = true;
  bool _showTrails = true;
  bool _showStations = true;

  // Realistic speed multiplier: default 1.0 gives calm, realistic orbital motion (~0.45 deg/sec)
  double _speedMultiplier = 1.0;

  Offset? _lastPanPos;
  late final List<Vector3D> _starfield;

  @override
  void initState() {
    super.initState();
    _initStarfield();
    _stopwatch.start();

    // 60 FPS continuous animation loop
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3600),
    )..addListener(() {
        if (mounted) setState(() {});
      });
    _animController.repeat();
  }

  void _initStarfield() {
    final rand = math.Random(1337);
    _starfield = List.generate(260, (_) {
      final u = rand.nextDouble() * 2.0 - 1.0;
      final theta = rand.nextDouble() * 2.0 * math.pi;
      final r = math.sqrt(1.0 - u * u);
      return Vector3D(r * math.cos(theta), u, r * math.sin(theta));
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _stopwatch.stop();
    super.dispose();
  }

  void _resetView() {
    setState(() {
      _camYaw = -0.35;
      _camPitch = 0.38;
      _zoomScale = 1.0;
      _speedMultiplier = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Current continuous time in seconds
    final elapsedSec = _stopwatch.elapsedMilliseconds / 1000.0;

    // Realistic Planetary Rotation (~0.002 rad/s = 0.11 deg/s)
    final earthRotationRad = _autoRotateEarth ? (elapsedSec * 0.002) : 0.0;

    // Realistic Orbital Revolution Speed (~0.008 rad/s = 0.46 deg/s at 1x)
    // Moves gracefully and realistically without high-speed dizzying blur
    final orbitalAdvanceRad = elapsedSec * 0.008 * _speedMultiplier;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final globeRadius = (math.min(size.width, size.height) * 0.36) * _zoomScale;

        return Stack(
          children: [
            // Interactive 3D Canvas
            GestureDetector(
              onScaleStart: (details) {
                _lastPanPos = details.localFocalPoint;
              },
              onScaleUpdate: (details) {
                setState(() {
                  if (_lastPanPos != null) {
                    final dx = details.localFocalPoint.dx - _lastPanPos!.dx;
                    final dy = details.localFocalPoint.dy - _lastPanPos!.dy;

                    _camYaw += dx * 0.007;
                    _camPitch = (_camPitch - dy * 0.007).clamp(-1.3, 1.3);
                  }
                  _lastPanPos = details.localFocalPoint;

                  if (details.scale != 1.0) {
                    _zoomScale = (_zoomScale * (1.0 + (details.scale - 1.0) * 0.05)).clamp(0.65, 2.3);
                  }
                });
              },
              onScaleEnd: (_) => _lastPanPos = null,
              onTapUp: (details) {
                _handleTap(details.localPosition, size, globeRadius, orbitalAdvanceRad);
              },
              child: CustomPaint(
                size: size,
                painter: RealRotating3DGlobePainter(
                  satellites: widget.satellites,
                  links: widget.links,
                  sunAngleDeg: widget.sunAngleDeg,
                  camYaw: _camYaw,
                  camPitch: _camPitch,
                  earthRotationRad: earthRotationRad,
                  orbitalAdvanceRad: orbitalAdvanceRad,
                  globeRadius: globeRadius,
                  starfield: _starfield,
                  showPlanes: _showPlanes,
                  showLasers: _showLasers,
                  showTrails: _showTrails,
                  showStations: _showStations,
                ),
              ),
            ),

            // Top-Right Quick 3D Toggles (Overflow-Protected)
            Positioned(
              top: 16,
              right: 20,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: math.max(120.0, constraints.maxWidth - 40)),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF040405).withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF1E1E22)),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _toggleBtn(
                          icon: Icons.sync,
                          label: 'EARTH ROTATE',
                          active: _autoRotateEarth,
                          onTap: () => setState(() => _autoRotateEarth = !_autoRotateEarth),
                        ),
                        const SizedBox(width: 6),
                        _toggleBtn(
                          icon: Icons.speed,
                          label: _speedMultiplier == 1.0
                              ? 'REAL SPEED (1X)'
                              : '${_speedMultiplier.toInt()}X SPEED',
                          active: _speedMultiplier > 1.0,
                          onTap: () => setState(() {
                            if (_speedMultiplier == 1.0) {
                              _speedMultiplier = 3.0;
                            } else if (_speedMultiplier == 3.0) {
                              _speedMultiplier = 8.0;
                            } else {
                              _speedMultiplier = 1.0;
                            }
                          }),
                        ),
                        const SizedBox(width: 6),
                        _toggleBtn(
                          icon: Icons.timeline,
                          label: 'TRAILS',
                          active: _showTrails,
                          onTap: () => setState(() => _showTrails = !_showTrails),
                        ),
                        const SizedBox(width: 6),
                        _toggleBtn(
                          icon: Icons.alt_route,
                          label: 'PLANES',
                          active: _showPlanes,
                          onTap: () => setState(() => _showPlanes = !_showPlanes),
                        ),
                        const SizedBox(width: 6),
                        _toggleBtn(
                          icon: Icons.grain,
                          label: 'LASERS',
                          active: _showLasers,
                          onTap: () => setState(() => _showLasers = !_showLasers),
                        ),
                        const SizedBox(width: 6),
                        _toggleBtn(
                          icon: Icons.cell_tower,
                          label: 'GROUND',
                          active: _showStations,
                          onTap: () => setState(() => _showStations = !_showStations),
                        ),
                        const SizedBox(width: 8),
                        Container(width: 1, height: 20, color: const Color(0xFF1E1E22)),
                        const SizedBox(width: 8),
                        _iconBtn(Icons.zoom_in, () => setState(() => _zoomScale = (_zoomScale + 0.15).clamp(0.65, 2.3))),
                        const SizedBox(width: 4),
                        _iconBtn(Icons.zoom_out, () => setState(() => _zoomScale = (_zoomScale - 0.15).clamp(0.65, 2.3))),
                        const SizedBox(width: 4),
                        _iconBtn(Icons.center_focus_strong, _resetView),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom-Left Telemetry HUD (Overflow-Protected)
            Positioned(
              left: 20,
              bottom: 20,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: math.max(120.0, constraints.maxWidth - 40)),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF040405).withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF1E1E22)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'ORBITAL DYNAMICS • REAL-TIME WALKER DELTA',
                        style: TextStyle(color: OrbitTheme.textMuted, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.0),
                      ),
                      const SizedBox(height: 6),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _hudStat('MOTION', _speedMultiplier == 1.0 ? 'REALISTIC 1:1' : '${_speedMultiplier.toInt()}X ACCELERATED'),
                            const SizedBox(width: 14),
                            _hudStat('ORBIT VELOCITY', '27,612 km/h'),
                            const SizedBox(width: 14),
                            _hudStat('INCLINATION', '53.0°'),
                            const SizedBox(width: 14),
                            _hudStat('ORBIT PERIOD', '92.4 min'),
                            const SizedBox(width: 14),
                            _hudStat('LINK STATUS', '${widget.links.where((l) => l.isOpen).length} ACTIVE'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _toggleBtn({required IconData icon, required String label, required bool active, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: active ? OrbitTheme.white.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: active ? OrbitTheme.white : const Color(0xFF1E1E22)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: active ? OrbitTheme.white : OrbitTheme.textMuted),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: active ? OrbitTheme.white : OrbitTheme.textMuted,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFF1E1E22)),
        ),
        child: Icon(icon, size: 14, color: OrbitTheme.white),
      ),
    );
  }

  Widget _hudStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: OrbitTheme.textMuted, fontSize: 8, fontWeight: FontWeight.w600)),
        const SizedBox(height: 1),
        Text(value, style: const TextStyle(color: OrbitTheme.white, fontSize: 11, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
      ],
    );
  }

  void _handleTap(Offset tapPos, Size size, double radius, double orbitalAdvanceRad) {
    final center = Offset(size.width / 2, size.height / 2);
    final orbRadius = radius * 1.28;
    const incRad = 53.0 * math.pi / 180.0;

    for (int idx = 0; idx < widget.satellites.length; idx++) {
      final sat = widget.satellites[idx];
      final planeIdx = sat.planeIndex % 6;
      final raanRad = (planeIdx * 60.0) * math.pi / 180.0;
      final baseNu = (sat.trueAnomalyDeg * math.pi / 180.0);
      final nu = (baseNu + orbitalAdvanceRad) % (2 * math.pi);

      final p3d = _computeSatelliteInertial3D(raanRad, incRad, nu, orbRadius);
      final proj = _projectInertialToCamera(p3d);

      final screenX = center.dx + proj.x;
      final screenY = center.dy + proj.y;

      final dist = (Offset(screenX, screenY) - tapPos).distance;
      if (dist <= 20.0) {
        widget.onSelectSatellite?.call(sat.satelliteId);
        showDialog(
          context: context,
          builder: (_) => SatelliteHudDialog(satellite: sat),
        );
        return;
      }
    }
  }

  Vector3D _computeSatelliteInertial3D(double raan, double inc, double nu, double r) {
    final x1 = r * math.cos(nu);
    final y1 = r * math.sin(nu) * math.cos(inc);
    final z1 = r * math.sin(nu) * math.sin(inc);

    final xInertial = x1 * math.cos(raan) - y1 * math.sin(raan);
    final yInertial = x1 * math.sin(raan) + y1 * math.cos(raan);
    final zInertial = z1;
    return Vector3D(xInertial, yInertial, zInertial);
  }

  Vector3D _projectInertialToCamera(Vector3D pt) {
    final xPrime = pt.x * math.cos(_camYaw) - pt.y * math.sin(_camYaw);
    final yPrime = pt.x * math.sin(_camYaw) + pt.y * math.cos(_camYaw);
    final zPrime = pt.z;

    final xScreen = xPrime;
    final yScreen = -(zPrime * math.cos(_camPitch) - yPrime * math.sin(_camPitch));
    final zDepth = zPrime * math.sin(_camPitch) + yPrime * math.cos(_camPitch);
    return Vector3D(xScreen, yScreen, zDepth);
  }
}

/// CustomPainter rendering 3D Rotating Earth with realistic satellite movement,
/// Blue feeder lines to ground, Green connected satellites & laser links, and Red non-connected satellites.
class RealRotating3DGlobePainter extends CustomPainter {
  final List<Satellite> satellites;
  final List<LinkWindow> links;
  final double sunAngleDeg;
  final double camYaw;
  final double camPitch;
  final double earthRotationRad;
  final double orbitalAdvanceRad;
  final double globeRadius;
  final List<Vector3D> starfield;
  final bool showPlanes;
  final bool showLasers;
  final bool showTrails;
  final bool showStations;

  RealRotating3DGlobePainter({
    required this.satellites,
    required this.links,
    required this.sunAngleDeg,
    required this.camYaw,
    required this.camPitch,
    required this.earthRotationRad,
    required this.orbitalAdvanceRad,
    required this.globeRadius,
    required this.starfield,
    required this.showPlanes,
    required this.showLasers,
    required this.showTrails,
    required this.showStations,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final R = globeRadius;
    final orbR = R * 1.28; // Orbital shell altitude

    // 1. Deepest Pitch Black Cosmic Background & Twinkling Starfield
    _drawDeepSpaceStarfield(canvas, size, center);

    // Compute 3D Camera Sun Direction Vector
    final sunRad = sunAngleDeg * math.pi / 180.0;
    final sunInertial = Vector3D(math.cos(sunRad), math.sin(sunRad), 0.0);
    final sunCam = _projectInertialToCamera(sunInertial).normalized();

    // 2. Solar Direction Flare & Indicator
    _drawSunMarker(canvas, center, sunCam, size);

    // Determine set of connected satellites (via active ISL laser crosslinks)
    final connectedSatIds = _determineConnectedSatelliteIds();

    // 3. Back-side Orbital Rings & Back-side Satellite Revolution Trails (drawn behind Earth)
    if (showPlanes) {
      _drawOrbitalPlanes(canvas, center, orbR, drawFront: false);
    }
    _drawSatellitesAndTrails(canvas, center, orbR, connectedSatIds, drawFront: false);

    if (showLasers) {
      _drawLaserLinks(canvas, center, orbR, drawFront: false);
    }

    // 4. Atmospheric Outer Limb Halo (Fresnel Glow)
    _drawAtmosphereGlow(canvas, center, R);

    // 5. Solid 3D Rotating Ocean Body with Day/Night Terminator
    _drawOceanSphere(canvas, center, R, sunCam);

    // 6. 3D Rotating Graticule Lines (Equator, Tropics, Meridians)
    _drawRotatingGraticule(canvas, center, R);

    // 7. Rotating High-Fidelity Continents & Coastlines (locked to Earth's rotation)
    _drawRotatingContinents(canvas, center, R, sunCam);

    // 8. Rotating City Night Lights on the shadow side of Earth
    _drawRotatingCityLights(canvas, center, R, sunCam);

    // 9. Rotating Ground Stations & 1800 km Coverage Footprints
    if (showStations) {
      _drawRotatingGroundStations(canvas, center, R);
    }

    // 10. Front-side Orbital Rings
    if (showPlanes) {
      _drawOrbitalPlanes(canvas, center, orbR, drawFront: true);
    }

    // 11. Front-side Laser Mesh Links in Vibrant GREEN
    if (showLasers) {
      _drawLaserLinks(canvas, center, orbR, drawFront: true);
    }

    // 12. Front-side Satellites Revolving: Green if Connected, Red if Non-Connected
    _drawSatellitesAndTrails(canvas, center, orbR, connectedSatIds, drawFront: true);

    // 13. Dynamic Feeder Links to Ground in Vibrant ELECTRIC BLUE
    _drawContactBeams(canvas, center, R, orbR);
  }

  Set<String> _determineConnectedSatelliteIds() {
    final set = <String>{};
    for (final link in links) {
      if (link.isOpen) {
        set.add(link.sourceSatelliteId);
        set.add(link.targetSatelliteId);
      }
    }
    return set;
  }

  void _drawDeepSpaceStarfield(Canvas canvas, Size size, Offset center) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFF000000),
    );

    final starPaint = Paint();
    final celestialR = math.max(size.width, size.height) * 0.95;

    for (int i = 0; i < starfield.length; i++) {
      final s = starfield[i];
      final xCam = s.x * math.cos(camYaw * 0.4) - s.y * math.sin(camYaw * 0.4);
      final yCam = -(s.z * math.cos(camPitch * 0.4) - s.y * math.sin(camPitch * 0.4));

      final sx = center.dx + xCam * celestialR;
      final sy = center.dy + yCam * celestialR;

      if (sx >= 0 && sx <= size.width && sy >= 0 && sy <= size.height) {
        final brightness = (0.25 + ((i % 5) * 0.17)).clamp(0.1, 0.95);
        starPaint.color = Colors.white.withValues(alpha: brightness);
        final radius = (i % 8 == 0) ? 1.5 : 0.85;
        canvas.drawCircle(Offset(sx, sy), radius, starPaint);
      }
    }
  }

  void _drawSunMarker(Canvas canvas, Offset center, Vector3D sunCam, Size size) {
    final dist = math.min(size.width, size.height) * 0.45;
    final sunCenter = Offset(center.dx + sunCam.x * dist, center.dy + sunCam.y * dist);

    final flarePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: 0.35),
          Colors.white.withValues(alpha: 0.08),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: sunCenter, radius: 40));

    canvas.drawCircle(sunCenter, 40, flarePaint);
    canvas.drawCircle(sunCenter, 4.5, Paint()..color = Colors.white);

    const textSpan = TextSpan(
      text: 'SOLAR VECTOR',
      style: TextStyle(color: OrbitTheme.textMuted, fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: 1.0),
    );
    final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr)..layout();
    tp.paint(canvas, Offset(sunCenter.dx - tp.width / 2, sunCenter.dy + 7));
  }

  void _drawAtmosphereGlow(Canvas canvas, Offset center, double R) {
    final atmosphereRect = Rect.fromCircle(center: center, radius: R * 1.14);
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFFFFF).withValues(alpha: 0.0),
          const Color(0xFFD4D4D8).withValues(alpha: 0.18),
          const Color(0xFFFFFFFF).withValues(alpha: 0.06),
          Colors.transparent,
        ],
        stops: const [0.84, 0.93, 0.98, 1.0],
      ).createShader(atmosphereRect);

    canvas.drawCircle(center, R * 1.14, glowPaint);
  }

  void _drawOceanSphere(Canvas canvas, Offset center, double R, Vector3D sunCam) {
    final sphereRect = Rect.fromCircle(center: center, radius: R);
    final sunOffset = Offset(center.dx + sunCam.x * R * 0.65, center.dy + sunCam.y * R * 0.65);

    final oceanPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment(
          (sunOffset.dx - center.dx) / R,
          (sunOffset.dy - center.dy) / R,
        ),
        radius: 1.15,
        colors: const [
          Color(0xFF141418), // illuminated day ocean (sleek dark graphite)
          Color(0xFF09090C), // mid-tone twilight ocean
          Color(0xFF020203), // deep night ocean
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(sphereRect);

    canvas.drawCircle(center, R, oceanPaint);

    final rimPaint = Paint()
      ..color = const Color(0xFF28282E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, R, rimPaint);
  }

  void _drawRotatingGraticule(Canvas canvas, Offset center, double R) {
    final gridPaint = Paint()
      ..color = const Color(0xFF1B1B20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    for (int lat = -60; lat <= 60; lat += 30) {
      final path = Path();
      bool first = true;

      for (int lon = -180; lon <= 180; lon += 5) {
        final pCam = _projectEarthGeoToCamera(lat.toDouble(), lon.toDouble(), R);
        if (pCam.z > 0) {
          final sc = Offset(center.dx + pCam.x, center.dy + pCam.y);
          if (first) {
            path.moveTo(sc.dx, sc.dy);
            first = false;
          } else {
            path.lineTo(sc.dx, sc.dy);
          }
        } else {
          first = true;
        }
      }
      canvas.drawPath(path, gridPaint);
    }

    for (int lon = -180; lon < 180; lon += 30) {
      final path = Path();
      bool first = true;

      for (int lat = -80; lat <= 80; lat += 5) {
        final pCam = _projectEarthGeoToCamera(lat.toDouble(), lon.toDouble(), R);
        if (pCam.z > 0) {
          final sc = Offset(center.dx + pCam.x, center.dy + pCam.y);
          if (first) {
            path.moveTo(sc.dx, sc.dy);
            first = false;
          } else {
            path.lineTo(sc.dx, sc.dy);
          }
        } else {
          first = true;
        }
      }
      canvas.drawPath(path, gridPaint);
    }
  }

  void _drawRotatingContinents(Canvas canvas, Offset center, double R, Vector3D sunCam) {
    final landFillPaint = Paint()..style = PaintingStyle.fill;
    final coastPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    for (final polygon in EarthContinentsData.continents) {
      final visiblePoints = <Offset>[];
      final rawCam = <Vector3D>[];

      for (final pt in polygon) {
        final lat = pt[0];
        final lon = pt[1];
        final pCam = _projectEarthGeoToCamera(lat, lon, R);
        rawCam.add(pCam);
        if (pCam.z > 0) {
          visiblePoints.add(Offset(center.dx + pCam.x, center.dy + pCam.y));
        }
      }

      if (visiblePoints.length >= 3) {
        final path = Path();
        path.moveTo(visiblePoints.first.dx, visiblePoints.first.dy);
        for (int i = 1; i < visiblePoints.length; i++) {
          path.lineTo(visiblePoints[i].dx, visiblePoints[i].dy);
        }
        path.close();

        double avgX = 0, avgY = 0, avgZ = 0;
        for (final p in rawCam) {
          avgX += p.x;
          avgY += p.y;
          avgZ += p.z;
        }
        final normal = Vector3D(avgX, avgY, avgZ).normalized();
        final sunDot = normal.dot(sunCam);

        if (sunDot > 0.05) {
          landFillPaint.color = const Color(0xFF1E1E24);
          coastPaint.color = const Color(0xFF4C4C56);
        } else if (sunDot > -0.15) {
          landFillPaint.color = const Color(0xFF131317);
          coastPaint.color = const Color(0xFF33333A);
        } else {
          landFillPaint.color = const Color(0xFF09090C);
          coastPaint.color = const Color(0xFF1C1C22);
        }

        canvas.drawPath(path, landFillPaint);
        canvas.drawPath(path, coastPaint);
      }
    }
  }

  void _drawRotatingCityLights(Canvas canvas, Offset center, double R, Vector3D sunCam) {
    final lightPaint = Paint();

    for (final item in EarthContinentsData.nightCities) {
      final lat = item[1] as double;
      final lon = item[2] as double;
      final intensity = item[3] as double;

      final pCam = _projectEarthGeoToCamera(lat, lon, R);
      if (pCam.z > 0.1) {
        final normal = Vector3D(pCam.x / R, pCam.y / R, pCam.z / R);
        final sunDot = normal.dot(sunCam);

        if (sunDot < -0.05) {
          final nightAlpha = ((-sunDot) * 1.5).clamp(0.0, 1.0) * intensity;
          final sc = Offset(center.dx + pCam.x, center.dy + pCam.y);

          lightPaint.color = const Color(0xFFFFD54F).withValues(alpha: nightAlpha * 0.7);
          canvas.drawCircle(sc, 1.8, lightPaint);

          lightPaint.color = Colors.white.withValues(alpha: nightAlpha * 0.95);
          canvas.drawCircle(sc, 0.9, lightPaint);
        }
      }
    }
  }

  void _drawRotatingGroundStations(Canvas canvas, Offset center, double R) {
    final basePaint = Paint()..style = PaintingStyle.fill;
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;

    for (final gs in EarthContinentsData.groundStations) {
      final lat = gs['lat'] as double;
      final lon = gs['lon'] as double;
      final country = gs['country'] as String;

      final pCam = _projectEarthGeoToCamera(lat, lon, R);
      if (pCam.z > 0.1) {
        final sc = Offset(center.dx + pCam.x, center.dy + pCam.y);

        // 1800 km coverage footprint circle
        ringPaint.color = const Color(0xFF00B0FF).withValues(alpha: 0.28);
        canvas.drawCircle(sc, 14.0, ringPaint);

        // Ground station pin in Electric Blue
        basePaint.color = const Color(0xFF00E5FF);
        canvas.drawCircle(sc, 2.8, basePaint);

        final textSpan = TextSpan(
          text: '$country: ${gs['id']}',
          style: TextStyle(
            color: const Color(0xFF38BDF8).withValues(alpha: 0.9),
            fontSize: 7.5,
            fontWeight: FontWeight.w700,
            fontFamily: 'monospace',
          ),
        );
        final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr)..layout();
        tp.paint(canvas, Offset(sc.dx + 6, sc.dy - 4));
      }
    }
  }

  void _drawOrbitalPlanes(Canvas canvas, Offset center, double orbR, {required bool drawFront}) {
    final planePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    const incRad = 53.0 * math.pi / 180.0;

    for (int p = 0; p < 6; p++) {
      final raanRad = (p * 60.0) * math.pi / 180.0;
      final path = Path();
      bool first = true;

      for (int uDeg = 0; uDeg <= 360; uDeg += 5) {
        final uRad = uDeg * math.pi / 180.0;
        final pInertial = _computeSatelliteInertial3D(raanRad, incRad, uRad, orbR);
        final pCam = _projectInertialToCamera(pInertial);

        final isFront = pCam.z >= 0;
        if (isFront == drawFront) {
          final sc = Offset(center.dx + pCam.x, center.dy + pCam.y);
          if (first) {
            path.moveTo(sc.dx, sc.dy);
            first = false;
          } else {
            path.lineTo(sc.dx, sc.dy);
          }
        } else {
          first = true;
        }
      }

      planePaint.color = drawFront
          ? Colors.white.withValues(alpha: 0.18)
          : Colors.white.withValues(alpha: 0.04);

      canvas.drawPath(path, planePaint);
    }
  }

  /// Draws satellites revolving: GREEN for connected nodes, RED for non-connected nodes.
  void _drawSatellitesAndTrails(
    Canvas canvas,
    Offset center,
    double orbR,
    Set<String> connectedSatIds, {
    required bool drawFront,
  }) {
    final satPaint = Paint();
    final dropLinePaint = Paint()..strokeWidth = 0.8;
    final trailPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    const incRad = 53.0 * math.pi / 180.0;

    for (int idx = 0; idx < satellites.length; idx++) {
      final sat = satellites[idx];
      final isConnected = sat.status != 'OFFLINE' && connectedSatIds.contains(sat.satelliteId);

      final planeIdx = sat.planeIndex % 6;
      final raanRad = (planeIdx * 60.0) * math.pi / 180.0;
      final baseNu = (sat.trueAnomalyDeg * math.pi / 180.0);

      // Realistic orbital motion along 3D orbital plane
      final nu = (baseNu + orbitalAdvanceRad) % (2 * math.pi);

      final pInertial = _computeSatelliteInertial3D(raanRad, incRad, nu, orbR);
      final pCam = _projectInertialToCamera(pInertial);

      final isFront = pCam.z >= 0;
      if (isFront != drawFront) continue;

      final sc = Offset(center.dx + pCam.x, center.dy + pCam.y);

      // Occlusion test against Earth's opaque body
      final dist2D = Offset(pCam.x, pCam.y).distance;
      final isOccluded = (!isFront && dist2D < globeRadius);

      if (isOccluded) {
        // Draw faint ghost silhouette through transparent planet
        satPaint.color = isConnected
            ? const Color(0xFF22C55E).withValues(alpha: 0.15)
            : const Color(0xFFEF4444).withValues(alpha: 0.25);
        canvas.drawCircle(sc, isConnected ? 1.8 : 2.5, satPaint);
        continue;
      }

      // 1. Orbital Wake Trail (Green for Connected, Bright Red for Unlinked)
      if (showTrails) {
        final trailPath = Path();
        bool firstPt = true;

        for (double dNuDeg = 24.0; dNuDeg >= 0.0; dNuDeg -= 3.0) {
          final tNu = nu - (dNuDeg * math.pi / 180.0);
          final tInertial = _computeSatelliteInertial3D(raanRad, incRad, tNu, orbR);
          final tCam = _projectInertialToCamera(tInertial);
          final tSc = Offset(center.dx + tCam.x, center.dy + tCam.y);

          if (firstPt) {
            trailPath.moveTo(tSc.dx, tSc.dy);
            firstPt = false;
          } else {
            trailPath.lineTo(tSc.dx, tSc.dy);
          }
        }

        final trailColor = isConnected
            ? const Color(0xFF22C55E)
            : const Color(0xFFEF4444);

        trailPaint.color = drawFront
            ? trailColor.withValues(alpha: isConnected ? 0.40 : 0.65)
            : trailColor.withValues(alpha: isConnected ? 0.10 : 0.20);
        canvas.drawPath(trailPath, trailPaint);
      }

      // 2. Altitude Drop Ray to sub-satellite point on Earth
      if (drawFront) {
        final surfInertial = _computeSatelliteInertial3D(raanRad, incRad, nu, globeRadius);
        final surfCam = _projectInertialToCamera(surfInertial);
        final surfSc = Offset(center.dx + surfCam.x, center.dy + surfCam.y);

        dropLinePaint.color = isConnected
            ? const Color(0xFF22C55E).withValues(alpha: 0.25)
            : const Color(0xFFEF4444).withValues(alpha: 0.45);
        canvas.drawLine(sc, surfSc, dropLinePaint);
        canvas.drawCircle(surfSc, 1.4, Paint()..color = isConnected ? const Color(0xFF86EFAC) : const Color(0xFFEF4444));
      }

      // 3. Satellite Body & Dual Solar Array Wings: GREEN (Connected) vs RED (Non-Connected)
      final bodyColor = isConnected
          ? const Color(0xFF22C55E) // Vivid Emerald Green
          : const Color(0xFFEF4444); // Vivid Alert Red

      final wingColor = isConnected
          ? const Color(0xFF86EFAC) // Mint Green
          : const Color(0xFFFCA5A5); // Alert Light Red

      // Unlinked satellite alert halo ring
      if (!isConnected) {
        final alertHalo = Paint()
          ..color = const Color(0xFFEF4444).withValues(alpha: 0.45)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6;
        canvas.drawCircle(sc, 9.5, alertHalo);
      }

      // Status aura
      satPaint.color = bodyColor.withValues(alpha: isConnected ? 0.25 : 0.45);
      canvas.drawCircle(sc, isConnected ? 6.5 : 8.0, satPaint);

      // Avionics bus box
      satPaint.color = bodyColor;
      canvas.drawRect(Rect.fromCenter(center: sc, width: isConnected ? 5.0 : 6.0, height: isConnected ? 5.0 : 6.0), satPaint);

      // Solar panel wings
      final wingPaint = Paint()
        ..color = wingColor
        ..style = PaintingStyle.fill;
      canvas.drawRect(Rect.fromCenter(center: Offset(sc.dx - 5.0, sc.dy), width: 4.0, height: 2.2), wingPaint);
      canvas.drawRect(Rect.fromCenter(center: Offset(sc.dx + 5.0, sc.dy), width: 4.0, height: 2.2), wingPaint);

      // 4. Real-time Telemetry Tag on front hemisphere
      if (drawFront) {
        final label = sat.satelliteId.replaceAll('SAT-', 'S');
        final statusTag = isConnected ? '' : ' [UNLINKED]';
        final textSpan = TextSpan(
          text: '$label ${(sat.batterySoC * 100).toInt()}%$statusTag',
          style: TextStyle(
            color: isConnected ? const Color(0xFF4ADE80) : const Color(0xFFEF4444),
            fontSize: isConnected ? 8.5 : 9.0,
            fontWeight: FontWeight.w800,
            fontFamily: 'monospace',
          ),
        );
        final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr)..layout();
        tp.paint(canvas, Offset(sc.dx + 10, sc.dy - 6));
      }
    }
  }

  /// Draws active ISL Laser Mesh Links between connected satellites in GREEN.
  void _drawLaserLinks(Canvas canvas, Offset center, double orbR, {required bool drawFront}) {
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6;

    final laserPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final satMap = {for (final s in satellites) s.satelliteId: s};
    const incRad = 53.0 * math.pi / 180.0;

    for (final link in links) {
      if (!link.isOpen) continue;
      final s1 = satMap[link.sourceSatelliteId];
      final s2 = satMap[link.targetSatelliteId];
      if (s1 == null || s2 == null) continue;

      final raan1 = ((s1.planeIndex % 6) * 60.0) * math.pi / 180.0;
      final nu1 = ((s1.trueAnomalyDeg * math.pi / 180.0) + orbitalAdvanceRad) % (2 * math.pi);
      final pIn1 = _computeSatelliteInertial3D(raan1, incRad, nu1, orbR);
      final pCam1 = _projectInertialToCamera(pIn1);

      final raan2 = ((s2.planeIndex % 6) * 60.0) * math.pi / 180.0;
      final nu2 = ((s2.trueAnomalyDeg * math.pi / 180.0) + orbitalAdvanceRad) % (2 * math.pi);
      final pIn2 = _computeSatelliteInertial3D(raan2, incRad, nu2, orbR);
      final pCam2 = _projectInertialToCamera(pIn2);

      final avgZ = (pCam1.z + pCam2.z) / 2;
      final isFront = avgZ >= 0;

      if (isFront == drawFront) {
        final o1 = Offset(center.dx + pCam1.x, center.dy + pCam1.y);
        final o2 = Offset(center.dx + pCam2.x, center.dy + pCam2.y);

        // Green laser beams between connected satellites
        glowPaint.color = drawFront
            ? const Color(0xFF22C55E).withValues(alpha: 0.35)
            : const Color(0xFF22C55E).withValues(alpha: 0.10);

        laserPaint.color = drawFront
            ? const Color(0xFF86EFAC).withValues(alpha: 0.95)
            : const Color(0xFF22C55E).withValues(alpha: 0.25);

        canvas.drawLine(o1, o2, glowPaint);
        canvas.drawLine(o1, o2, laserPaint);
      }
    }
  }

  /// Draws active Ground Feeder Contact Beams in ELECTRIC BLUE.
  void _drawContactBeams(Canvas canvas, Offset center, double R, double orbR) {
    final glowPaint = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.2;

    final beamPaint = Paint()
      ..color = const Color(0xFF00B0FF).withValues(alpha: 0.90)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const incRad = 53.0 * math.pi / 180.0;

    for (final sat in satellites) {
      final raan = ((sat.planeIndex % 6) * 60.0) * math.pi / 180.0;
      final nu = ((sat.trueAnomalyDeg * math.pi / 180.0) + orbitalAdvanceRad) % (2 * math.pi);
      final pSatInertial = _computeSatelliteInertial3D(raan, incRad, nu, orbR);

      for (final gs in EarthContinentsData.groundStations) {
        final gsLat = gs['lat'] as double;
        final gsLon = gs['lon'] as double;

        final pGsInertial = _computeEarthGeoInertial3D(gsLat, gsLon, R);

        // Distance in 3D space
        final dist3D = (pSatInertial - pGsInertial).length;
        // Reach threshold: ~1800 km contact footprint
        if (dist3D <= R * 0.42) {
          final pSatCam = _projectInertialToCamera(pSatInertial);
          final pGsCam = _projectInertialToCamera(pGsInertial);

          if (pSatCam.z > 0 || pGsCam.z > 0) {
            final scSat = Offset(center.dx + pSatCam.x, center.dy + pSatCam.y);
            final scGs = Offset(center.dx + pGsCam.x, center.dy + pGsCam.y);

            // Draw glowing blue connection lines to ground
            canvas.drawLine(scSat, scGs, glowPaint);
            canvas.drawLine(scSat, scGs, beamPaint);

            const textSpan = TextSpan(
              text: 'FEEDER 10Gbps',
              style: TextStyle(
                color: Color(0xFF00E5FF),
                fontSize: 8,
                fontWeight: FontWeight.w800,
                fontFamily: 'monospace',
              ),
            );
            final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr)..layout();
            final mid = Offset((scSat.dx + scGs.dx) / 2, (scSat.dy + scGs.dy) / 2);
            tp.paint(canvas, Offset(mid.dx + 6, mid.dy));
          }
          break; // connect to first pass
        }
      }
    }
  }

  Vector3D _computeSatelliteInertial3D(double raan, double inc, double nu, double r) {
    final x1 = r * math.cos(nu);
    final y1 = r * math.sin(nu) * math.cos(inc);
    final z1 = r * math.sin(nu) * math.sin(inc);

    final xInertial = x1 * math.cos(raan) - y1 * math.sin(raan);
    final yInertial = x1 * math.sin(raan) + y1 * math.cos(raan);
    final zInertial = z1;
    return Vector3D(xInertial, yInertial, zInertial);
  }

  Vector3D _computeEarthGeoInertial3D(double latDeg, double lonDeg, double r) {
    final latRad = latDeg * math.pi / 180.0;
    final lonRad = lonDeg * math.pi / 180.0;
    final lambda = lonRad + earthRotationRad;

    final x = r * math.cos(latRad) * math.cos(lambda);
    final y = r * math.cos(latRad) * math.sin(lambda);
    final z = r * math.sin(latRad);
    return Vector3D(x, y, z);
  }

  Vector3D _projectEarthGeoToCamera(double latDeg, double lonDeg, double r) {
    final pInertial = _computeEarthGeoInertial3D(latDeg, lonDeg, r);
    return _projectInertialToCamera(pInertial);
  }

  Vector3D _projectInertialToCamera(Vector3D pt) {
    final xPrime = pt.x * math.cos(camYaw) - pt.y * math.sin(camYaw);
    final yPrime = pt.x * math.sin(camYaw) + pt.y * math.cos(camYaw);
    final zPrime = pt.z;

    final xScreen = xPrime;
    final yScreen = -(zPrime * math.cos(camPitch) - yPrime * math.sin(camPitch));
    final zDepth = zPrime * math.sin(camPitch) + yPrime * math.cos(camPitch);
    return Vector3D(xScreen, yScreen, zDepth);
  }

  @override
  bool shouldRepaint(covariant RealRotating3DGlobePainter oldDelegate) {
    return true; // 60 FPS continuous realistic animation
  }
}
