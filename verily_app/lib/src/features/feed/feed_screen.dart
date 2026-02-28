import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/feed/feed_provider.dart';
import 'package:verily_app/src/routing/route_names.dart';
import 'package:verily_client/verily_client.dart' as vc;
import 'package:verily_ui/verily_ui.dart';

/// Main feed screen showing nearby and trending actions.
class FeedScreen extends HookConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 2);
    final actionsAsync = ref.watch(feedActionsProvider);

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
            onPressed: () {},
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
            actionsAsync: actionsAsync,
            onRefresh: () => ref.invalidate(feedActionsProvider),
            emptyIcon: Icons.location_on_outlined,
            emptyTitle: 'No actions nearby',
            emptySubtitle: 'Enable location to see actions around you',
          ),

          // Trending tab
          _FeedList(
            actionsAsync: actionsAsync,
            onRefresh: () => ref.invalidate(feedActionsProvider),
            emptyIcon: Icons.trending_up,
            emptyTitle: 'No trending actions',
            emptySubtitle: 'Check back later for popular actions',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouteNames.aiCreateActionPath),
        icon: const Icon(Icons.auto_awesome),
        label: const Text('Create Action'),
      ),
    );
  }
}

/// A scrollable, pull-to-refresh list of action cards.
class _FeedList extends HookWidget {
  const _FeedList({
    required this.actionsAsync,
    required this.onRefresh,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptySubtitle,
  });

  final AsyncValue<List<vc.Action>> actionsAsync;
  final VoidCallback onRefresh;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptySubtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return actionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error),
            const SizedBox(height: SpacingTokens.md),
            Text(
              'Failed to load actions',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: SpacingTokens.md),
            FilledButton(onPressed: onRefresh, child: const Text('Retry')),
          ],
        ),
      ),
      data: (actions) {
        if (actions.isEmpty) {
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
          onRefresh: () async => onRefresh(),
          child: ListView.builder(
            padding: const EdgeInsets.all(SpacingTokens.md),
            itemCount: actions.length,
            itemBuilder: (context, index) =>
                _ActionFeedCard(action: actions[index]),
          ),
        );
      },
    );
  }
}

/// A single action card displayed in the feed.
class _ActionFeedCard extends HookWidget {
  const _ActionFeedCard({required this.action});

  final vc.Action action;

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

    return Padding(
      padding: const EdgeInsets.only(bottom: SpacingTokens.sm),
      child: VCard(
        onTap: () => context.push(
          RouteNames.actionDetailPath.replaceFirst(':actionId', '${action.id}'),
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
                      if (action.tags != null && action.tags!.isNotEmpty)
                        VBadgeChip(
                          label: action.tags!.split(',').first.trim(),
                          icon: Icons.category_outlined,
                        ),
                      VBadgeChip(
                        label: typeLabel,
                        backgroundColor: typeColor.withAlpha(30),
                        foregroundColor: typeColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: SpacingTokens.sm),

            // Title
            Text(
              action.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SpacingTokens.xs),

            // Description excerpt
            Text(
              action.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: SpacingTokens.sm),

            // Footer: tags and type
            Row(
              children: [
                if (action.tags != null && action.tags!.isNotEmpty) ...[
                  Icon(
                    Icons.label_outline,
                    size: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: SpacingTokens.xs),
                  Expanded(
                    child: Text(
                      action.tags!.split(',').take(3).join(', '),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ] else
                  const Spacer(),
                const Icon(
                  Icons.emoji_events_outlined,
                  size: 16,
                  color: ColorTokens.secondary,
                ),
                const SizedBox(width: SpacingTokens.xs),
                Text(
                  'Earn rewards',
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
