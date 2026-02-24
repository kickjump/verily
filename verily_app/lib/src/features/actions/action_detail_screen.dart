import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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

    // TODO: Fetch real action data from provider using actionId.
    final isLoading = useState(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Action Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              // TODO: Share action link.
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Show action options menu.
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
                const VBadgeChip(
                  label: 'Fitness',
                  icon: Icons.category_outlined,
                ),
                const SizedBox(width: SpacingTokens.sm),
                VBadgeChip(
                  label: 'One-Off',
                  backgroundColor: ColorTokens.primary.withAlpha(30),
                  foregroundColor: ColorTokens.primary,
                ),
                const Spacer(),
                VBadgeChip(
                  label: 'Active',
                  icon: Icons.check_circle_outline,
                  backgroundColor: ColorTokens.success.withAlpha(30),
                  foregroundColor: ColorTokens.success,
                ),
              ],
            ),
            const SizedBox(height: SpacingTokens.md),

            // Title
            Text(
              'Do 20 push-ups in the park',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: SpacingTokens.sm),

            // Description
            Text(
              'Record yourself doing 20 push-ups in a public park. '
              'The video must clearly show your full body and the park '
              'environment. AI will verify your form and count.',
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
            const VCard(
              padding: EdgeInsets.all(SpacingTokens.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CriterionRow(
                    text: 'Full body visible in frame during all push-ups',
                  ),
                  SizedBox(height: SpacingTokens.sm),
                  _CriterionRow(text: 'Must complete 20 consecutive push-ups'),
                  SizedBox(height: SpacingTokens.sm),
                  _CriterionRow(
                    text: 'Park environment clearly visible in background',
                  ),
                  SizedBox(height: SpacingTokens.sm),
                  _CriterionRow(
                    text:
                        'Proper push-up form (chest to ground, full extension)',
                  ),
                ],
              ),
            ),
            const SizedBox(height: SpacingTokens.lg),

            // Location section
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
                          'Central Park',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Within 500m radius',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
            const SizedBox(height: SpacingTokens.lg),

            // Rewards section
            const _SectionHeader(
              icon: Icons.emoji_events_outlined,
              title: 'Rewards',
            ),
            const SizedBox(height: SpacingTokens.sm),
            const VCard(
              padding: EdgeInsets.all(SpacingTokens.md),
              child: Column(
                children: [
                  _RewardRow(
                    icon: Icons.star,
                    iconColor: ColorTokens.secondary,
                    title: '100 Points',
                    subtitle: 'Awarded upon verification',
                  ),
                  Divider(height: SpacingTokens.lg),
                  _RewardRow(
                    icon: Icons.military_tech,
                    iconColor: ColorTokens.tertiary,
                    title: 'Push-Up Champion',
                    subtitle: 'Badge earned for completing this action',
                  ),
                ],
              ),
            ),
            const SizedBox(height: SpacingTokens.lg),

            // Creator info section
            const _SectionHeader(
              icon: Icons.person_outline,
              title: 'Created By',
            ),
            const SizedBox(height: SpacingTokens.sm),
            VCard(
              onTap: () => context.push('/profile/user/creator_1'),
              padding: const EdgeInsets.all(SpacingTokens.md),
              child: Row(
                children: [
                  const VAvatar(initials: 'JD', radius: 20),
                  const SizedBox(width: SpacingTokens.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Doe',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '@johndoe',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
            const SizedBox(height: SpacingTokens.lg),

            // Action metadata
            const VCard(
              padding: EdgeInsets.all(SpacingTokens.md),
              child: Column(
                children: [
                  _MetadataRow(label: 'Max Performers', value: '50'),
                  SizedBox(height: SpacingTokens.sm),
                  _MetadataRow(label: 'Completed', value: '12 / 50'),
                  SizedBox(height: SpacingTokens.sm),
                  _MetadataRow(label: 'Created', value: 'Jan 15, 2026'),
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
            isLoading: isLoading.value,
            onPressed: () => context.push('/submissions/record/$actionId'),
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

/// A row displaying reward information.
class _RewardRow extends HookWidget {
  const _RewardRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 28),
        const SizedBox(width: SpacingTokens.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
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
