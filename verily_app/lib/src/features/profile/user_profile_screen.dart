// UuidValue is required by Serverpod's generated models.
// ignore_for_file: experimental_member_use

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/feed/feed_provider.dart';
import 'package:verily_app/src/features/profile/providers/user_profile_provider.dart';
import 'package:verily_app/src/routing/route_names.dart';
import 'package:verily_client/verily_client.dart' as vc;
import 'package:verily_ui/verily_ui.dart';

/// Screen for viewing another user's public profile.
class UserProfileScreen extends HookConsumerWidget {
  const UserProfileScreen({required this.userId, super.key});

  /// The unique identifier (or username) of the user to display.
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tabController = useTabController(initialLength: 2);
    final isFollowing = useState(false);
    final isLoadingFollow = useState(false);

    final profileAsync = ref.watch(userProfileByUsernameProvider(userId));
    final actionsAsync = ref.watch(feedActionsProvider);

    Future<void> toggleFollow() async {
      isLoadingFollow.value = true;
      try {
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

    return profileAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: Text('@$userId')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: colorScheme.error),
              const SizedBox(height: SpacingTokens.md),
              Text(
                'Failed to load profile',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.error,
                ),
              ),
              const SizedBox(height: SpacingTokens.md),
              FilledButton(
                onPressed: () =>
                    ref.invalidate(userProfileByUsernameProvider(userId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (profile) {
        if (profile == null) {
          return Scaffold(
            appBar: AppBar(title: Text('@$userId')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off_outlined,
                    size: 64,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: SpacingTokens.md),
                  Text(
                    'User not found',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final displayName = profile.displayName.isNotEmpty
            ? profile.displayName
            : profile.username;
        final initials = displayName.isNotEmpty
            ? displayName.substring(0, 1).toUpperCase()
            : 'U';

        return Scaffold(
          appBar: AppBar(
            title: Text('@${profile.username}'),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (ctx) => SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.flag_outlined),
                            title: const Text('Report user'),
                            onTap: () {
                              Navigator.of(ctx).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Report submitted.'),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.block_outlined),
                            title: const Text('Block user'),
                            onTap: () {
                              Navigator.of(ctx).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('User blocked.')),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
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
                        VAvatar(initials: initials, radius: 48),
                        const SizedBox(height: SpacingTokens.md),
                        Text(
                          displayName,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: SpacingTokens.xs),
                        Text(
                          '@${profile.username}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                          const SizedBox(height: SpacingTokens.sm),
                          Text(
                            profile.bio!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        const SizedBox(height: SpacingTokens.md),
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
                _PublicActionsTab(
                  actionsAsync: actionsAsync,
                  creatorId: profile.authUserId,
                ),
                const _PublicBadgesTab(),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Tab showing the user's public actions.
class _PublicActionsTab extends HookWidget {
  const _PublicActionsTab({
    required this.actionsAsync,
    required this.creatorId,
  });

  final AsyncValue<List<vc.Action>> actionsAsync;
  final vc.UuidValue creatorId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return actionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => Center(
        child: Text(
          'Failed to load actions',
          style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.error),
        ),
      ),
      data: (allActions) {
        final actions = allActions
            .where((a) => a.creatorId == creatorId)
            .toList();

        if (actions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: SpacingTokens.md),
                Text(
                  'No actions yet',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(SpacingTokens.md),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            final typeLabel = switch (action.actionType) {
              'one_off' => 'One-Off',
              'sequential' => 'Sequential',
              'habit' => 'Habit',
              _ => action.actionType,
            };

            return Padding(
              padding: const EdgeInsets.only(bottom: SpacingTokens.sm),
              child: VCard(
                onTap: () => context.push(
                  RouteNames.actionDetailPath.replaceFirst(
                    ':actionId',
                    '${action.id}',
                  ),
                ),
                padding: const EdgeInsets.all(SpacingTokens.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (action.tags != null && action.tags!.isNotEmpty)
                          VBadgeChip(
                            label: action.tags!.split(',').first.trim(),
                            icon: Icons.category_outlined,
                          ),
                        const Spacer(),
                        VBadgeChip(
                          label: typeLabel,
                          backgroundColor: ColorTokens.primary.withAlpha(30),
                          foregroundColor: ColorTokens.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: SpacingTokens.sm),
                    Text(
                      action.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: SpacingTokens.xs),
                    Text(
                      action.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// Tab showing the user's public badges.
class _PublicBadgesTab extends HookWidget {
  const _PublicBadgesTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
    return ColoredBox(color: color, child: tabBar);
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
