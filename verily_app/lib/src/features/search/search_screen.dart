import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_ui/verily_ui.dart';

/// Screen for searching and filtering actions.
class SearchScreen extends HookConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final searchController = useTextEditingController();
    final searchQuery = useState('');
    final selectedCategory = useState<String?>(null);

    // TODO: Replace with real categories from provider.
    final categories = [
      'All',
      'Fitness',
      'Environment',
      'Community',
      'Education',
      'Wellness',
      'Creative',
    ];

    useEffect(
      () {
        void listener() {
          searchQuery.value = searchController.text;
        }

        searchController.addListener(listener);
        return () => searchController.removeListener(listener);
      },
      [searchController],
    );

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
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingTokens.md,
                vertical: SpacingTokens.sm,
              ),
              itemCount: categories.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: SpacingTokens.sm),
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = (category == 'All' &&
                        selectedCategory.value == null) ||
                    selectedCategory.value == category;

                return FilterChip(
                  selected: isSelected,
                  label: Text(category),
                  onSelected: (selected) {
                    selectedCategory.value =
                        (selected && category != 'All') ? category : null;
                  },
                  selectedColor: ColorTokens.primary.withAlpha(30),
                  checkmarkColor: ColorTokens.primary,
                );
              },
            ),
          ),
          const Divider(height: 1),

          // Results
          Expanded(
            child: _SearchResults(
              query: searchQuery.value,
              category: selectedCategory.value,
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays search results filtered by query and category.
class _SearchResults extends HookWidget {
  const _SearchResults({required this.query, this.category});

  final String query;
  final String? category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // TODO: Replace with real search results from provider.
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
              'Find actions by title, description, or category',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    // Placeholder results
    final resultCount = query.length % 7 + 3;

    return ListView.builder(
      padding: const EdgeInsets.all(SpacingTokens.md),
      itemCount: resultCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: SpacingTokens.sm),
          child: _SearchResultCard(index: index, query: query),
        );
      },
    );
  }
}

/// A single search result card.
class _SearchResultCard extends HookWidget {
  const _SearchResultCard({required this.index, required this.query});

  final int index;
  final String query;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return VCard(
      onTap: () => context.push('/actions/$index'),
      padding: const EdgeInsets.all(SpacingTokens.md),
      child: Row(
        children: [
          // Action icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: ColorTokens.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(RadiusTokens.sm),
            ),
            child: Icon(
              Icons.assignment_outlined,
              color: ColorTokens.primary,
            ),
          ),
          const SizedBox(width: SpacingTokens.md),

          // Action info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Action result #${index + 1} for "$query"',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: SpacingTokens.xs),
                Row(
                  children: [
                    VBadgeChip(
                      label: 'Fitness',
                      icon: Icons.category_outlined,
                    ),
                    const SizedBox(width: SpacingTokens.sm),
                    Text(
                      '${(index + 1) * 25} pts',
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

          // Arrow
          Icon(
            Icons.chevron_right,
            color: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
