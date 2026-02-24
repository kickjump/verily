// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Streams the user's current geographic position.
///
/// Handles permission requests and location service checks. Emits position
/// updates as the device moves.

@ProviderFor(userLocation)
final userLocationProvider = UserLocationProvider._();

/// Streams the user's current geographic position.
///
/// Handles permission requests and location service checks. Emits position
/// updates as the device moves.

final class UserLocationProvider
    extends
        $FunctionalProvider<AsyncValue<Position>, Position, Stream<Position>>
    with $FutureModifier<Position>, $StreamProvider<Position> {
  /// Streams the user's current geographic position.
  ///
  /// Handles permission requests and location service checks. Emits position
  /// updates as the device moves.
  UserLocationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userLocationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userLocationHash();

  @$internal
  @override
  $StreamProviderElement<Position> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Position> create(Ref ref) {
    return userLocation(ref);
  }
}

String _$userLocationHash() => r'7aa0b1ea90941245b1c6d309f80c9df4f1d3580f';

/// Fetches actions visible within a map bounding box.

@ProviderFor(actionsInBoundingBox)
final actionsInBoundingBoxProvider = ActionsInBoundingBoxFamily._();

/// Fetches actions visible within a map bounding box.

final class ActionsInBoundingBoxProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Action>>,
          List<Action>,
          FutureOr<List<Action>>
        >
    with $FutureModifier<List<Action>>, $FutureProvider<List<Action>> {
  /// Fetches actions visible within a map bounding box.
  ActionsInBoundingBoxProvider._({
    required ActionsInBoundingBoxFamily super.from,
    required BoundingBox super.argument,
  }) : super(
         retry: null,
         name: r'actionsInBoundingBoxProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$actionsInBoundingBoxHash();

  @override
  String toString() {
    return r'actionsInBoundingBoxProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Action>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Action>> create(Ref ref) {
    final argument = this.argument as BoundingBox;
    return actionsInBoundingBox(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ActionsInBoundingBoxProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$actionsInBoundingBoxHash() =>
    r'fba37b0336fd792a33d7591b2ea60ccb4c66416c';

/// Fetches actions visible within a map bounding box.

final class ActionsInBoundingBoxFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Action>>, BoundingBox> {
  ActionsInBoundingBoxFamily._()
    : super(
        retry: null,
        name: r'actionsInBoundingBoxProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches actions visible within a map bounding box.

  ActionsInBoundingBoxProvider call(BoundingBox bbox) =>
      ActionsInBoundingBoxProvider._(argument: bbox, from: this);

  @override
  String toString() => r'actionsInBoundingBoxProvider';
}

/// Fetches actions near a geographic point within a radius.

@ProviderFor(nearbyActions)
final nearbyActionsProvider = NearbyActionsFamily._();

/// Fetches actions near a geographic point within a radius.

final class NearbyActionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Action>>,
          List<Action>,
          FutureOr<List<Action>>
        >
    with $FutureModifier<List<Action>>, $FutureProvider<List<Action>> {
  /// Fetches actions near a geographic point within a radius.
  NearbyActionsProvider._({
    required NearbyActionsFamily super.from,
    required (double, double, double) super.argument,
  }) : super(
         retry: null,
         name: r'nearbyActionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$nearbyActionsHash();

  @override
  String toString() {
    return r'nearbyActionsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Action>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Action>> create(Ref ref) {
    final argument = this.argument as (double, double, double);
    return nearbyActions(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is NearbyActionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$nearbyActionsHash() => r'158d91c7684adeef2d6ecd10d0621cf1aa03ac47';

/// Fetches actions near a geographic point within a radius.

final class NearbyActionsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Action>>,
          (double, double, double)
        > {
  NearbyActionsFamily._()
    : super(
        retry: null,
        name: r'nearbyActionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches actions near a geographic point within a radius.

  NearbyActionsProvider call(double lat, double lng, double radiusMeters) =>
      NearbyActionsProvider._(argument: (lat, lng, radiusMeters), from: this);

  @override
  String toString() => r'nearbyActionsProvider';
}
