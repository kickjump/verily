import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_ui/verily_ui.dart';

/// Screen displaying the user's badges, total points, and leaderboard link.
class RewardsScreen extends HookConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // TODO: Fetch real rewards data from provider.
    final totalPoints = 2450;

    return Scaffold(
      appBar: AppBar(title: const Text('Rewards')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SpacingTokens.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Points total card
            VCard(
              padding: const EdgeInsets.all(SpacingTokens.lg),
              child: Column(
                children: [
                  Icon(
                    Icons.emoji_events,
                    size: 48,
                    color: ColorTokens.secondary,
                  ),
                  const SizedBox(height: SpacingTokens.sm),
                  Text(
                    '$totalPoints',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorTokens.secondary,
                    ),
                  ),
                  Text(
                    'Total Points',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SpacingTokens.md),

            // Leaderboard link
            VCard(
              onTap: () {
                // TODO: Navigate to leaderboard screen.
              },
              padding: const EdgeInsets.all(SpacingTokens.md),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: ColorTokens.tertiary.withAlpha(20),
                      borderRadius: BorderRadius.circular(RadiusTokens.sm),
                    ),
                    child: Icon(
                      Icons.leaderboard_outlined,
                      color: ColorTokens.tertiary,
                    ),
                  ),
                  const SizedBox(width: SpacingTokens.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Leaderboard',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'See how you rank against others',
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

            // Badges section header
            Row(
              children: [
                Icon(
                  Icons.military_tech_outlined,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: SpacingTokens.sm),
                Text(
                  'Badges',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: SpacingTokens.md),

            // Badges grid
            _BadgeGrid(),
          ],
        ),
      ),
    );
  }
}

/// Grid of earned and locked badges.
class _BadgeGrid extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // TODO: Replace with real badge data from provider.
    final badges = [
      _BadgeData(
        name: 'First Action',
        description: 'Complete your first action',
        icon: Icons.stars_outlined,
        color: ColorTokens.secondary,
        isEarned: true,
        earnedDate: 'Jan 5, 2026',
      ),
      _BadgeData(
        name: 'Push-Up Pro',
        description: 'Complete 10 fitness actions',
        icon: Icons.fitness_center,
        color: ColorTokens.primary,
        isEarned: true,
        earnedDate: 'Jan 12, 2026',
      ),
      _BadgeData(
        name: 'Eco Warrior',
        description: 'Complete 5 environment actions',
        icon: Icons.eco,
        color: ColorTokens.success,
        isEarned: true,
        earnedDate: 'Jan 20, 2026',
      ),
      _BadgeData(
        name: 'Community Hero',
        description: 'Help 10 community members',
        icon: Icons.groups_outlined,
        color: ColorTokens.tertiary,
        isEarned: true,
        earnedDate: 'Feb 1, 2026',
      ),
      _BadgeData(
        name: 'Streak Master',
        description: 'Complete actions 7 days in a row',
        icon: Icons.local_fire_department,
        color: ColorTokens.secondary,
        isEarned: true,
        earnedDate: 'Feb 8, 2026',
      ),
      _BadgeData(
        name: 'Explorer',
        description: 'Complete actions in 5 different locations',
        icon: Icons.explore_outlined,
        color: ColorTokens.primary,
        isEarned: true,
        earnedDate: 'Feb 14, 2026',
      ),
      _BadgeData(
        name: 'Creator',
        description: 'Create 10 actions for others',
        icon: Icons.create_outlined,
        color: ColorTokens.tertiary,
        isEarned: false,
      ),
      _BadgeData(
        name: 'Centurion',
        description: 'Complete 100 actions',
        icon: Icons.workspace_premium,
        color: ColorTokens.secondary,
        isEarned: false,
      ),
      _BadgeData(
        name: 'Perfectionist',
        description: 'Get 95%+ confidence on 10 verifications',
        icon: Icons.auto_awesome,
        color: ColorTokens.primary,
        isEarned: false,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: SpacingTokens.sm,
        mainAxisSpacing: SpacingTokens.sm,
        childAspectRatio: 0.75,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final badge = badges[index];
        return _BadgeCard(badge: badge);
      },
    );
  }
}

/// Data model for a badge.
class _BadgeData {
  const _BadgeData({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.isEarned,
    this.earnedDate,
  });

  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final bool isEarned;
  final String? earnedDate;
}

/// A single badge card in the grid.
class _BadgeCard extends HookWidget {
  const _BadgeCard({required this.badge});

  final _BadgeData badge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return VCard(
      onTap: () {
        // Show badge details in a bottom sheet
        showModalBottomSheet<void>(
          context: context,
          builder: (context) => _BadgeDetailSheet(badge: badge),
        );
      },
      padding: const EdgeInsets.all(SpacingTokens.sm),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: badge.isEarned
                  ? badge.color.withAlpha(30)
                  : colorScheme.surfaceContainerHighest,
            ),
            child: Icon(
              badge.icon,
              size: 28,
              color: badge.isEarned ? badge.color : colorScheme.outlineVariant,
            ),
          ),
          const SizedBox(height: SpacingTokens.sm),
          Text(
            badge.name,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: badge.isEarned
                  ? colorScheme.onSurface
                  : colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (!badge.isEarned) ...[
            const SizedBox(height: SpacingTokens.xs),
            Icon(
              Icons.lock_outlined,
              size: 12,
              color: colorScheme.outlineVariant,
            ),
          ],
        ],
      ),
    );
  }
}

/// Bottom sheet showing badge details.
class _BadgeDetailSheet extends HookWidget {
  const _BadgeDetailSheet({required this.badge});

  final _BadgeData badge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(SpacingTokens.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: badge.isEarned
                  ? badge.color.withAlpha(30)
                  : colorScheme.surfaceContainerHighest,
            ),
            child: Icon(
              badge.icon,
              size: 44,
              color: badge.isEarned ? badge.color : colorScheme.outlineVariant,
            ),
          ),
          const SizedBox(height: SpacingTokens.md),
          Text(
            badge.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: SpacingTokens.sm),
          Text(
            badge.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (badge.isEarned && badge.earnedDate != null) ...[
            const SizedBox(height: SpacingTokens.md),
            VBadgeChip(
              label: 'Earned ${badge.earnedDate}',
              icon: Icons.check_circle_outline,
              backgroundColor: ColorTokens.success.withAlpha(30),
              foregroundColor: ColorTokens.success,
            ),
          ],
          if (!badge.isEarned) ...[
            const SizedBox(height: SpacingTokens.md),
            VBadgeChip(label: 'Not yet earned', icon: Icons.lock_outlined),
          ],
          const SizedBox(height: SpacingTokens.lg),
        ],
      ),
    );
  }
}
