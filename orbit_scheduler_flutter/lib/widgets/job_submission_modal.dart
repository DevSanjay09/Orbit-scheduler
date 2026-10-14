import 'package:flutter/material.dart';
import '../theme/orbit_theme.dart';
import '../services/orbit_service.dart';

/// Modal dialog for submitting a new AI compute job.
/// Styled in an ultra-clean, elegant monochrome aesthetic.
class JobSubmissionModal extends StatefulWidget {
  const JobSubmissionModal({super.key});

  @override
  State<JobSubmissionModal> createState() => _JobSubmissionModalState();
}

class _JobSubmissionModalState extends State<JobSubmissionModal> {
  final _nameController = TextEditingController(text: 'LLM-FineTune-LEO');
  String _selectedPriority = 'HIGH';
  double _computeTFlops = 35.0;
  double _runtimeMinutes = 20.0;
  double _checkpointIntervalSec = 180.0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24.0),
      child: Container(
        width: 500,
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: OrbitTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: OrbitTheme.cardBorder),
                  ),
                  child: const Icon(Icons.rocket_launch_outlined, color: OrbitTheme.white, size: 18),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Submit Orbital Compute Workload',
                  style: TextStyle(
                    color: OrbitTheme.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Job Name
            const Text(
              'WORKLOAD IDENTIFIER',
              style: TextStyle(
                color: OrbitTheme.textMuted,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _nameController,
              style: const TextStyle(
                color: OrbitTheme.textPrimary,
                fontFamily: 'monospace',
                fontSize: 13,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: OrbitTheme.surfaceElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: OrbitTheme.cardBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: OrbitTheme.cardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: OrbitTheme.white, width: 1.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
            const SizedBox(height: 18),

            // Priority Selection
            const Text(
              'WORKLOAD PRIORITY',
              style: TextStyle(
                color: OrbitTheme.textMuted,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: ['CRITICAL', 'HIGH', 'NORMAL', 'BATCH'].map((priority) {
                final isSelected = _selectedPriority == priority;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: InkWell(
                      onTap: () => setState(() => _selectedPriority = priority),
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                          color: isSelected ? OrbitTheme.white : OrbitTheme.surfaceElevated,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isSelected ? OrbitTheme.white : OrbitTheme.cardBorder,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            priority,
                            style: TextStyle(
                              color: isSelected ? OrbitTheme.bgDark : OrbitTheme.textSecondary,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Compute slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'REQUIRED COMPUTE CAPACITY',
                  style: TextStyle(
                    color: OrbitTheme.textMuted,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
                Text(
                  '${_computeTFlops.toStringAsFixed(0)} TFlops',
                  style: const TextStyle(
                    color: OrbitTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: OrbitTheme.white,
                inactiveTrackColor: OrbitTheme.cardBorder,
                thumbColor: OrbitTheme.white,
                trackHeight: 2,
              ),
              child: Slider(
                value: _computeTFlops,
                min: 10.0,
                max: 80.0,
                divisions: 14,
                onChanged: (val) => setState(() => _computeTFlops = val),
              ),
            ),

            // Runtime slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ESTIMATED RUNTIME',
                  style: TextStyle(
                    color: OrbitTheme.textMuted,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
                Text(
                  '${_runtimeMinutes.toStringAsFixed(0)} mins (${(_runtimeMinutes * 60).toInt()}s)',
                  style: const TextStyle(
                    color: OrbitTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: OrbitTheme.white,
                inactiveTrackColor: OrbitTheme.cardBorder,
                thumbColor: OrbitTheme.white,
                trackHeight: 2,
              ),
              child: Slider(
                value: _runtimeMinutes,
                min: 5.0,
                max: 90.0,
                divisions: 17,
                onChanged: (val) => setState(() => _runtimeMinutes = val),
              ),
            ),

            // Checkpoint Interval slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'CHECKPOINT CADENCE',
                  style: TextStyle(
                    color: OrbitTheme.textMuted,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
                Text(
                  '${_checkpointIntervalSec.toInt()} seconds',
                  style: const TextStyle(
                    color: OrbitTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: OrbitTheme.white,
                inactiveTrackColor: OrbitTheme.cardBorder,
                thumbColor: OrbitTheme.white,
                trackHeight: 2,
              ),
              child: Slider(
                value: _checkpointIntervalSec,
                min: 60.0,
                max: 600.0,
                divisions: 9,
                onChanged: (val) => setState(() => _checkpointIntervalSec = val),
              ),
            ),
            const SizedBox(height: 22),

            // Submit Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel', style: TextStyle(color: OrbitTheme.textSecondary, fontSize: 12.5)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: OrbitTheme.white,
                    foregroundColor: OrbitTheme.bgDark,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2, color: OrbitTheme.bgDark),
                        )
                      : const Text(
                          'Dispatch Workload',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5, letterSpacing: 0.5),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submit() async {
    setState(() => _isSubmitting = true);
    final name = _nameController.text.trim().isEmpty ? 'Workload-${DateTime.now().millisecond}' : _nameController.text.trim();

    await OrbitService.instance.submitJob(
      name: name,
      priority: _selectedPriority,
      totalRuntimeSeconds: _runtimeMinutes * 60.0,
      requiredComputeTFlops: _computeTFlops,
      checkpointIntervalSeconds: _checkpointIntervalSec,
    );

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Workload "$name" dispatched to lookahead scheduler.'),
          backgroundColor: OrbitTheme.surfaceElevated,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
