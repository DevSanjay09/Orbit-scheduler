import 'package:flutter/material.dart';
import '../theme/orbit_theme.dart';
import '../services/orbit_service.dart';
import '../widgets/mission_control_header.dart';
import '../widgets/job_submission_modal.dart';
import 'constellation_map_screen.dart';
import 'jobs_screen.dart';
import 'satellite_detail_screen.dart';
import 'faults_screen.dart';
import 'policy_assistant_screen.dart';
import 'decision_log_screen.dart';
import 'benchmarks_screen.dart';

/// Main Mission Control Dashboard with minimalist Black & White sidebar and header.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentScreenIndex = 0;
  String? _forecastTargetSatId;

  final List<NavDestination> _destinations = const [
    NavDestination(icon: Icons.public, label: 'Constellation Map', subtitle: 'Live 3D World Globe & Mesh'),
    NavDestination(icon: Icons.task_alt, label: 'Workloads & Jobs', subtitle: 'Active Workloads & Timelines'),
    NavDestination(icon: Icons.insights, label: 'Satellite Forecast', subtitle: '3-Hour Telemetry Curves'),
    NavDestination(icon: Icons.warning_amber, label: 'Fault Engine', subtitle: 'Fault Injections & Recovery'),
    NavDestination(icon: Icons.auto_awesome, label: 'Gemini Assistant', subtitle: 'Constraint Policy Engine'),
    NavDestination(icon: Icons.verified, label: 'Decision Ledger', subtitle: 'Append-Only Hash Chain'),
    NavDestination(icon: Icons.leaderboard, label: 'Benchmark Suite', subtitle: 'Multi-Algorithm Comparisons'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: OrbitService.instance,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: OrbitTheme.bgDark,
          body: Column(
            children: [
              // Top Aerospace Mission Control Header
              MissionControlHeader(
                onOpenSubmissionModal: () => showDialog(
                  context: context,
                  builder: (_) => const JobSubmissionModal(),
                ),
              ),

              // Main Body: Sidebar + Active Screen
              Expanded(
                child: Row(
                  children: [
                    // Navigation Sidebar
                    Container(
                      width: 240,
                      decoration: const BoxDecoration(
                        color: OrbitTheme.bgDark,
                        border: Border(right: BorderSide(color: OrbitTheme.cardBorder, width: 1.0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 18),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              'MODULES',
                              style: TextStyle(
                                color: OrbitTheme.textMuted,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: ListView.separated(
                              itemCount: _destinations.length,
                              separatorBuilder: (_, index) => const SizedBox(height: 2),
                              itemBuilder: (context, index) {
                                final dest = _destinations[index];
                                final isSelected = _currentScreenIndex == index;
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _currentScreenIndex = index;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: isSelected ? OrbitTheme.cardDark : Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: isSelected ? OrbitTheme.cardBorder : Colors.transparent,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          dest.icon,
                                          color: isSelected ? OrbitTheme.white : OrbitTheme.textMuted,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                dest.label,
                                                style: TextStyle(
                                                  color: isSelected ? OrbitTheme.white : OrbitTheme.textSecondary,
                                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(height: 1),
                                              Text(
                                                dest.subtitle,
                                                style: const TextStyle(color: OrbitTheme.textMuted, fontSize: 10),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          // Bottom System Info Box
                          Container(
                            padding: const EdgeInsets.all(14),
                            margin: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: OrbitTheme.cardDark,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: OrbitTheme.cardBorder),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'ORBIT ENGINE 3.4',
                                  style: TextStyle(
                                    color: OrbitTheme.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Serverpod Monolith • Pure Dart\nKeplerian + Lumped Thermal',
                                  style: TextStyle(color: OrbitTheme.textMuted, fontSize: 10, height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Active Screen Area
                    Expanded(
                      child: Container(
                        color: OrbitTheme.bgDark,
                        child: _buildActiveScreen(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActiveScreen() {
    switch (_currentScreenIndex) {
      case 0:
        return ConstellationMapScreen(
          onSelectForecast: (satId) {
            setState(() {
              _forecastTargetSatId = satId;
              _currentScreenIndex = 2; // Jump to Satellite Detail
            });
          },
        );
      case 1:
        return const JobsScreen();
      case 2:
        return SatelliteDetailScreen(
          key: ValueKey(_forecastTargetSatId),
          initialSatelliteId: _forecastTargetSatId,
        );
      case 3:
        return const FaultsScreen();
      case 4:
        return const PolicyAssistantScreen();
      case 5:
        return const DecisionLogScreen();
      case 6:
        return const BenchmarksScreen();
      default:
        return const ConstellationMapScreen();
    }
  }
}

class NavDestination {
  final IconData icon;
  final String label;
  final String subtitle;

  const NavDestination({
    required this.icon,
    required this.label,
    required this.subtitle,
  });
}
