import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_ui/verily_ui.dart';

/// Screen for viewing another user's public profile.
class UserProfileScreen extends HookConsumerWidget {
  const UserProfileScreen({required this.userId, super.key});

  /// The unique identifier of the user to display.
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tabController = useTabController(initialLength: 2);
    final isFollowing = useState(false);
    final isLoadingFollow = useState(false);

    // TODO: Fetch real user profile from provider using userId.

    Future<void> toggleFollow() async {
      isLoadingFollow.value = true;
      try {
        // TODO: Follow/unfollow via Serverpod.
        await Future<void>.delayed(const Duration(milliseconds: 500));
        isFollowing.value = !isFollowing.value;
      } on Exception {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Action failed. Please try again.')),
          );
        }
      } finally {
        isLoadingFollow.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('@user_$userId'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Show report / block options.
            },
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
                    VAvatar(
                      initials: 'U${userId.characters.first.toUpperCase()}',
                      radius: 48,
                    ),
                    const SizedBox(height: SpacingTokens.md),

                    // Display name
                    Text(
                      'User $userId',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: SpacingTokens.xs),

                    // Username
                    Text(
                      '@user_$userId',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: SpacingTokens.sm),

                    // Bio
                    Text(
                      'Passionate about completing challenges '
                      'and helping the community grow.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: SpacingTokens.md),

                    // Follow button
                    SizedBox(
                      width: 180,
                      child: isFollowing.value
                          ? VOutlinedButton(
                              onPressed: isLoadingFollow.value
                                  ? null
                                  : toggleFollow,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check, size: 18),
                                  SizedBox(width: SpacingTokens.xs),
                                  Text('Following'),
                                ],
                              ),
                            )
                          : VFilledButton(
                              isLoading: isLoadingFollow.value,
                              onPressed: isLoadingFollow.value
                                  ? null
                                  : toggleFollow,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.person_add_outlined, size: 18),
                                  SizedBox(width: SpacingTokens.xs),
                                  Text('Follow'),
                                ],
                              ),
                            ),
                    ),
                    const SizedBox(height: SpacingTokens.lg),

                    // Stats row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _UserStatItem(count: '156', label: 'Followers'),
                        _UserStatItem(count: '89', label: 'Following'),
                        _UserStatItem(count: '34', label: 'Actions'),
                      ],
                    ),
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
            // Public actions
            _PublicActionsTab(),

            // Public badges
            _PublicBadgesTab(),
          ],
        ),
      ),
    );
  }
}

/// Displays a user statistic.
class _UserStatItem extends HookWidget {
  const _UserStatItem({required this.count, required this.label});

  final String count;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Text(
          count,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
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

/// Tab showing the user's public actions.
class _PublicActionsTab extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // TODO: Replace with real data from provider.
    return ListView.builder(
      padding: const EdgeInsets.all(SpacingTokens.md),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: SpacingTokens.sm),
          child: VCard(
            onTap: () => context.push('/actions/$index'),
            padding: const EdgeInsets.all(SpacingTokens.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    VBadgeChip(label: 'Fitness', icon: Icons.category_outlined),
                    const Spacer(),
                    VBadgeChip(
                      label: 'Completed',
                      backgroundColor: ColorTokens.success.withAlpha(30),
                      foregroundColor: ColorTokens.success,
                      icon: Icons.check_circle_outline,
                    ),
                  ],
                ),
                const SizedBox(height: SpacingTokens.sm),
                Text(
                  'Public action #${index + 1}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: SpacingTokens.xs),
                Text(
                  'Completed this challenge and earned rewards.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Tab showing the user's public badges.
class _PublicBadgesTab extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // TODO: Replace with real data from provider.
    final badges = [
      ('First Action', Icons.stars_outlined, ColorTokens.secondary),
      ('Team Player', Icons.groups_outlined, ColorTokens.tertiary),
      ('Explorer', Icons.explore_outlined, ColorTokens.primary),
      ('Eco Warrior', Icons.eco, ColorTokens.success),
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
                  color: color.withAlpha(30),
                ),
                child: Icon(icon, size: 28, color: color),
              ),
              const SizedBox(height: SpacingTokens.sm),
              Text(
                name,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
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
