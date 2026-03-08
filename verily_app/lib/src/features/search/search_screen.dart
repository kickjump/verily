import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/l10n/generated/app_localizations.dart';
import 'package:verily_app/src/features/search/search_provider.dart';
import 'package:verily_app/src/routing/route_names.dart';
import 'package:verily_client/verily_client.dart' as vc;
import 'package:verily_ui/verily_ui.dart';

/// Screen for searching and filtering actions.
class SearchScreen extends HookConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
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
          hintText: l10n.searchActionsPlaceholder,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined),
            tooltip: l10n.searchMapViewTooltip,
            onPressed: () => context.push(RouteNames.mapPath),
          ),
        ],
      ),
      body: Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: Theme.of(context).brightness == Brightness.dark
                  ? GradientTokens.shellBackground
                  : GradientTokens.shellBackgroundLight,
            ),
            child: const SizedBox.expand(),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  SpacingTokens.md,
                  SpacingTokens.md,
                  SpacingTokens.md,
                  SpacingTokens.sm,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(RadiusTokens.lg),
                    gradient: Theme.of(context).brightness == Brightness.dark
                        ? GradientTokens.heroCard
                        : GradientTokens.heroCardLight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(SpacingTokens.md),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              RadiusTokens.sm,
                            ),
                            color: Colors.white.withValues(alpha: 0.24),
                          ),
                          child: Icon(
                            Icons.travel_explore_outlined,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : ColorTokens.primary,
                          ),
                        ),
                        const SizedBox(width: SpacingTokens.sm),
                        Expanded(
                          child: Text(
                            l10n.searchDiscoverByKeywordOrCategory,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white.withValues(alpha: 0.9)
                                      : ColorTokens.ink.withValues(alpha: 0.78),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Category filter chips
              categoriesAsync.when(
                loading: () => const SizedBox(height: 56),
                error: (_, __) => const SizedBox(height: 56),
                data: (categories) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SpacingTokens.md,
                  ),
                  child: VCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SpacingTokens.sm,
                      vertical: SpacingTokens.sm,
                    ),
                    child: SizedBox(
                      height: 40,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (var i = 0; i < categories.length; i++) ...[
                              FilterChip(
                                label: Text(categories[i].name),
                                onSelected: (_) {},
                                selectedColor: ColorTokens.primary.withAlpha(
                                  30,
                                ),
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
                ),
              ),
              const SizedBox(height: SpacingTokens.sm),

              // Results
              Expanded(child: _SearchResults(query: searchQuery.value)),
            ],
          ),
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
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (query.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.lg),
          child: VCard(
            padding: const EdgeInsets.all(SpacingTokens.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.search,
                  size: 64,
                  color: colorScheme.onSurfaceVariant.withAlpha(100),
                ),
                const SizedBox(height: SpacingTokens.md),
                Text(
                  l10n.searchEmptyTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: SpacingTokens.xs),
                Text(
                  l10n.searchEmptySubtitle,
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
              l10n.searchFailed,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: SpacingTokens.md),
            FilledButton(
              onPressed: () => ref.invalidate(searchActionsProvider(query)),
              child: Text(l10n.retry),
            ),
          ],
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
                      Icons.search_off,
                      size: 64,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: SpacingTokens.md),
                    Text(
                      l10n.searchNoResultsFor(query),
                      style: theme.textTheme.titleMedium?.copyWith(
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
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final typeLabel = switch (action.actionType) {
      'one_off' => l10n.actionTypeOneOff,
      'sequential' => l10n.actionTypeSequential,
      'habit' => l10n.actionTypeHabit,
      _ => action.actionType,
    };

    return VCard(
      onTap: () => context.push(
        RouteNames.actionDetailPath.replaceFirst(':actionId', '${action.id}'),
      ),
      padding: const EdgeInsets.all(SpacingTokens.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(SpacingTokens.sm),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(RadiusTokens.md),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ColorTokens.primary.withValues(alpha: 0.2),
                  colorScheme.surfaceContainerHighest,
                ],
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(RadiusTokens.sm),
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                  child: const Icon(
                    Icons.assignment_outlined,
                    color: ColorTokens.primary,
                  ),
                ),
                const SizedBox(width: SpacingTokens.sm),
                Expanded(
                  child: Text(
                    action.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
              ],
            ),
          ),
          const SizedBox(height: SpacingTokens.sm),
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
              const Spacer(),
              Text(
                l10n.searchResultOpenStatus,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
