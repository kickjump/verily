// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the current feed filter selection.

@ProviderFor(FeedFilterNotifier)
final feedFilterProvider = FeedFilterNotifierProvider._();

/// Provides the current feed filter selection.
final class FeedFilterNotifierProvider
    extends $NotifierProvider<FeedFilterNotifier, FeedFilter> {
  /// Provides the current feed filter selection.
  FeedFilterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'feedFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$feedFilterNotifierHash();

  @$internal
  @override
  FeedFilterNotifier create() => FeedFilterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FeedFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FeedFilter>(value),
    );
  }
}

String _$feedFilterNotifierHash() =>
    r'8a2ea2bdeb28756b58de117966a651a893e0594d';

/// Provides the current feed filter selection.

abstract class _$FeedFilterNotifier extends $Notifier<FeedFilter> {
  FeedFilter build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<FeedFilter, FeedFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FeedFilter, FeedFilter>,
              FeedFilter,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Fetches actions from the server based on the active filter.
///
/// Returns a list of [Action] objects. In development mode with no server
/// running, returns mock data to keep the UI functional.
///
/// When the filter is [FeedFilter.nearby], the provider awaits the device's
/// GPS position via [userLocationProvider] and calls the server-side
/// `listNearby()` endpoint to return only actions within
/// [kNearbyRadiusMeters]. If the device location is unavailable (permission
/// denied, timeout, etc.), it gracefully falls back to `listActive()` so
/// the user always sees content.

@ProviderFor(feedActions)
final feedActionsProvider = FeedActionsProvider._();

/// Fetches actions from the server based on the active filter.
///
/// Returns a list of [Action] objects. In development mode with no server
/// running, returns mock data to keep the UI functional.
///
/// When the filter is [FeedFilter.nearby], the provider awaits the device's
/// GPS position via [userLocationProvider] and calls the server-side
/// `listNearby()` endpoint to return only actions within
/// [kNearbyRadiusMeters]. If the device location is unavailable (permission
/// denied, timeout, etc.), it gracefully falls back to `listActive()` so
/// the user always sees content.

final class FeedActionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Action>>,
          List<Action>,
          FutureOr<List<Action>>
        >
    with $FutureModifier<List<Action>>, $FutureProvider<List<Action>> {
  /// Fetches actions from the server based on the active filter.
  ///
  /// Returns a list of [Action] objects. In development mode with no server
  /// running, returns mock data to keep the UI functional.
  ///
  /// When the filter is [FeedFilter.nearby], the provider awaits the device's
  /// GPS position via [userLocationProvider] and calls the server-side
  /// `listNearby()` endpoint to return only actions within
  /// [kNearbyRadiusMeters]. If the device location is unavailable (permission
  /// denied, timeout, etc.), it gracefully falls back to `listActive()` so
  /// the user always sees content.
  FeedActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'feedActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$feedActionsHash();

  @$internal
  @override
  $FutureProviderElement<List<Action>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Action>> create(Ref ref) {
    return feedActions(ref);
  }
}

String _$feedActionsHash() => r'b82af705ffcb70a70ee661ef39902c5e7cbacce4';
