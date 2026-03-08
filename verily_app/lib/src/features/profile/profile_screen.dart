import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/l10n/generated/app_localizations.dart';
import 'package:verily_app/src/features/profile/providers/creator_actions_provider.dart';
import 'package:verily_app/src/features/profile/providers/rewards_provider.dart';
import 'package:verily_app/src/features/profile/providers/user_profile_provider.dart';
import 'package:verily_app/src/routing/route_names.dart';
import 'package:verily_client/verily_client.dart' as vc;
import 'package:verily_ui/verily_ui.dart';

/// Screen showing the current user's profile with stats, actions, and badges.
class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tabController = useTabController(initialLength: 2);
    final profileAsync = ref.watch(currentUserProfileProvider);

    return profileAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: Text(l10n.profileTitle)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: Text(l10n.profileTitle)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: SpacingTokens.md),
              Text(l10n.profileLoadFailed, style: theme.textTheme.titleMedium),
              const SizedBox(height: SpacingTokens.md),
              FilledButton(
                onPressed: () => ref.invalidate(currentUserProfileProvider),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ),
      data: (profile) =>
          _ProfileBody(profile: profile, tabController: tabController),
    );
  }
}

class _ProfileBody extends HookConsumerWidget {
  const _ProfileBody({required this.profile, required this.tabController});

  final vc.UserProfile profile;
  final TabController tabController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final actionsAsync = ref.watch(creatorActionsProvider);
    final rewardsAsync = ref.watch(userRewardsProvider);
    final isDark = theme.brightness == Brightness.dark;

    final initials = profile.displayName
        .split(' ')
        .take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push(RouteNames.editProfilePath),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(RouteNames.settingsPath),
          ),
        ],
      ),
      body: Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: isDark
                  ? GradientTokens.shellBackground
                  : GradientTokens.shellBackgroundLight,
            ),
            child: const SizedBox.expand(),
          ),
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(SpacingTokens.md),
                    child: Column(
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              RadiusTokens.xl,
                            ),
                            gradient: isDark
                                ? GradientTokens.heroCard
                                : GradientTokens.heroCardLight,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF142F5D,
                                ).withValues(alpha: isDark ? 0.3 : 0.2),
                                blurRadius: 22,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(SpacingTokens.lg),
                            child: Column(
                              children: [
                                VAvatar(initials: initials, radius: 48),
                                const SizedBox(height: SpacingTokens.md),
                                Text(
                                  profile.displayName,
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : ColorTokens.ink,
                                      ),
                                ),
                                const SizedBox(height: SpacingTokens.xs),
                                Text(
                                  '@${profile.username}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.86)
                                        : ColorTokens.ink.withValues(
                                            alpha: 0.72,
                                          ),
                                  ),
                                ),
                                if (profile.bio != null &&
                                    profile.bio!.isNotEmpty) ...[
                                  const SizedBox(height: SpacingTokens.sm),
                                  Text(
                                    profile.bio!,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.9)
                                          : ColorTokens.ink.withValues(
                                              alpha: 0.72,
                                            ),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: SpacingTokens.lg),
                        _StatsBar(
                          actionsAsync: actionsAsync,
                          rewardsAsync: rewardsAsync,
                        ),
                        const SizedBox(height: SpacingTokens.md),
                        VCard(
                          onTap: () => context.push(RouteNames.walletPath),
                          padding: const EdgeInsets.symmetric(
                            horizontal: SpacingTokens.md,
                            vertical: SpacingTokens.sm,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    RadiusTokens.sm,
                                  ),
                                  color: colorScheme.primaryContainer,
                                ),
                                child: Icon(
                                  Icons.account_balance_wallet_outlined,
                                  color: colorScheme.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: SpacingTokens.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.walletTitle,
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    Text(
                                      l10n.profileWalletSubtitle,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right),
                            ],
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
                      tabs: [
                        Tab(text: l10n.profileActionsTab),
                        Tab(text: l10n.badges),
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
                _ActionsTab(actionsAsync: actionsAsync),
                _BadgesTab(rewardsAsync: rewardsAsync),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays key user statistics in a row.
class _StatsBar extends HookWidget {
  const _StatsBar({required this.actionsAsync, required this.rewardsAsync});

  final AsyncValue<List<vc.Action>> actionsAsync;
  final AsyncValue<List<vc.UserReward>> rewardsAsync;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final actionCount = actionsAsync.whenOrNull(data: (a) => a.length) ?? 0;
    final rewardCount = rewardsAsync.whenOrNull(data: (r) => r.length) ?? 0;

    return VCard(
      padding: const EdgeInsets.symmetric(
        vertical: SpacingTokens.md,
        horizontal: SpacingTokens.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(
            count: '$actionCount',
            label: l10n.profileActionsTab,
            icon: Icons.add_circle_outline,
          ),
          Container(width: 1, height: 32, color: colorScheme.outlineVariant),
          _StatItem(
            count: '$rewardCount',
            label: l10n.rewardsTitle,
            icon: Icons.emoji_events_outlined,
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

/// Tab showing the user's created actions.
class _ActionsTab extends HookWidget {
  const _ActionsTab({required this.actionsAsync});

  final AsyncValue<List<vc.Action>> actionsAsync;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return actionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => Center(
        child: Text(
          l10n.profileActionsLoadFailed,
          style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.error),
        ),
      ),
      data: (actions) {
        if (actions.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.lg),
              child: VCard(
                padding: const EdgeInsets.all(SpacingTokens.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 64,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: SpacingTokens.md),
                    Text(
                      l10n.profileNoActionsYet,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(SpacingTokens.md),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            final statusLabel = switch (action.status) {
              'active' => l10n.profileActionStatusActive,
              'completed' => l10n.profileActionStatusCompleted,
              'closed' => l10n.profileActionStatusClosed,
              _ => action.status.replaceFirst(
                action.status[0],
                action.status[0].toUpperCase(),
              ),
            };

            return RepaintBoundary(
              key: ValueKey(action.id),
              child: Padding(
                padding: const EdgeInsets.only(bottom: SpacingTokens.sm),
                child: VCard(
                  onTap: () => context.push(
                    RouteNames.actionDetailPath.replaceFirst(
                      ':actionId',
                      '${action.id}',
                    ),
                  ),
                  padding: const EdgeInsets.all(SpacingTokens.md),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: ColorTokens.primary.withAlpha(20),
                          borderRadius: BorderRadius.circular(RadiusTokens.sm),
                        ),
                        child: const Icon(
                          Icons.assignment_outlined,
                          color: ColorTokens.primary,
                        ),
                      ),
                      const SizedBox(width: SpacingTokens.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              action.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: SpacingTokens.xs),
                            VBadgeChip(
                              label: statusLabel,
                              backgroundColor: action.status == 'active'
                                  ? ColorTokens.success.withAlpha(30)
                                  : colorScheme.surfaceContainerHighest,
                              foregroundColor: action.status == 'active'
                                  ? ColorTokens.success
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: action.id == null
                            ? null
                            : () => context.push(
                                RouteNames.videoRecordingPath.replaceFirst(
                                  ':actionId',
                                  '${action.id}',
                                ),
                              ),
                        child: Text(l10n.profileCompleteActionCta),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// Tab showing the user's earned rewards.
class _BadgesTab extends HookWidget {
  const _BadgesTab({required this.rewardsAsync});

  final AsyncValue<List<vc.UserReward>> rewardsAsync;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return rewardsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => Center(
        child: Text(
          l10n.profileRewardsLoadFailed,
          style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.error),
        ),
      ),
      data: (rewards) {
        if (rewards.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.lg),
              child: VCard(
                padding: const EdgeInsets.all(SpacingTokens.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.military_tech_outlined,
                      size: 64,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: SpacingTokens.md),
                    Text(
                      l10n.profileNoRewardsYet,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: SpacingTokens.xs),
                    Text(
                      l10n.profileNoRewardsSubtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(SpacingTokens.md),
          itemCount: rewards.length,
          itemBuilder: (context, index) {
            final reward = rewards[index];
            return RepaintBoundary(
              key: ValueKey(reward.id),
              child: Padding(
                padding: const EdgeInsets.only(bottom: SpacingTokens.sm),
                child: VCard(
                  padding: const EdgeInsets.all(SpacingTokens.md),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorTokens.secondary.withAlpha(30),
                        ),
                        child: const Icon(
                          Icons.emoji_events_outlined,
                          color: ColorTokens.secondary,
                        ),
                      ),
                      const SizedBox(width: SpacingTokens.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.profileRewardNumber(reward.rewardId),
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: SpacingTokens.xs),
                            Text(
                              l10n.profileRewardEarnedDate(
                                MaterialLocalizations.of(
                                  context,
                                ).formatMediumDate(reward.earnedAt),
                              ),
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
              ),
            );
          },
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
