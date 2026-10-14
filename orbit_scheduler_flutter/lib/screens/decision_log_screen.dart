import 'package:flutter/material.dart';
import 'package:orbit_scheduler_client/orbit_scheduler_client.dart';
import '../theme/orbit_theme.dart';
import '../services/orbit_service.dart';

/// Screen 6: Append-Only Cryptographic Decision Ledger in Black & White.
class DecisionLogScreen extends StatefulWidget {
  const DecisionLogScreen({super.key});

  @override
  State<DecisionLogScreen> createState() => _DecisionLogScreenState();
}

class _DecisionLogScreenState extends State<DecisionLogScreen> {
  final _searchController = TextEditingController();
  String _selectedAction = 'ALL';
  String? _expandedEntryId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = OrbitService.instance;
    final state = service.latestState;
    final entries = state?.recentDecisions ?? [];

    final filtered = entries.where((e) {
      if (_selectedAction != 'ALL' && e.actionType != _selectedAction) return false;
      final q = _searchController.text.trim().toLowerCase();
      if (q.isNotEmpty) {
        final matches = e.entryId.toLowerCase().contains(q) ||
            e.reasonCode.toLowerCase().contains(q) ||
            e.explanation.toLowerCase().contains(q) ||
            (e.jobId?.toLowerCase().contains(q) ?? false) ||
            (e.targetSatelliteId?.toLowerCase().contains(q) ?? false);
        if (!matches) return false;
      }
      return true;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Audit Verification Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'APPEND-ONLY HASH-CHAINED DECISION LEDGER',
                    style: TextStyle(color: OrbitTheme.textMuted, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Cryptographically Verifiable Scheduling Decisions (SHA-256)',
                    style: TextStyle(color: OrbitTheme.white, fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: service.isAuditingLedger ? null : () => service.verifyHashChain(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: OrbitTheme.white,
                  side: const BorderSide(color: OrbitTheme.cardBorder),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                icon: service.isAuditingLedger
                    ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: OrbitTheme.white))
                    : const Icon(Icons.verified_outlined, size: 16),
                label: const Text('Verify Hash Chain Integrity', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Audit status banner if verified
          if (service.lastAuditStatus != null)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: OrbitTheme.cardDark,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: OrbitTheme.white),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: OrbitTheme.white, size: 18),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      service.lastAuditStatus!,
                      style: const TextStyle(
                        color: OrbitTheme.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Search & Filter Toolbar
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: OrbitTheme.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Search decision entries by reason code, job ID, or satellite ID...',
                    hintStyle: const TextStyle(color: OrbitTheme.textMuted, fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: OrbitTheme.textMuted, size: 18),
                    filled: true,
                    fillColor: OrbitTheme.cardDark,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: OrbitTheme.cardBorder)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 14),
              // Action filter
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: OrbitTheme.cardDark,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: OrbitTheme.cardBorder),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedAction,
                    dropdownColor: OrbitTheme.cardDark,
                    style: const TextStyle(color: OrbitTheme.white, fontWeight: FontWeight.w600, fontSize: 12),
                    items: const [
                      DropdownMenuItem(value: 'ALL', child: Text('Filter: ALL ACTIONS')),
                      DropdownMenuItem(value: 'PLACEMENT', child: Text('PLACEMENT')),
                      DropdownMenuItem(value: 'MIGRATION', child: Text('MIGRATION')),
                      DropdownMenuItem(value: 'REJECTION', child: Text('REJECTION')),
                      DropdownMenuItem(value: 'ROLLBACK', child: Text('ROLLBACK')),
                      DropdownMenuItem(value: 'CHECKPOINT', child: Text('CHECKPOINT')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedAction = val);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Ledger Table / List
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No decision entries found.', style: TextStyle(color: OrbitTheme.textMuted)))
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final entry = filtered[index];
                      final isExpanded = _expandedEntryId == entry.entryId;
                      return _buildEntryCard(entry, isExpanded);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryCard(DecisionLogEntry entry, bool isExpanded) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: OrbitTheme.cardDark,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isExpanded ? OrbitTheme.white : OrbitTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                entry.entryId,
                style: const TextStyle(color: OrbitTheme.white, fontWeight: FontWeight.w700, fontSize: 12, fontFamily: 'monospace'),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: OrbitTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  entry.actionType,
                  style: const TextStyle(color: OrbitTheme.silver, fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: OrbitTheme.cardBorder),
                ),
                child: Text(
                  entry.reasonCode,
                  style: const TextStyle(color: OrbitTheme.textSecondary, fontSize: 10, fontFamily: 'monospace'),
                ),
              ),
              const Spacer(),
              Text(
                '${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}:${entry.timestamp.second.toString().padLeft(2, '0')} UTC',
                style: const TextStyle(color: OrbitTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            entry.explanation,
            style: const TextStyle(color: OrbitTheme.textPrimary, fontSize: 12, height: 1.3),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _expandedEntryId = isExpanded ? null : entry.entryId;
                  });
                },
                child: Row(
                  children: [
                    Icon(isExpanded ? Icons.expand_less : Icons.expand_more, color: OrbitTheme.textMuted, size: 14),
                    const SizedBox(width: 4),
                    const Text('SHA-256 Proof', style: TextStyle(color: OrbitTheme.textMuted, fontSize: 10)),
                  ],
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () async {
                  final explanation = await OrbitService.instance.explainDecision(entry.entryId);
                  if (!mounted) return;
                  showDialog(
                    context: context,
                    builder: (dialogCtx) => AlertDialog(
                      backgroundColor: OrbitTheme.cardDark,
                      title: const Text('Gemini Decision Explanation', style: TextStyle(color: OrbitTheme.white, fontSize: 15, fontWeight: FontWeight.w700)),
                      content: Text(explanation, style: const TextStyle(color: OrbitTheme.textSecondary, fontSize: 13, height: 1.4)),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('OK', style: TextStyle(color: OrbitTheme.white))),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline, size: 12, color: OrbitTheme.textSecondary),
                label: const Text('Explain with Gemini', style: TextStyle(color: OrbitTheme.textSecondary, fontSize: 11)),
              ),
            ],
          ),

          if (isExpanded) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: OrbitTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: OrbitTheme.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _hashLine('PREV:', entry.previousHash),
                  const SizedBox(height: 4),
                  _hashLine('CURR:', entry.currentHash, isCurrent: true),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _hashLine(String label, String hash, {bool isCurrent = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isCurrent ? OrbitTheme.white : OrbitTheme.textMuted,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            hash,
            style: TextStyle(
              color: isCurrent ? OrbitTheme.white : OrbitTheme.textSecondary,
              fontSize: 10,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }
}
