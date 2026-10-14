import 'package:flutter/material.dart';
import 'package:orbit_scheduler_client/orbit_scheduler_client.dart';
import '../services/orbit_service.dart';

/// Screen 5: Gemini Operator Assistant — Clean white professional layout.
class PolicyAssistantScreen extends StatefulWidget {
  const PolicyAssistantScreen({super.key});

  @override
  State<PolicyAssistantScreen> createState() => _PolicyAssistantScreenState();
}

class _PolicyAssistantScreenState extends State<PolicyAssistantScreen> {
  final _promptController = TextEditingController();
  final _apiKeyController = TextEditingController(
    text: const String.fromEnvironment('GEMINI_API_KEY', defaultValue: ''),
  );
  AssistantInteraction? _latestInteraction;
  bool _isAnalyzing = false;
  bool _isConfirming = false;

  // White page colour tokens
  static const Color _pageBg = Color(0xFFFFFFFF);
  static const Color _cardBg = Color(0xFFF8F9FA);
  static const Color _cardBorder = Color(0xFFE2E5EA);
  static const Color _textPrimary = Color(0xFF0D0D0E);
  static const Color _textSecondary = Color(0xFF52525B);
  static const Color _textMuted = Color(0xFF9CA3AF);
  static const Color _accentBlue = Color(0xFF2563EB);
  static const Color _accentBlueLight = Color(0xFFEFF6FF);
  static const Color _accentBlueBorder = Color(0xFFBFDBFE);
  static const Color _chipBg = Color(0xFFF1F5F9);
  static const Color _chipBorder = Color(0xFFCBD5E1);
  static const Color _activePillBg = Color(0xFFDCFCE7);
  static const Color _activePillText = Color(0xFF166534);
  static const Color _activePillBorder = Color(0xFFBBF7D0);
  static const Color _divider = Color(0xFFE5E7EB);

  @override
  void dispose() {
    _promptController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = OrbitService.instance;
    final isOperator = service.currentRole == 'OPERATOR';

    return Container(
      color: _pageBg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _accentBlueLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _accentBlueBorder),
                  ),
                  child: const Icon(Icons.auto_awesome, color: _accentBlue, size: 20),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'GEMINI OPERATOR ASSISTANT',
                      style: TextStyle(color: _textMuted, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.4),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Natural Language Policy & Constraint Synthesis',
                      style: TextStyle(color: _textPrimary, fontSize: 20, fontWeight: FontWeight.w800, height: 1.1),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Describe rules in plain English — Gemini translates them into live scheduler constraints.',
                      style: TextStyle(color: _textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Input Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _cardBorder),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.edit_note, color: _accentBlue, size: 16),
                      const SizedBox(width: 8),
                      const Text(
                        'DEFINE POLICY CONSTRAINT',
                        style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.8),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isOperator ? _activePillBg : const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: isOperator ? _activePillBorder : const Color(0xFFFED7AA)),
                        ),
                        child: Text(
                          isOperator ? 'OPERATOR ACCESS' : 'VIEWER — READ ONLY',
                          style: TextStyle(
                            color: isOperator ? _activePillText : const Color(0xFF92400E),
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Type a natural policy. Gemini translates it into structured scheduler bounds. Requires operator confirmation.',
                    style: TextStyle(color: _textSecondary, fontSize: 12, height: 1.4),
                  ),
                  const SizedBox(height: 16),

                  // Prompt TextField
                  TextField(
                    controller: _promptController,
                    style: const TextStyle(color: _textPrimary, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'e.g. Keep training jobs off satellites above 68°C thermal load...',
                      hintStyle: const TextStyle(color: _textMuted, fontSize: 13),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: _cardBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: _accentBlue, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      suffixIcon: _isAnalyzing
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: _accentBlue),
                              ),
                            )
                          : IconButton(
                              icon: const Icon(Icons.send_rounded, color: _accentBlue, size: 18),
                              onPressed: isOperator && !_isAnalyzing ? _askAssistant : null,
                            ),
                    ),
                    onSubmitted: (_) {
                      if (isOperator && !_isAnalyzing) _askAssistant();
                    },
                  ),
                  const SizedBox(height: 14),

                  // Quick Prompt Chips
                  const Text('QUICK PROMPTS', style: TextStyle(color: _textMuted, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.0)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _promptChip('Keep training jobs off satellites above 68°C thermal load'),
                      _promptChip('Maintain at least 35% battery reserve during eclipse passes'),
                      _promptChip('Limit migrations to maximum 3 hops per workload'),
                      _promptChip('Preempt BATCH jobs when CRITICAL priority workloads arrive'),
                      _promptChip('Require ground-station pass contact for data ingest and results egress'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Optional API key toggle
                  Theme(
                    data: ThemeData(
                      dividerColor: _divider,
                      colorScheme: const ColorScheme.light(primary: _accentBlue),
                    ),
                    child: ExpansionTile(
                      title: const Text(
                        'Gemini API Key (Optional — Smart Built-in NLP active)',
                        style: TextStyle(color: _textSecondary, fontSize: 11),
                      ),
                      tilePadding: EdgeInsets.zero,
                      iconColor: _textMuted,
                      collapsedIconColor: _textMuted,
                      children: [
                        TextField(
                          controller: _apiKeyController,
                          obscureText: true,
                          style: const TextStyle(color: _textPrimary, fontSize: 12),
                          decoration: InputDecoration(
                            labelText: 'API Key (leave blank to use default built-in assistant)',
                            labelStyle: const TextStyle(color: _textMuted, fontSize: 11),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: _cardBorder),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Parsed Preview Card
            if (_latestInteraction != null) ...[
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _accentBlueLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _accentBlueBorder, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle_outline, color: _accentBlue, size: 16),
                        const SizedBox(width: 8),
                        const Text(
                          'PARSED CONSTRAINT SPECIFICATION',
                          style: TextStyle(color: _accentBlue, fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.8),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFFFDE68A)),
                          ),
                          child: const Text(
                            'AWAITING CONFIRMATION',
                            style: TextStyle(color: Color(0xFF92400E), fontSize: 9, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _latestInteraction!.naturalLanguageExplanation,
                      style: const TextStyle(color: _textPrimary, fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _badge('CONSTRAINT TYPE', _latestInteraction!.parsedConstraintType),
                        const SizedBox(width: 24),
                        _badge('PARAMETER VALUE', _latestInteraction!.parsedParamValue.toString()),
                        const SizedBox(width: 24),
                        _badge('STATUS', 'PENDING OPERATOR SIGN-OFF'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => setState(() => _latestInteraction = null),
                          child: const Text('Dismiss', style: TextStyle(color: _textSecondary, fontSize: 12.5)),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: isOperator && !_isConfirming ? _confirmPolicy : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _accentBlue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: _isConfirming
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.check, size: 16, color: Colors.white),
                          label: const Text('Confirm & Activate Policy', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Active Policies
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _cardBorder),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shield_outlined, color: _accentBlue, size: 16),
                      const SizedBox(width: 8),
                      const Text(
                        'ACTIVE CONSTELLATION POLICIES',
                        style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.8),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _activePillBg,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: _activePillBorder),
                        ),
                        child: const Text('3 ACTIVE', style: TextStyle(color: _activePillText, fontSize: 9, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildActivePolicyTile(
                    id: 'POL-DEF-01',
                    name: 'Orbital Thermal Protection Limit',
                    type: 'THERMAL_MAX',
                    value: '<= 66.0°C',
                    prompt: 'Keep training jobs off satellites above 66°C thermal load',
                    isActive: true,
                  ),
                  Divider(color: _divider, height: 24),
                  _buildActivePolicyTile(
                    id: 'POL-DEF-02',
                    name: 'Eclipse Battery Reserve Floor',
                    type: 'BATTERY_MIN',
                    value: '>= 30.0%',
                    prompt: 'Maintain at least 30% battery reserve across eclipse passes',
                    isActive: true,
                  ),
                  Divider(color: _divider, height: 24),
                  _buildActivePolicyTile(
                    id: 'POL-DEF-03',
                    name: 'Anti Ping-Pong Migration Ceiling',
                    type: 'MIGRATION_CAP',
                    value: '<= 3 Hops',
                    prompt: 'Limit migrations to maximum 3 hops per workload',
                    isActive: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivePolicyTile({
    required String id,
    required String name,
    required String type,
    required String value,
    required String prompt,
    required bool isActive,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF22C55E) : _textMuted,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(name, style: const TextStyle(color: _textPrimary, fontWeight: FontWeight.w700, fontSize: 13)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _chipBg,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: _chipBorder),
                    ),
                    child: Text('$type: $value', style: const TextStyle(color: _textSecondary, fontSize: 10, fontFamily: 'monospace')),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text('"$prompt"', style: const TextStyle(color: _textSecondary, fontSize: 11, fontStyle: FontStyle.italic)),
            ],
          ),
        ),
        Switch(
          value: isActive,
          activeThumbColor: _accentBlue,
          onChanged: (val) => OrbitService.instance.togglePolicy(id, val),
        ),
      ],
    );
  }

  Widget _promptChip(String text) {
    return InkWell(
      onTap: () {
        _promptController.text = text;
        _askAssistant();
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: _chipBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bolt_outlined, size: 12, color: _accentBlue),
            const SizedBox(width: 6),
            Text(text, style: const TextStyle(color: _textSecondary, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _badge(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _textMuted, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: _textPrimary, fontWeight: FontWeight.w800, fontSize: 12, fontFamily: 'monospace')),
      ],
    );
  }

  void _askAssistant() async {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;
    setState(() => _isAnalyzing = true);
    final key = _apiKeyController.text.trim().isNotEmpty ? _apiKeyController.text.trim() : null;
    final interaction = await OrbitService.instance.askAssistant(prompt, apiKey: key);
    if (mounted) {
      setState(() {
        _latestInteraction = interaction;
        _isAnalyzing = false;
      });
    }
  }

  void _confirmPolicy() async {
    if (_latestInteraction?.generatedPolicy == null) return;
    setState(() => _isConfirming = true);
    await OrbitService.instance.confirmPolicy(_latestInteraction!.generatedPolicy!);
    if (mounted) {
      setState(() {
        _isConfirming = false;
        _latestInteraction = null;
        _promptController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Policy confirmed and active.')),
      );
    }
  }
}
