import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/actions/providers/action_detail_provider.dart';
import 'package:verily_app/src/routing/route_names.dart';
import 'package:verily_client/verily_client.dart' as vc;
import 'package:verily_ui/verily_ui.dart';

/// Screen showing the full details of an action.
class ActionDetailScreen extends HookConsumerWidget {
  const ActionDetailScreen({required this.actionId, super.key});

  /// The unique identifier of the action to display.
  final String actionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final parsedId = int.tryParse(actionId);

    if (parsedId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Action Details')),
        body: const Center(child: Text('Invalid action ID')),
      );
    }

    final actionAsync = ref.watch(actionDetailProvider(parsedId));

    return actionAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Action Details')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Action Details')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: colorScheme.error),
              const SizedBox(height: SpacingTokens.md),
              Text('Failed to load action', style: theme.textTheme.titleMedium),
              const SizedBox(height: SpacingTokens.md),
              FilledButton(
                onPressed: () => ref.invalidate(actionDetailProvider(parsedId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (action) => _ActionDetailBody(action: action, actionId: actionId),
    );
  }
}

class _ActionDetailBody extends HookWidget {
  const _ActionDetailBody({required this.action, required this.actionId});

  final vc.Action action;
  final String actionId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final typeLabel = switch (action.actionType) {
      'one_off' => 'One-Off',
      'sequential' => 'Sequential',
      'habit' => 'Habit',
      _ => action.actionType,
    };
    final typeColor = action.actionType == 'one_off'
        ? ColorTokens.primary
        : ColorTokens.tertiary;

    final criteria = action.verificationCriteria
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .map((line) => line.replaceFirst(RegExp(r'^[-•]\s*'), ''))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Action Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () async {
              final link = 'https://verily.fun/action/$actionId';
              await Clipboard.setData(ClipboardData(text: link));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Link copied to clipboard')),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SpacingTokens.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category and type badges
            Row(
              children: [
                if (action.tags != null && action.tags!.isNotEmpty) ...[
                  VBadgeChip(
                    label: action.tags!.split(',').first.trim(),
                    icon: Icons.category_outlined,
                  ),
                  const SizedBox(width: SpacingTokens.sm),
                ],
                VBadgeChip(
                  label: typeLabel,
                  backgroundColor: typeColor.withAlpha(30),
                  foregroundColor: typeColor,
                ),
                const Spacer(),
                VBadgeChip(
                  label: action.status.replaceFirst(
                    action.status[0],
                    action.status[0].toUpperCase(),
                  ),
                  icon: action.status == 'active'
                      ? Icons.check_circle_outline
                      : Icons.info_outline,
                  backgroundColor: action.status == 'active'
                      ? ColorTokens.success.withAlpha(30)
                      : colorScheme.surfaceContainerHighest,
                  foregroundColor: action.status == 'active'
                      ? ColorTokens.success
                      : colorScheme.onSurfaceVariant,
                ),
              ],
            ),
            const SizedBox(height: SpacingTokens.md),

            // Title
            Text(
              action.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: SpacingTokens.sm),

            // Description
            Text(
              action.description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: SpacingTokens.lg),

            // Verification criteria section
            const _SectionHeader(
              icon: Icons.verified_outlined,
              title: 'Verification Criteria',
            ),
            const SizedBox(height: SpacingTokens.sm),
            VCard(
              padding: const EdgeInsets.all(SpacingTokens.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < criteria.length; i++) ...[
                    if (i > 0) const SizedBox(height: SpacingTokens.sm),
                    _CriterionRow(text: criteria[i]),
                  ],
                ],
              ),
            ),
            const SizedBox(height: SpacingTokens.lg),

            // Location section (if available)
            if (action.locationId != null) ...[
              const _SectionHeader(
                icon: Icons.location_on_outlined,
                title: 'Location',
              ),
              const SizedBox(height: SpacingTokens.sm),
              VCard(
                padding: const EdgeInsets.all(SpacingTokens.md),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(RadiusTokens.sm),
                      ),
                      child: Icon(
                        Icons.map_outlined,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(width: SpacingTokens.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location set',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (action.locationRadius != null)
                            Text(
                              'Within ${action.locationRadius!.round()}m radius',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SpacingTokens.lg),
            ],

            // Tags
            if (action.tags != null && action.tags!.isNotEmpty) ...[
              const _SectionHeader(icon: Icons.label_outline, title: 'Tags'),
              const SizedBox(height: SpacingTokens.sm),
              Wrap(
                spacing: SpacingTokens.sm,
                runSpacing: SpacingTokens.sm,
                children: action.tags!
                    .split(',')
                    .map(
                      (tag) => Chip(
                        label: Text(tag.trim()),
                        visualDensity: VisualDensity.compact,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: SpacingTokens.lg),
            ],

            // Action metadata
            VCard(
              padding: const EdgeInsets.all(SpacingTokens.md),
              child: Column(
                children: [
                  if (action.maxPerformers != null)
                    _MetadataRow(
                      label: 'Max Performers',
                      value: '${action.maxPerformers}',
                    ),
                  if (action.totalSteps != null && action.totalSteps! > 1) ...[
                    const SizedBox(height: SpacingTokens.sm),
                    _MetadataRow(
                      label: 'Total Steps',
                      value: '${action.totalSteps}',
                    ),
                  ],
                  if (action.habitDurationDays != null) ...[
                    const SizedBox(height: SpacingTokens.sm),
                    _MetadataRow(
                      label: 'Duration',
                      value: '${action.habitDurationDays} days',
                    ),
                  ],
                  if (action.habitFrequencyPerWeek != null) ...[
                    const SizedBox(height: SpacingTokens.sm),
                    _MetadataRow(
                      label: 'Frequency',
                      value: '${action.habitFrequencyPerWeek}x per week',
                    ),
                  ],
                  const SizedBox(height: SpacingTokens.sm),
                  _MetadataRow(
                    label: 'Created',
                    value: _formatDate(action.createdAt),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SpacingTokens.xxl),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(SpacingTokens.md),
          child: VFilledButton(
            onPressed: () => context.push(
              RouteNames.videoRecordingPath.replaceFirst(':actionId', actionId),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.videocam_outlined),
                SizedBox(width: SpacingTokens.sm),
                Text('Submit Video'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

/// A section header with an icon and title.
class _SectionHeader extends HookWidget {
  const _SectionHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: SpacingTokens.sm),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// A row displaying a single verification criterion with a check icon.
class _CriterionRow extends HookWidget {
  const _CriterionRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle_outline,
          size: 18,
          color: ColorTokens.success,
        ),
        const SizedBox(width: SpacingTokens.sm),
        Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
      ],
    );
  }
}

/// A row displaying a label-value metadata pair.
class _MetadataRow extends HookWidget {
  const _MetadataRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
