import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/actions/providers/active_action_provider.dart';
import 'package:verily_app/src/features/feed/feed_provider.dart';
import 'package:verily_app/src/routing/route_names.dart';
import 'package:verily_client/verily_client.dart' as vc;
import 'package:verily_ui/verily_ui.dart';

/// Primary home experience with personalized action discovery.
class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedFilter = useState('Nearby');
    final safeBottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final scrollBottomClearance = 128.0 + safeBottomInset;
    final activeAction = ref.watch(activeActionControllerProvider);
    final activeActionController = ref.read(
      activeActionControllerProvider.notifier,
    );
    final activeDistanceProgress = activeAction == null
        ? 0.0
        : _locationProgressFromDistance(activeAction.distanceFromNextLocation);

    final actionsAsync = ref.watch(feedActionsProvider);

    const filters = ['Nearby', 'Quick', 'High Reward'];

    final isDark = theme.brightness == Brightness.dark;
    final onBackground = isDark ? Colors.white : ColorTokens.ink;
    final onBackgroundMuted = isDark
        ? Colors.white.withValues(alpha: 0.88)
        : ColorTokens.ink.withValues(alpha: 0.7);
    final glassColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.white.withValues(alpha: 0.7);
    final glassBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.2)
        : ColorTokens.primary.withValues(alpha: 0.12);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                SpacingTokens.lg,
                SpacingTokens.xxl,
                SpacingTokens.lg,
                SpacingTokens.md,
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(RadiusTokens.sm),
                      color: glassColor,
                      border: Border.all(color: glassBorderColor),
                    ),
                    child: Icon(Icons.verified_outlined, color: onBackground),
                  ),
                  const SizedBox(width: SpacingTokens.sm),
                  Expanded(
                    child: Text(
                      'Verily Missions',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: onBackground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SpacingTokens.sm,
                      vertical: SpacingTokens.xs,
                    ),
                    decoration: BoxDecoration(
                      color: glassColor,
                      borderRadius: BorderRadius.circular(RadiusTokens.xl),
                      border: Border.all(color: glassBorderColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.place_outlined,
                          color: onBackground,
                          size: 14,
                        ),
                        const SizedBox(width: SpacingTokens.xs),
                        Text(
                          'Nearby',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: onBackground,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                SpacingTokens.lg,
                0,
                SpacingTokens.lg,
                SpacingTokens.md,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: isDark
                      ? GradientTokens.heroCard
                      : GradientTokens.heroCardLight,
                  borderRadius: BorderRadius.circular(RadiusTokens.xl),
                  border: Border.all(color: glassBorderColor),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? const Color(0x44142E56)
                          : const Color(0x22142E56),
                      blurRadius: 30,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(SpacingTokens.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: SpacingTokens.sm,
                              vertical: SpacingTokens.xs,
                            ),
                            decoration: BoxDecoration(
                              color: glassColor,
                              borderRadius: BorderRadius.circular(
                                RadiusTokens.xl,
                              ),
                              border: Border.all(color: glassBorderColor),
                            ),
                            child: Text(
                              'Tonight',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: onBackground,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.bolt_rounded,
                            color: isDark
                                ? const Color(0xFFFFD447)
                                : ColorTokens.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: SpacingTokens.md),
                      Text(
                        'Ready to verify in the real world?',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: onBackground,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.sm),
                      Text(
                        'Complete actions nearby and earn rewards after AI review.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: onBackgroundMuted,
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.lg),
                      Row(
                        children: [
                          _StatPill(
                            label: 'Available',
                            value: actionsAsync.when(
                              data: (actions) => '${actions.length}',
                              loading: () => '...',
                              error: (_, __) => '0',
                            ),
                          ),
                          const SizedBox(width: SpacingTokens.sm),
                          const _StatPill(label: 'Streak', value: '0 days'),
                        ],
                      ),
                      const SizedBox(height: SpacingTokens.md),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: SpacingTokens.md,
                          vertical: SpacingTokens.sm,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.18)
                              : Colors.white.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(RadiusTokens.md),
                          border: Border.all(color: glassBorderColor),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.near_me_outlined,
                              color: onBackground,
                              size: 18,
                            ),
                            const SizedBox(width: SpacingTokens.xs),
                            Expanded(
                              child: Text(
                                actionsAsync.when(
                                  data: (actions) =>
                                      '${actions.length} active actions available',
                                  loading: () => 'Loading actions...',
                                  error: (_, __) => 'Could not load actions',
                                ),
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: onBackgroundMuted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                SpacingTokens.lg,
                0,
                SpacingTokens.lg,
                SpacingTokens.md,
              ),
              child: Wrap(
                spacing: SpacingTokens.sm,
                runSpacing: SpacingTokens.sm,
                children: [
                  for (final filter in filters)
                    ChoiceChip(
                      label: Text(filter),
                      selected: selectedFilter.value == filter,
                      showCheckmark: false,
                      labelStyle: theme.textTheme.labelMedium?.copyWith(
                        color: selectedFilter.value == filter
                            ? theme.colorScheme.onSecondary
                            : onBackground,
                        fontWeight: FontWeight.w700,
                      ),
                      backgroundColor: glassColor,
                      selectedColor: theme.colorScheme.secondary,
                      side: BorderSide(
                        color: selectedFilter.value == filter
                            ? theme.colorScheme.secondary
                            : glassBorderColor,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(RadiusTokens.md),
                      ),
                      onSelected: (_) {
                        selectedFilter.value = filter;
                        final feedFilter = switch (filter) {
                          'Quick' => FeedFilter.quick,
                          'High Reward' => FeedFilter.highReward,
                          _ => FeedFilter.nearby,
                        };
                        ref
                            .read(feedFilterProvider.notifier)
                            .select(feedFilter);
                      },
                    ),
                ],
              ),
            ),
          ),
          if (activeAction != null)
            SliverToBoxAdapter(
              child: VCard(
                key: const Key('home_activeActionCard'),
                margin: const EdgeInsets.fromLTRB(
                  SpacingTokens.lg,
                  0,
                  SpacingTokens.lg,
                  SpacingTokens.md,
                ),
                padding: const EdgeInsets.all(SpacingTokens.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              RadiusTokens.sm,
                            ),
                            color: theme.colorScheme.primaryContainer,
                          ),
                          child: Icon(
                            Icons.track_changes_outlined,
                            color: theme.colorScheme.primary,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: SpacingTokens.sm),
                        Expanded(
                          child: Text(
                            'Active Action',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: activeActionController.clear,
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                    Text(
                      activeAction.title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: SpacingTokens.sm),
                    Row(
                      children: [
                        const Icon(Icons.near_me_outlined, size: 18),
                        const SizedBox(width: SpacingTokens.xs),
                        Expanded(
                          child: Text(
                            '${activeAction.distanceFromNextLocation} to ${activeAction.nextLocationLabel}',
                            style: theme.textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: SpacingTokens.sm),
                    Text(
                      'Check-in progress',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: SpacingTokens.xs),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(RadiusTokens.sm),
                      child: LinearProgressIndicator(
                        minHeight: 9,
                        value: activeDistanceProgress,
                        backgroundColor: const Color(0xFFDDE7FF),
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: SpacingTokens.xs),
                    Text(
                      '${(activeDistanceProgress * 100).round()}% of route completed',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: SpacingTokens.md),
                    Text(
                      'Verify at location',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: SpacingTokens.xs),
                    for (final item in activeAction.verificationChecklist.take(
                      3,
                    ))
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: SpacingTokens.xs,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: SpacingTokens.xs),
                            Expanded(
                              child: Text(
                                item,
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: SpacingTokens.sm),
                    VFilledButton(
                      key: const Key('home_openVerificationButton'),
                      onPressed: () =>
                          context.push(RouteNames.verifyCapturePath),
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.verified_outlined, size: 18),
                            SizedBox(width: SpacingTokens.xs),
                            Text('Open Verification'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Featured actions carousel — from server data
          actionsAsync.when(
            loading: () => const SliverToBoxAdapter(
              child: SizedBox(
                height: 236,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            error: (_, __) =>
                const SliverToBoxAdapter(child: SizedBox(height: 236)),
            data: (actions) => SliverToBoxAdapter(
              child: SizedBox(
                height: 236,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SpacingTokens.lg,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final action = actions[index];
                    final isActive = activeAction?.actionId == '${action.id}';
                    return RepaintBoundary(
                      key: ValueKey('featured_${action.id}'),
                      child: _FeaturedActionCard(
                        action: action,
                        isActive: isActive,
                        onToggleActive: () {
                          final criteria = action.verificationCriteria
                              .split('\n')
                              .where((l) => l.trim().isNotEmpty)
                              .map(
                                (l) => l.replaceFirst(RegExp(r'^[-•]\s*'), ''),
                              )
                              .toList();
                          activeActionController.toggle(
                            ActiveAction(
                              actionId: '${action.id}',
                              title: action.title,
                              nextLocationLabel: 'Nearby',
                              distanceFromNextLocation: 'Nearby',
                              verificationChecklist: criteria,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: SpacingTokens.md),
                  itemCount: actions.length.clamp(0, 5),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                SpacingTokens.lg,
                SpacingTokens.lg,
                SpacingTokens.lg,
                SpacingTokens.sm,
              ),
              child: Text(
                'All actions',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: onBackground,
                ),
              ),
            ),
          ),
          // List of all actions — from server data
          actionsAsync.when(
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(SpacingTokens.lg),
                  child: FilledButton(
                    onPressed: () => ref.invalidate(feedActionsProvider),
                    child: const Text('Retry'),
                  ),
                ),
              ),
            ),
            data: (actions) => SliverList.builder(
              itemCount: actions.length,
              itemBuilder: (context, index) {
                final action = actions[index];
                final isActive = activeAction?.actionId == '${action.id}';
                final typeLabel = switch (action.actionType) {
                  'one_off' => 'One-Off',
                  'sequential' => 'Sequential',
                  'habit' => 'Habit',
                  _ => action.actionType,
                };
                return RepaintBoundary(
                  key: ValueKey('list_${action.id}'),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      SpacingTokens.lg,
                      0,
                      SpacingTokens.lg,
                      SpacingTokens.sm,
                    ),
                    child: VCard(
                      onTap: () {
                        context.push(
                          RouteNames.actionDetailPath.replaceFirst(
                            ':actionId',
                            '${action.id}',
                          ),
                        );
                      },
                      padding: const EdgeInsets.all(SpacingTokens.md),
                      child: Row(
                        children: [
                          const DecoratedBox(
                            decoration: _actionIconDecoration,
                            child: SizedBox(
                              width: 44,
                              height: 44,
                              child: Icon(
                                Icons.verified_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: SpacingTokens.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  action.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: SpacingTokens.xs),
                                Text(
                                  '${action.tags?.split(',').first.trim() ?? typeLabel} • ${"Anywhere"}',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: SpacingTokens.sm),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              VBadgeChip(label: typeLabel),
                              const SizedBox(height: SpacingTokens.xs),
                              TextButton.icon(
                                key: Key('home_list_setActive_${action.id}'),
                                onPressed: () {
                                  final criteria = action.verificationCriteria
                                      .split('\n')
                                      .where((l) => l.trim().isNotEmpty)
                                      .map(
                                        (l) => l.replaceFirst(
                                          RegExp(r'^[-•]\s*'),
                                          '',
                                        ),
                                      )
                                      .toList();
                                  activeActionController.toggle(
                                    ActiveAction(
                                      actionId: '${action.id}',
                                      title: action.title,
                                      nextLocationLabel: 'Nearby',
                                      distanceFromNextLocation: 'Nearby',
                                      verificationChecklist: criteria,
                                    ),
                                  );
                                },
                                icon: Icon(
                                  isActive
                                      ? Icons.check_circle
                                      : Icons
                                            .playlist_add_check_circle_outlined,
                                  size: 16,
                                ),
                                label: Text(isActive ? 'Active' : 'Set Active'),
                                style: TextButton.styleFrom(
                                  foregroundColor: isActive
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurfaceVariant,
                                  backgroundColor: isActive
                                      ? theme.colorScheme.primaryContainer
                                            .withValues(alpha: 0.42)
                                      : theme
                                            .colorScheme
                                            .surfaceContainerHighest
                                            .withValues(alpha: 0.55),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      RadiusTokens.md,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.lg),
              child: VOutlinedButton(
                onPressed: () => context.push(RouteNames.searchPath),
                child: const Text('Browse more actions'),
              ),
            ),
          ),

          // Create action CTA
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                SpacingTokens.lg,
                SpacingTokens.lg,
                SpacingTokens.lg,
                SpacingTokens.sm,
              ),
              child: VCard(
                onTap: () => context.push(RouteNames.aiCreateActionPath),
                padding: const EdgeInsets.all(SpacingTokens.md),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(RadiusTokens.md),
                        gradient: const LinearGradient(
                          colors: [ColorTokens.secondary, Color(0xFFFFB547)],
                        ),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Color(0xFF111318),
                      ),
                    ),
                    const SizedBox(width: SpacingTokens.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create an Action',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: SpacingTokens.xs),
                          Text(
                            'Describe it in words, AI does the rest',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: scrollBottomClearance)),
        ],
      ),
    );
  }
}

class _FeaturedActionCard extends HookWidget {
  const _FeaturedActionCard({
    required this.action,
    required this.isActive,
    required this.onToggleActive,
  });

  final vc.Action action;
  final bool isActive;
  final VoidCallback onToggleActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final rewardColor = colorScheme.secondary;

    final typeLabel = switch (action.actionType) {
      'one_off' => 'One-Off',
      'sequential' => 'Sequential',
      'habit' => 'Habit',
      _ => action.actionType,
    };

    return SizedBox(
      width: 280,
      child: VCard(
        onTap: () {
          context.push(
            RouteNames.actionDetailPath.replaceFirst(
              ':actionId',
              '${action.id}',
            ),
          );
        },
        padding: const EdgeInsets.all(SpacingTokens.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(
              builder: (context) {
                final isDark = Theme.of(context).brightness == Brightness.dark;
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(SpacingTokens.sm),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(RadiusTokens.md),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? const [Color(0xFF0F2850), Color(0xFF205EA3)]
                          : const [Color(0xFFD0DFFF), Color(0xFFB5CCFF)],
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.videocam_outlined,
                        color: isDark ? Colors.white : ColorTokens.primary,
                        size: 16,
                      ),
                      const SizedBox(width: SpacingTokens.xs),
                      Text(
                        'Video verification',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isDark ? Colors.white : ColorTokens.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: SpacingTokens.sm),
            Row(
              children: [
                VBadgeChip(
                  label: action.tags?.split(',').first.trim() ?? typeLabel,
                ),
                const Spacer(),
                Text(
                  'Anywhere',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: SpacingTokens.md),
            Text(
              action.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Icon(Icons.emoji_events_outlined, size: 18, color: rewardColor),
                const SizedBox(width: SpacingTokens.xs),
                Text(
                  'Earn rewards',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: SpacingTokens.sm),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: TextButton.icon(
                        key: Key('home_featured_setActive_${action.id}'),
                        onPressed: onToggleActive,
                        icon: Icon(
                          isActive
                              ? Icons.check_circle
                              : Icons.playlist_add_check_circle_outlined,
                          size: 16,
                        ),
                        label: Text(isActive ? 'Active' : 'Set'),
                        style: TextButton.styleFrom(
                          foregroundColor: isActive
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                          backgroundColor: isActive
                              ? colorScheme.primaryContainer.withValues(
                                  alpha: 0.35,
                                )
                              : colorScheme.surfaceContainerHighest.withValues(
                                  alpha: 0.5,
                                ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              RadiusTokens.md,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatPill extends HookWidget {
  const _StatPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onBg = isDark ? Colors.white : ColorTokens.ink;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.md,
        vertical: SpacingTokens.sm,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.16)
            : Colors.white.withValues(alpha: 0.6),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.24)
              : ColorTokens.primary.withValues(alpha: 0.15),
        ),
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22172B51),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: onBg.withValues(alpha: 0.85),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              color: onBg,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Cached decoration for action icon in list items.
const _actionIconDecoration = BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(RadiusTokens.md)),
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF194A95), Color(0xFF10346A)],
  ),
);

double _locationProgressFromDistance(String distanceLabel) {
  final distanceValue = double.tryParse(
    distanceLabel.toLowerCase().replaceAll('mi', '').trim(),
  );
  if (distanceValue == null) {
    return 0;
  }

  // Most featured actions are within ~2 miles. Use that as a simple progress
  // scale where closer distance means higher readiness to check in.
  final readiness = (2.0 - distanceValue) / 2.0;
  return readiness.clamp(0.05, 1.0);
}
