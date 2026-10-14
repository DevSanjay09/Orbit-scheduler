import 'package:flutter/material.dart';
import '../theme/orbit_theme.dart';
import '../services/orbit_service.dart';

/// Top Aerospace Mission Control Header in elegant Black & White.
class MissionControlHeader extends StatelessWidget {
  final VoidCallback? onOpenSubmissionModal;

  const MissionControlHeader({
    super.key,
    this.onOpenSubmissionModal,
  });

  @override
  Widget build(BuildContext context) {
    final service = OrbitService.instance;
    final state = service.latestState;

    final totalCompute = state?.statsTotalComputeTFlops ?? 8640.0;
    final usedCompute = state?.statsUsedComputeTFlops ?? 0.0;
    final computePercent = totalCompute > 0 ? (usedCompute / totalCompute).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
      decoration: const BoxDecoration(
        color: OrbitTheme.bgDark,
        border: Border(bottom: BorderSide(color: OrbitTheme.cardBorder, width: 1.0)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Branding
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: service.isConnected ? OrbitTheme.white : OrbitTheme.textMuted,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: OrbitTheme.white.withValues(alpha: service.isConnected ? 0.6 : 0.0),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ORBIT SCHEDULER',
                            style: TextStyle(
                              color: OrbitTheme.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              letterSpacing: 2.0,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            service.isConnected ? 'AUTONOMOUS ORBITAL COMPUTE • LEO' : 'CONNECTING TO SERVERPOD...',
                            style: const TextStyle(
                              color: OrbitTheme.textSecondary,
                              fontSize: 10,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 28),

                  // Compute Utilization Gauge
                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 260, maxWidth: 440),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Flexible(
                                    child: Text(
                                      'CONSTELLATION COMPUTE CAPACITY',
                                      style: TextStyle(color: OrbitTheme.textMuted, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.8),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${usedCompute.toStringAsFixed(0)} / ${totalCompute.toStringAsFixed(0)} TF (${(computePercent * 100).toStringAsFixed(1)}%)',
                                    style: const TextStyle(color: OrbitTheme.white, fontSize: 11, fontWeight: FontWeight.w700, fontFamily: 'monospace'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: LinearProgressIndicator(
                                  value: computePercent,
                                  backgroundColor: OrbitTheme.surfaceElevated,
                                  valueColor: const AlwaysStoppedAnimation<Color>(OrbitTheme.white),
                                  minHeight: 4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        _statusPill(
                          label: '${state?.satellites.length ?? 72} NODES',
                        ),
                        const SizedBox(width: 8),
                        _statusPill(
                          label: 'LOOKAHEAD ACTIVE',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),

          // Sim Speed Multiplier
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: OrbitTheme.cardDark,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: OrbitTheme.cardBorder),
            ),
            child: Row(
              children: [
                const Text('WARP: ', style: TextStyle(color: OrbitTheme.textMuted, fontSize: 10, fontWeight: FontWeight.w600)),
                ...[1.0, 5.0, 15.0].map((spd) {
                  final isCurrent = service.simSpeed == spd;
                  return InkWell(
                    onTap: () => service.setSimSpeed(spd),
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isCurrent ? OrbitTheme.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${spd.toInt()}x',
                        style: TextStyle(
                          color: isCurrent ? OrbitTheme.bgDark : OrbitTheme.textSecondary,
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Role switcher
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: OrbitTheme.cardDark,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: OrbitTheme.cardBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: service.currentRole,
                dropdownColor: OrbitTheme.cardDark,
                style: const TextStyle(color: OrbitTheme.white, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                items: const [
                  DropdownMenuItem(value: 'OPERATOR', child: Text('OPERATOR')),
                  DropdownMenuItem(value: 'VIEWER', child: Text('VIEWER')),
                ],
                onChanged: (val) {
                  if (val != null) service.setRole(val);
                },
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Submit Workload Button (High-contrast pure white pill)
          ElevatedButton.icon(
            onPressed: service.currentRole == 'OPERATOR' ? onOpenSubmissionModal : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: OrbitTheme.white,
              foregroundColor: OrbitTheme.bgDark,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            icon: const Icon(Icons.add, size: 15, color: OrbitTheme.bgDark),
            label: const Text('Submit Workload', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, letterSpacing: 0.3)),
          ),
        ],
      ),
    ),
  );
},
),
);
}

  Widget _statusPill({required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: OrbitTheme.cardDark,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: OrbitTheme.cardBorder),
      ),
      child: Text(
        label,
        style: const TextStyle(color: OrbitTheme.white, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.8),
      ),
    );
  }
}
