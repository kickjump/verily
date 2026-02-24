import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_ui/verily_ui.dart';

/// Screen showing the current user's profile with stats, actions, and badges.
class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tabController = useTabController(initialLength: 2);

    // TODO: Fetch real user profile from provider.

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push('/profile/edit'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(SpacingTokens.md),
                child: Column(
                  children: [
                    // Avatar
                    const VAvatar(initials: 'JD', radius: 48),
                    const SizedBox(height: SpacingTokens.md),

                    // Display name
                    Text(
                      'John Doe',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: SpacingTokens.xs),

                    // Username
                    Text(
                      '@johndoe',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: SpacingTokens.sm),

                    // Bio
                    Text(
                      'Fitness enthusiast and community builder. '
                      'Love completing real-world challenges!',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: SpacingTokens.lg),

                    // Stats bar
                    _StatsBar(),
                    const SizedBox(height: SpacingTokens.md),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                tabBar: TabBar(
                  controller: tabController,
                  tabs: const [
                    Tab(text: 'Actions'),
                    Tab(text: 'Badges'),
                  ],
                ),
                color: theme.scaffoldBackgroundColor,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: [
            // Actions tab
            _ActionsTab(),

            // Badges tab
            _BadgesTab(),
          ],
        ),
      ),
    );
  }
}

/// Displays key user statistics in a row.
class _StatsBar extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return VCard(
      padding: const EdgeInsets.symmetric(
        vertical: SpacingTokens.md,
        horizontal: SpacingTokens.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(
            count: '12',
            label: 'Created',
            icon: Icons.add_circle_outline,
          ),
          Container(width: 1, height: 32, color: colorScheme.outlineVariant),
          _StatItem(
            count: '28',
            label: 'Completed',
            icon: Icons.check_circle_outline,
          ),
          Container(width: 1, height: 32, color: colorScheme.outlineVariant),
          _StatItem(
            count: '7',
            label: 'Badges',
            icon: Icons.military_tech_outlined,
          ),
        ],
      ),
    );
  }
}

/// A single statistic display.
class _StatItem extends HookWidget {
  const _StatItem({
    required this.count,
    required this.label,
    required this.icon,
  });

  final String count;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: colorScheme.primary),
            const SizedBox(width: SpacingTokens.xs),
            Text(
              count,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: SpacingTokens.xs),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Tab showing the user's created and completed actions.
class _ActionsTab extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // TODO: Replace with real user actions from provider.
    return ListView.builder(
      padding: const EdgeInsets.all(SpacingTokens.md),
      itemCount: 8,
      itemBuilder: (context, index) {
        final isCreated = index < 4;
        return Padding(
          padding: const EdgeInsets.only(bottom: SpacingTokens.sm),
          child: VCard(
            onTap: () => context.push('/actions/$index'),
            padding: const EdgeInsets.all(SpacingTokens.md),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isCreated
                        ? ColorTokens.primary.withAlpha(20)
                        : ColorTokens.success.withAlpha(20),
                    borderRadius: BorderRadius.circular(RadiusTokens.sm),
                  ),
                  child: Icon(
                    isCreated ? Icons.edit_note : Icons.task_alt,
                    color: isCreated
                        ? ColorTokens.primary
                        : ColorTokens.success,
                  ),
                ),
                const SizedBox(width: SpacingTokens.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isCreated
                            ? 'Action created #${index + 1}'
                            : 'Action completed #${index - 3}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.xs),
                      VBadgeChip(
                        label: isCreated ? 'Created' : 'Completed',
                        backgroundColor: isCreated
                            ? ColorTokens.primary.withAlpha(30)
                            : ColorTokens.success.withAlpha(30),
                        foregroundColor: isCreated
                            ? ColorTokens.primary
                            : ColorTokens.success,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Tab showing the user's earned badges.
class _BadgesTab extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // TODO: Replace with real badges from provider.
    final badges = [
      ('First Action', Icons.stars_outlined, ColorTokens.secondary),
      ('Push-Up Pro', Icons.fitness_center, ColorTokens.primary),
      ('Eco Warrior', Icons.eco, ColorTokens.success),
      ('Community Hero', Icons.groups_outlined, ColorTokens.tertiary),
      ('Streak Master', Icons.local_fire_department, ColorTokens.secondary),
      ('Explorer', Icons.explore_outlined, ColorTokens.primary),
      ('Locked', Icons.lock_outlined, colorScheme.outlineVariant),
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(SpacingTokens.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: SpacingTokens.sm,
        mainAxisSpacing: SpacingTokens.sm,
        childAspectRatio: 0.85,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final (name, icon, color) = badges[index];
        final isLocked = name == 'Locked';

        return VCard(
          padding: const EdgeInsets.all(SpacingTokens.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withAlpha(isLocked ? 15 : 30),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: isLocked ? colorScheme.outlineVariant : color,
                ),
              ),
              const SizedBox(height: SpacingTokens.sm),
              Text(
                name,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isLocked
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Delegate for pinning the tab bar in the sliver layout.
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  _TabBarDelegate({required this.tabBar, required this.color});

  final TabBar tabBar;
  final Color color;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: color, child: tabBar);
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar || color != oldDelegate.color;
  }
}
