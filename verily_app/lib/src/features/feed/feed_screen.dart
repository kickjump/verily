import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/routing/route_names.dart';
import 'package:verily_ui/verily_ui.dart';

/// Main feed screen showing nearby and trending actions.
class FeedScreen extends HookConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 2);
    final isRefreshing = useState(false);

    Future<void> onRefresh() async {
      isRefreshing.value = true;
      // TODO: Refresh feed data from Serverpod.
      await Future<void>.delayed(const Duration(seconds: 1));
      isRefreshing.value = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verily'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push(RouteNames.searchPath),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications.
            },
          ),
        ],
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'Nearby'),
            Tab(text: 'Trending'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          // Nearby tab
          _FeedList(
            onRefresh: onRefresh,
            emptyIcon: Icons.location_on_outlined,
            emptyTitle: 'No actions nearby',
            emptySubtitle: 'Enable location to see actions around you',
          ),

          // Trending tab
          _FeedList(
            onRefresh: onRefresh,
            emptyIcon: Icons.trending_up,
            emptyTitle: 'No trending actions',
            emptySubtitle: 'Check back later for popular actions',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouteNames.createActionPath),
        icon: const Icon(Icons.add),
        label: const Text('Create Action'),
      ),
    );
  }
}

/// A scrollable, pull-to-refresh list of action cards.
class _FeedList extends HookWidget {
  const _FeedList({
    required this.onRefresh,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptySubtitle,
  });

  final Future<void> Function() onRefresh;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptySubtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // TODO: Replace with real data from provider.
    final hasData = useState(true);

    if (!hasData.value) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(emptyIcon, size: 64, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: SpacingTokens.md),
            Text(
              emptyTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: SpacingTokens.xs),
            Text(
              emptySubtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(SpacingTokens.md),
        itemCount: 10,
        itemBuilder: (context, index) => _ActionFeedCard(index: index),
      ),
    );
  }
}

/// A single action card displayed in the feed.
class _ActionFeedCard extends HookWidget {
  const _ActionFeedCard({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Placeholder data. TODO: Replace with real action model.
    final categories = [
      'Fitness',
      'Environment',
      'Community',
      'Education',
      'Wellness',
    ];
    final titles = [
      'Do 20 push-ups in the park',
      'Pick up litter on your street',
      'Help a neighbor carry groceries',
      'Read a chapter of a book aloud',
      'Meditate for 10 minutes outdoors',
      'Plant a tree in your garden',
      'Run a full mile without stopping',
      'Teach someone a new skill',
      'Clean a public bench',
      'Do yoga in the morning sun',
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: SpacingTokens.sm),
      child: VCard(
        onTap: () => context.push(
          RouteNames.actionDetailPath.replaceFirst(':actionId', '$index'),
        ),
        padding: const EdgeInsets.all(SpacingTokens.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category and type badge row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: SpacingTokens.sm,
                    runSpacing: SpacingTokens.xs,
                    children: [
                      VBadgeChip(
                        label: categories[index % categories.length],
                        icon: Icons.category_outlined,
                      ),
                      VBadgeChip(
                        label: index.isEven ? 'One-Off' : 'Sequential',
                        backgroundColor: index.isEven
                            ? ColorTokens.primary.withAlpha(30)
                            : ColorTokens.tertiary.withAlpha(30),
                        foregroundColor: index.isEven
                            ? ColorTokens.primary
                            : ColorTokens.tertiary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: SpacingTokens.sm),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: SpacingTokens.xs),
                    Text(
                      '${(index + 1) * 0.3} mi',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: SpacingTokens.sm),

            // Title
            Text(
              titles[index % titles.length],
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SpacingTokens.xs),

            // Description excerpt
            Text(
              'Complete this action and submit a video for AI verification '
              'to earn rewards and badges.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: SpacingTokens.sm),

            // Footer: creator and reward
            Row(
              children: [
                VAvatar(initials: 'U${index % 5}', radius: 12),
                const SizedBox(width: SpacingTokens.xs),
                Text(
                  'user_$index',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.emoji_events_outlined,
                  size: 16,
                  color: ColorTokens.secondary,
                ),
                const SizedBox(width: SpacingTokens.xs),
                Text(
                  '${(index + 1) * 50} pts',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: ColorTokens.secondary,
                    fontWeight: FontWeight.bold,
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
