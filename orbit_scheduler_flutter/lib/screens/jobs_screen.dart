import 'package:flutter/material.dart';
import 'package:orbit_scheduler_client/orbit_scheduler_client.dart';
import '../theme/orbit_theme.dart';
import '../services/orbit_service.dart';
import '../widgets/job_submission_modal.dart';

/// Screen 2: Workloads & Jobs management with Ground Contact Ingest/Egress passes,
/// Priority Preemption, and Unplaceable Safe Hold Queue in elegant Black & White.
class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  String _filterState = 'ALL';

  @override
  Widget build(BuildContext context) {
    final service = OrbitService.instance;
    final state = service.latestState;
    final allJobs = state?.activeJobs ?? [];

    final filteredJobs = allJobs.where((j) {
      if (_filterState == 'ALL') return true;
      if (_filterState == 'INGESTING') return j.state == 'INGESTING';
      if (_filterState == 'RUNNING') return j.state == 'RUNNING';
      if (_filterState == 'MIGRATING') return j.state == 'MIGRATING';
      if (_filterState == 'DOWNLINKING') return j.state == 'DOWNLINKING';
      if (_filterState == 'UNPLACEABLE') return j.state == 'UNPLACEABLE';
      if (_filterState == 'PREEMPTED') return j.state == 'PREEMPTED';
      if (_filterState == 'COMPLETED') return j.state == 'COMPLETED';
      return true;
    }).toList();

    double totalWastedSec = 0.0;
    for (final j in allJobs) {
      totalWastedSec += j.wastedComputeSeconds;
    }

    final ingestingCount = allJobs.where((j) => j.state == 'INGESTING').length;
    final runningCount = allJobs.where((j) => j.state == 'RUNNING').length;
    final migratingCount = allJobs.where((j) => j.state == 'MIGRATING').length;
    final downlinkingCount = allJobs.where((j) => j.state == 'DOWNLINKING').length;
    final unplaceableCount = allJobs.where((j) => j.state == 'UNPLACEABLE' || j.state == 'PREEMPTED').length;
    final completedCount = allJobs.where((j) => j.state == 'COMPLETED').length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Metrics Bar
          Row(
            children: [
              _metricBox('TOTAL WORKLOADS', '${allJobs.length}'),
              const SizedBox(width: 12),
              _metricBox('DATA INGEST (GROUND)', '$ingestingCount'),
              const SizedBox(width: 12),
              _metricBox('RUNNING ON ORBIT', '$runningCount'),
              const SizedBox(width: 12),
              _metricBox('MIGRATING (ISL)', '$migratingCount'),
              const SizedBox(width: 12),
              _metricBox('RESULTS EGRESS', '$downlinkingCount'),
              const SizedBox(width: 12),
              _metricBox('SAFE HOLD / PREEMPT', '$unplaceableCount'),
              const SizedBox(width: 12),
              _metricBox('COMPLETED', '$completedCount'),
              const SizedBox(width: 12),
              _metricBox('WASTED WORK', '${(totalWastedSec / 3600.0).toStringAsFixed(2)} hrs'),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => showDialog(context: context, builder: (_) => const JobSubmissionModal()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: OrbitTheme.white,
                  foregroundColor: OrbitTheme.bgDark,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                icon: const Icon(Icons.add, size: 16, color: OrbitTheme.bgDark),
                label: const Text('Submit Workload', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Minimalist Filter Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                'ALL',
                'INGESTING',
                'RUNNING',
                'MIGRATING',
                'DOWNLINKING',
                'UNPLACEABLE',
                'PREEMPTED',
                'COMPLETED',
              ].map((filter) {
                final isSelected = _filterState == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: InkWell(
                    onTap: () => setState(() => _filterState = filter),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? OrbitTheme.white : OrbitTheme.cardDark,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: isSelected ? OrbitTheme.white : OrbitTheme.cardBorder),
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          color: isSelected ? OrbitTheme.bgDark : OrbitTheme.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 18),

          // Job Cards List
          Expanded(
            child: filteredJobs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.inbox_outlined, color: OrbitTheme.textMuted, size: 36),
                        SizedBox(height: 12),
                        Text('No workloads matching filter.', style: TextStyle(color: OrbitTheme.textMuted, fontSize: 13)),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: filteredJobs.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _buildJobCard(filteredJobs[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _metricBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: OrbitTheme.cardDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: OrbitTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: OrbitTheme.textMuted, fontSize: 8.5, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
          const SizedBox(height: 3),
          Text(value, style: const TextStyle(color: OrbitTheme.white, fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
        ],
      ),
    );
  }

  Widget _buildJobCard(Job job) {
    final state = job.state;
    String stateDescription = '';
    IconData stateIcon = Icons.task;

    if (state == 'INGESTING') {
      stateDescription = job.targetSatelliteId ?? 'Awaiting Ground Station Pass';
      stateIcon = Icons.cloud_upload_outlined;
    } else if (state == 'DOWNLINKING') {
      stateDescription = job.targetSatelliteId ?? 'Awaiting Ground Station Pass';
      stateIcon = Icons.cloud_download_outlined;
    } else if (state == 'MIGRATING') {
      stateDescription = '${job.currentSatelliteId ?? "?"} ➔ ${job.targetSatelliteId ?? "?"} (10 Gbps ISL)';
      stateIcon = Icons.sync_alt;
    } else if (state == 'UNPLACEABLE') {
      stateDescription = job.targetSatelliteId ?? 'Deferred to Safe Holding Queue (Awaiting Lookahead Window)';
      stateIcon = Icons.pause_circle_outline;
    } else if (state == 'PREEMPTED') {
      stateDescription = job.targetSatelliteId ?? 'Preempted by High-Priority Job • Checkpoint Intact';
      stateIcon = Icons.low_priority;
    } else if (state == 'RUNNING') {
      stateDescription = 'Executing on ${job.currentSatelliteId ?? "Unknown Node"}';
      stateIcon = Icons.play_arrow;
    } else {
      stateDescription = 'Execution Finished (100% Ingest + Compute + Egress)';
      stateIcon = Icons.check_circle_outline;
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: OrbitTheme.cardDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: state == 'PREEMPTED' || state == 'UNPLACEABLE' ? const Color(0xFF3F3F46) : OrbitTheme.cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: ID, Priority, State, Node / Action Description
          Row(
            children: [
              Text(
                job.jobId,
                style: const TextStyle(color: OrbitTheme.white, fontWeight: FontWeight.w700, fontSize: 13.5, fontFamily: 'monospace'),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: OrbitTheme.cardBorder),
                ),
                child: Text(
                  job.priority,
                  style: const TextStyle(color: OrbitTheme.textSecondary, fontSize: 10, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: OrbitTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: state == 'PREEMPTED' ? OrbitTheme.white.withValues(alpha: 0.3) : Colors.transparent,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(stateIcon, size: 11, color: OrbitTheme.white),
                    const SizedBox(width: 5),
                    Text(
                      job.state,
                      style: const TextStyle(color: OrbitTheme.white, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.satellite_alt_outlined, color: OrbitTheme.textSecondary, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    stateDescription,
                    style: const TextStyle(
                      color: OrbitTheme.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 11.5,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Row 2: Progress Bar and Percentage
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: job.progress,
                    backgroundColor: OrbitTheme.surfaceElevated,
                    valueColor: const AlwaysStoppedAnimation<Color>(OrbitTheme.white),
                    minHeight: 4,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${(job.progress * 100).toStringAsFixed(1)}%',
                style: const TextStyle(color: OrbitTheme.white, fontWeight: FontWeight.w700, fontSize: 13, fontFamily: 'monospace'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Row 3: Meta details
          Row(
            children: [
              _infoLabel('Compute Capacity', '${job.requiredComputeTFlops.toInt()} TF'),
              const SizedBox(width: 20),
              _infoLabel('Runtime', '${(job.completedRuntimeSeconds / 60).toStringAsFixed(1)} / ${(job.totalRuntimeSeconds / 60).toInt()} min'),
              const SizedBox(width: 20),
              _infoLabel('Checkpoint Size', '${(job.checkpointSizeBytes / (1024 * 1024)).toStringAsFixed(0)} MB'),
              const SizedBox(width: 20),
              _infoLabel('Migrations', '${job.migrationCount} / ${job.maxAllowedMigrations} hops'),
              const SizedBox(width: 20),
              _infoLabel('Wasted Work', '${job.wastedComputeSeconds.toStringAsFixed(1)}s'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoLabel(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: OrbitTheme.textMuted, fontSize: 9.5)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: OrbitTheme.white, fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'monospace')),
      ],
    );
  }
}
