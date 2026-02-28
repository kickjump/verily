// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Searches actions by query string.

@ProviderFor(searchActions)
final searchActionsProvider = SearchActionsFamily._();

/// Searches actions by query string.

final class SearchActionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<vc.Action>>,
          List<vc.Action>,
          FutureOr<List<vc.Action>>
        >
    with $FutureModifier<List<vc.Action>>, $FutureProvider<List<vc.Action>> {
  /// Searches actions by query string.
  SearchActionsProvider._({
    required SearchActionsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'searchActionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$searchActionsHash();

  @override
  String toString() {
    return r'searchActionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<vc.Action>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<vc.Action>> create(Ref ref) {
    final argument = this.argument as String;
    return searchActions(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchActionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchActionsHash() => r'cc208c4b0e2dfd0674d438183c8ffc8ccc858528';

/// Searches actions by query string.

final class SearchActionsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<vc.Action>>, String> {
  SearchActionsFamily._()
    : super(
        retry: null,
        name: r'searchActionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Searches actions by query string.

  SearchActionsProvider call(String query) =>
      SearchActionsProvider._(argument: query, from: this);

  @override
  String toString() => r'searchActionsProvider';
}

/// Fetches all action categories.

@ProviderFor(actionCategories)
final actionCategoriesProvider = ActionCategoriesProvider._();

/// Fetches all action categories.

final class ActionCategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<vc.ActionCategory>>,
          List<vc.ActionCategory>,
          FutureOr<List<vc.ActionCategory>>
        >
    with
        $FutureModifier<List<vc.ActionCategory>>,
        $FutureProvider<List<vc.ActionCategory>> {
  /// Fetches all action categories.
  ActionCategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'actionCategoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$actionCategoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<vc.ActionCategory>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<vc.ActionCategory>> create(Ref ref) {
    return actionCategories(ref);
  }
}

String _$actionCategoriesHash() => r'ae49e55f9f3927ce8b1daab41a2c21bf2cd9b385';

/// Fetches actions filtered by category.

@ProviderFor(actionsByCategory)
final actionsByCategoryProvider = ActionsByCategoryFamily._();

/// Fetches actions filtered by category.

final class ActionsByCategoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<vc.Action>>,
          List<vc.Action>,
          FutureOr<List<vc.Action>>
        >
    with $FutureModifier<List<vc.Action>>, $FutureProvider<List<vc.Action>> {
  /// Fetches actions filtered by category.
  ActionsByCategoryProvider._({
    required ActionsByCategoryFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'actionsByCategoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$actionsByCategoryHash();

  @override
  String toString() {
    return r'actionsByCategoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<vc.Action>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<vc.Action>> create(Ref ref) {
    final argument = this.argument as int;
    return actionsByCategory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ActionsByCategoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$actionsByCategoryHash() => r'41586eb54250a631d98b922e0768849298cd550b';

/// Fetches actions filtered by category.

final class ActionsByCategoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<vc.Action>>, int> {
  ActionsByCategoryFamily._()
    : super(
        retry: null,
        name: r'actionsByCategoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches actions filtered by category.

  ActionsByCategoryProvider call(int categoryId) =>
      ActionsByCategoryProvider._(argument: categoryId, from: this);

  @override
  String toString() => r'actionsByCategoryProvider';
}
