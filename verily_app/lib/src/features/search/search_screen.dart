import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/search/search_provider.dart';
import 'package:verily_app/src/routing/route_names.dart';
import 'package:verily_client/verily_client.dart' as vc;
import 'package:verily_ui/verily_ui.dart';

/// Screen for searching and filtering actions.
class SearchScreen extends HookConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final searchQuery = useState('');
    final categoriesAsync = ref.watch(actionCategoriesProvider);

    useEffect(() {
      void listener() {
        searchQuery.value = searchController.text;
      }

      searchController.addListener(listener);
      return () => searchController.removeListener(listener);
    }, [searchController]);

    return Scaffold(
      appBar: AppBar(
        title: VTextField(
          controller: searchController,
          hintText: 'Search actions...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchQuery.value.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    searchQuery.value = '';
                  },
                )
              : null,
          autofocus: true,
        ),
      ),
      body: Column(
        children: [
          // Category filter chips
          categoriesAsync.when(
            loading: () => const SizedBox(height: 56),
            error: (_, __) => const SizedBox(height: 56),
            data: (categories) => SizedBox(
              height: 56,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingTokens.md,
                  vertical: SpacingTokens.sm,
                ),
                child: Row(
                  children: [
                    for (var i = 0; i < categories.length; i++) ...[
                      FilterChip(
                        label: Text(categories[i].name),
                        onSelected: (_) {},
                        selectedColor: ColorTokens.primary.withAlpha(30),
                        checkmarkColor: ColorTokens.primary,
                      ),
                      if (i < categories.length - 1)
                        const SizedBox(width: SpacingTokens.sm),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const Divider(height: 1),

          // Results
          Expanded(child: _SearchResults(query: searchQuery.value)),
        ],
      ),
    );
  }
}

/// Displays search results filtered by query.
class _SearchResults extends HookConsumerWidget {
  const _SearchResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: colorScheme.onSurfaceVariant.withAlpha(100),
            ),
            const SizedBox(height: SpacingTokens.md),
            Text(
              'Search for actions',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: SpacingTokens.xs),
            Text(
              'Find actions by title, description, or tags',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    final resultsAsync = ref.watch(searchActionsProvider(query));

    return resultsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error),
            const SizedBox(height: SpacingTokens.md),
            Text(
              'Search failed',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: SpacingTokens.md),
            FilledButton(
              onPressed: () => ref.invalidate(searchActionsProvider(query)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (actions) {
        if (actions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: SpacingTokens.md),
                Text(
                  'No results for "$query"',
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
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: SpacingTokens.sm),
            child: _SearchResultCard(action: actions[index]),
          ),
        );
      },
    );
  }
}

/// A single search result card.
class _SearchResultCard extends HookWidget {
  const _SearchResultCard({required this.action});

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

    return VCard(
      onTap: () => context.push(
        RouteNames.actionDetailPath.replaceFirst(':actionId', '${action.id}'),
      ),
      padding: const EdgeInsets.all(SpacingTokens.md),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
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
                Row(
                  children: [
                    if (action.tags != null && action.tags!.isNotEmpty) ...[
                      VBadgeChip(
                        label: action.tags!.split(',').first.trim(),
                        icon: Icons.category_outlined,
                      ),
                      const SizedBox(width: SpacingTokens.sm),
                    ],
                    VBadgeChip(label: typeLabel),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}
