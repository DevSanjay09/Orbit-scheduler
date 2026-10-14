import 'package:flutter/material.dart';
import 'package:orbit_scheduler_client/orbit_scheduler_client.dart';
import '../theme/orbit_theme.dart';
import '../services/orbit_service.dart';

/// Screen 4: Fault Injection & Recovery Console with Dynamic Severity Color Encoding.
class FaultsScreen extends StatefulWidget {
  const FaultsScreen({super.key});

  @override
  State<FaultsScreen> createState() => _FaultsScreenState();
}

class _FaultsScreenState extends State<FaultsScreen> {
  String _targetSat = 'RANDOM';
  bool _isInjecting = false;

  // Severity color tokens
  static const Color _highColor = Color(0xFFEF4444);      // Red
  static const Color _highBg = Color(0xFF2E1014);
  static const Color _highBorder = Color(0xFF7F1D1D);
  static const Color _highText = Color(0xFFF87171);

  static const Color _medColor = Color(0xFFF59E0B);       // Amber
  static const Color _medBg = Color(0xFF2C1E0A);
  static const Color _medBorder = Color(0xFF78350F);
  static const Color _medText = Color(0xFFFBBF24);

  static const Color _lowColor = Color(0xFF10B981);       // Green / Emerald
  static const Color _lowBg = Color(0xFF0C2419);
  static const Color _lowBorder = Color(0xFF064E3B);
  static const Color _lowText = Color(0xFF34D399);

  @override
  Widget build(BuildContext context) {
    final service = OrbitService.instance;
    final state = service.latestState;
    final satellites = state?.satellites ?? [];
    final faults = state?.recentFaults ?? [];

    final isOperator = service.currentRole == 'OPERATOR';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _highColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: _highColor.withValues(alpha: 0.3)),
                    ),
                    child: const Icon(Icons.warning_amber_rounded, color: _highColor, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'FAULT INJECTION & AUTONOMOUS RE-PLANNING',
                        style: TextStyle(color: OrbitTheme.textMuted, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Fault Tolerance & Resilient Failover Engine',
                        style: TextStyle(color: OrbitTheme.white, fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: OrbitTheme.cardDark,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: OrbitTheme.cardBorder),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _targetSat,
                    dropdownColor: OrbitTheme.cardDark,
                    style: const TextStyle(color: OrbitTheme.white, fontWeight: FontWeight.w600, fontSize: 12),
                    items: [
                      const DropdownMenuItem(value: 'RANDOM', child: Text('Target: RANDOM SATELLITE')),
                      ...satellites.take(20).map((s) => DropdownMenuItem(value: s.satelliteId, child: Text('Target: ${s.satelliteId}'))),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _targetSat = val);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Severity Color Legend
          Row(
            children: [
              const Text('SEVERITY TIERS:', style: TextStyle(color: OrbitTheme.textMuted, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.0)),
              const SizedBox(width: 12),
              _legendBadge('HIGH / CRITICAL', _highBg, _highBorder, _highText),
              const SizedBox(width: 8),
              _legendBadge('MEDIUM', _medBg, _medBorder, _medText),
              const SizedBox(width: 8),
              _legendBadge('LOW', _lowBg, _lowBorder, _lowText),
            ],
          ),
          const SizedBox(height: 14),

          // 4 Action Cards
          Row(
            children: [
              Expanded(
                child: _faultCard(
                  title: 'RADIATION UPSET',
                  typeCode: 'RADIATION_UPSET',
                  desc: 'Injects SRAM bit-flip into compute pipeline. Parity corrupted.',
                  icon: Icons.flash_on_outlined,
                  severity: 'LOW',
                  accentColor: _lowColor,
                  bgColor: _lowBg,
                  borderColor: _lowBorder,
                  textColor: _lowText,
                  enabled: isOperator && !_isInjecting,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _faultCard(
                  title: 'ISL LINK DROP',
                  typeCode: 'LINK_DROP',
                  desc: 'Breaks laser crosslink tracking. Evaluates mesh re-routing.',
                  icon: Icons.link_off,
                  severity: 'MEDIUM',
                  accentColor: _medColor,
                  bgColor: _medBg,
                  borderColor: _medBorder,
                  textColor: _medText,
                  enabled: isOperator && !_isInjecting,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _faultCard(
                  title: 'THERMAL SPIKE',
                  typeCode: 'THERMAL_SPIKE',
                  desc: 'Surges core temp +24°C. Triggers emergency thermal throttle evasion.',
                  icon: Icons.thermostat_outlined,
                  severity: 'HIGH',
                  accentColor: const Color(0xFFF97316),
                  bgColor: const Color(0xFF331608),
                  borderColor: const Color(0xFF9A3412),
                  textColor: const Color(0xFFFB923C),
                  enabled: isOperator && !_isInjecting,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _faultCard(
                  title: 'SATELLITE LOSS',
                  typeCode: 'SATELLITE_LOSS',
                  desc: 'Drops power bus offline. Workloads evacuated to active nodes.',
                  icon: Icons.power_off_outlined,
                  severity: 'CRITICAL',
                  accentColor: _highColor,
                  bgColor: _highBg,
                  borderColor: _highBorder,
                  textColor: _highText,
                  enabled: isOperator && !_isInjecting,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Live Feed
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: OrbitTheme.cardDark,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: OrbitTheme.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(width: 3, height: 14, color: OrbitTheme.white),
                        const SizedBox(width: 8),
                        const Text(
                          'AUTONOMOUS RE-PLANNING FEED',
                          style: TextStyle(color: OrbitTheme.white, fontWeight: FontWeight.w700, fontSize: 12, letterSpacing: 0.8),
                        ),
                      ],
                    ),
                    Text(
                      '${faults.length} Events Logged',
                      style: const TextStyle(color: OrbitTheme.textMuted, fontSize: 11, fontFamily: 'monospace'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (faults.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(
                      child: Text('No faults injected. Trigger an event above to inspect recovery.',
                          style: TextStyle(color: OrbitTheme.textMuted, fontSize: 13)),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: faults.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final f = faults[index];
                      return _buildFaultItem(f);
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendBadge(String text, Color bg, Color border, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: border),
      ),
      child: Text(text, style: TextStyle(color: textColor, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
    );
  }

  Widget _faultCard({
    required String title,
    required String typeCode,
    required String desc,
    required IconData icon,
    required String severity,
    required Color accentColor,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
    required bool enabled,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: OrbitTheme.cardDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accentColor, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: OrbitTheme.white, fontWeight: FontWeight.w700, fontSize: 12, letterSpacing: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: borderColor),
            ),
            child: Text(
              '$severity SEVERITY',
              style: TextStyle(color: textColor, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: const TextStyle(color: OrbitTheme.textSecondary, fontSize: 11, height: 1.3),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: enabled ? () => _trigger(typeCode) : null,
              style: OutlinedButton.styleFrom(
                foregroundColor: textColor,
                side: BorderSide(color: borderColor),
                backgroundColor: bgColor.withValues(alpha: 0.4),
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              child: Text('Inject $typeCode', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaultItem(FaultEvent fault) {
    final sevUpper = fault.impactSeverity.toUpperCase();
    final bool isHigh = sevUpper.contains('HIGH') || sevUpper.contains('CRIT');
    final bool isMed = sevUpper.contains('MED');

    final Color accentColor = isHigh ? _highColor : (isMed ? _medColor : _lowColor);
    final Color badgeBg = isHigh ? _highBg : (isMed ? _medBg : _lowBg);
    final Color badgeBorder = isHigh ? _highBorder : (isMed ? _medBorder : _lowBorder);
    final Color badgeText = isHigh ? _highText : (isMed ? _medText : _lowText);
    final IconData icon = isHigh
        ? Icons.error_outline
        : (isMed ? Icons.warning_amber_rounded : Icons.info_outline);

    return Container(
      decoration: BoxDecoration(
        color: OrbitTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: badgeBorder.withValues(alpha: 0.7)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left severity bar
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, color: accentColor, size: 18),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                fault.eventType,
                                style: const TextStyle(color: OrbitTheme.white, fontWeight: FontWeight.w700, fontSize: 12, letterSpacing: 0.5),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: badgeBg,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: badgeBorder),
                                ),
                                child: Text(
                                  fault.impactSeverity,
                                  style: TextStyle(color: badgeText, fontSize: 9, fontWeight: FontWeight.w800),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                fault.targetSatelliteId,
                                style: TextStyle(color: accentColor, fontWeight: FontWeight.w700, fontSize: 11, fontFamily: 'monospace'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            fault.description,
                            style: const TextStyle(color: OrbitTheme.textSecondary, fontSize: 12),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.check_circle_outline, color: _lowColor, size: 13),
                              const SizedBox(width: 6),
                              const Text(
                                'Autonomous Re-plan: Checkpoint verified, safe alternative route established.',
                                style: TextStyle(color: OrbitTheme.textSecondary, fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _trigger(String faultType) async {
    setState(() => _isInjecting = true);
    final target = _targetSat == 'RANDOM' ? null : _targetSat;
    await OrbitService.instance.triggerFault(faultType: faultType, targetSatelliteId: target);
    if (mounted) {
      setState(() => _isInjecting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Injected $faultType on ${target ?? "random node"}.')),
      );
    }
  }
}
