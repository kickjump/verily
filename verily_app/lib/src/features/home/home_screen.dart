import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/actions/providers/active_action_provider.dart';
import 'package:verily_app/src/routing/route_names.dart';
import 'package:verily_ui/verily_ui.dart';

/// Primary home experience with personalized action discovery.
class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedFilter = useState('Nearby');
    final activeAction = ref.watch(activeActionControllerProvider);
    final activeActionController = ref.read(
      activeActionControllerProvider.notifier,
    );

    const filters = ['Nearby', 'Quick', 'High Reward'];
    const featuredActions = [
      _ActionPreview(
        id: '101',
        title: 'Record 20 push-ups at a local park',
        subtitle: 'Fitness',
        distance: '0.4 mi',
        reward: '120 pts',
        nextLocationLabel: 'Memorial Park Track',
        verificationChecklist: [
          'Show your full body in frame while doing all reps.',
          'Capture ambient park audio from start to finish.',
          'Pan camera to the track sign before ending recording.',
        ],
      ),
      _ActionPreview(
        id: '102',
        title: 'Capture a 30s cleanup clip on your street',
        subtitle: 'Environment',
        distance: '0.8 mi',
        reward: '95 pts',
        nextLocationLabel: 'Oak Street Corner',
        verificationChecklist: [
          'Record litter before and after cleanup.',
          'Keep gloves and collection bag visible in video.',
          'Show street name sign in the first 10 seconds.',
        ],
      ),
      _ActionPreview(
        id: '103',
        title: 'Film a 1 minute kindness action',
        subtitle: 'Community',
        distance: '1.1 mi',
        reward: '140 pts',
        nextLocationLabel: 'Community Center Entrance',
        verificationChecklist: [
          'Clearly show the positive interaction in one take.',
          'Capture consent-friendly angle with no private details.',
          'Show the community center sign before wrapping up.',
        ],
      ),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                SpacingTokens.lg,
                SpacingTokens.xxl,
                SpacingTokens.lg,
                SpacingTokens.lg,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0A4B6E), Color(0xFF2F8F83)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ready to verify in the real world?',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.sm),
                  Text(
                    'Complete actions nearby and earn rewards after AI review.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.88),
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.lg),
                  const Row(
                    children: [
                      _StatPill(label: 'Verified', value: '42'),
                      SizedBox(width: SpacingTokens.sm),
                      _StatPill(label: 'Streak', value: '7 days'),
                    ],
                  ),
                ],
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
              child: Wrap(
                spacing: SpacingTokens.sm,
                runSpacing: SpacingTokens.sm,
                children: [
                  for (final filter in filters)
                    ChoiceChip(
                      label: Text(filter),
                      selected: selectedFilter.value == filter,
                      onSelected: (_) => selectedFilter.value = filter,
                    ),
                ],
              ),
            ),
          ),
          if (activeAction != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  SpacingTokens.lg,
                  SpacingTokens.sm,
                  SpacingTokens.lg,
                  SpacingTokens.md,
                ),
                child: VCard(
                  padding: const EdgeInsets.all(SpacingTokens.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
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
                      const SizedBox(height: SpacingTokens.md),
                      Text(
                        'Verify at location',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.xs),
                      for (final item
                          in activeAction.verificationChecklist.take(3))
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: SpacingTokens.xs,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Icon(
                                  Icons.check_circle_outline,
                                  size: 16,
                                ),
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
                    ],
                  ),
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 220,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingTokens.lg,
                ),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final action = featuredActions[index];
                  return _FeaturedActionCard(
                    action: action,
                    isActive: activeAction?.actionId == action.id,
                    onToggleActive: () {
                      activeActionController.toggle(action.toActiveAction());
                    },
                  );
                },
                separatorBuilder: (_, __) =>
                    const SizedBox(width: SpacingTokens.md),
                itemCount: featuredActions.length,
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
                'Nearby right now',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SliverList.builder(
            itemCount: featuredActions.length,
            itemBuilder: (context, index) {
              final action = featuredActions[index];
              final isActive = activeAction?.actionId == action.id;
              return Padding(
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
                        action.id,
                      ),
                    );
                  },
                  padding: const EdgeInsets.all(SpacingTokens.md),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(RadiusTokens.md),
                          color: const Color(
                            0xFF2F8F83,
                          ).withValues(alpha: 0.15),
                        ),
                        child: const Icon(Icons.verified_outlined),
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
                              '${action.subtitle} • ${action.distance}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: SpacingTokens.sm),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          VBadgeChip(label: action.reward),
                          const SizedBox(height: SpacingTokens.xs),
                          TextButton.icon(
                            onPressed: () {
                              activeActionController.toggle(
                                action.toActiveAction(),
                              );
                            },
                            icon: Icon(
                              isActive
                                  ? Icons.check_circle
                                  : Icons.playlist_add_check_circle_outlined,
                              size: 16,
                            ),
                            label: Text(isActive ? 'Active' : 'Set Active'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(SpacingTokens.lg),
              child: VOutlinedButton(
                onPressed: () => context.push(RouteNames.searchPath),
                child: const Text('Browse more actions'),
              ),
            ),
          ),
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

  final _ActionPreview action;
  final bool isActive;
  final VoidCallback onToggleActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 280,
      child: VCard(
        onTap: () {
          context.push(
            RouteNames.actionDetailPath.replaceFirst(':actionId', action.id),
          );
        },
        padding: const EdgeInsets.all(SpacingTokens.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                VBadgeChip(label: action.subtitle),
                const Spacer(),
                Text(action.distance, style: theme.textTheme.labelMedium),
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
                const Icon(Icons.emoji_events_outlined, size: 18),
                const SizedBox(width: SpacingTokens.xs),
                Text(
                  action.reward,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: SpacingTokens.sm),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: TextButton.icon(
                        onPressed: onToggleActive,
                        icon: Icon(
                          isActive
                              ? Icons.check_circle
                              : Icons.playlist_add_check_circle_outlined,
                          size: 16,
                        ),
                        label: Text(isActive ? 'Active' : 'Set'),
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

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.md,
        vertical: SpacingTokens.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionPreview {
  const _ActionPreview({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.distance,
    required this.reward,
    required this.nextLocationLabel,
    required this.verificationChecklist,
  });

  final String id;
  final String title;
  final String subtitle;
  final String distance;
  final String reward;
  final String nextLocationLabel;
  final List<String> verificationChecklist;

  ActiveAction toActiveAction() {
    return ActiveAction(
      actionId: id,
      title: title,
      nextLocationLabel: nextLocationLabel,
      distanceFromNextLocation: distance,
      verificationChecklist: verificationChecklist,
    );
  }
}
