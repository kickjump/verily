// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches a single action by its ID from the server.

@ProviderFor(actionDetail)
final actionDetailProvider = ActionDetailFamily._();

/// Fetches a single action by its ID from the server.

final class ActionDetailProvider
    extends $FunctionalProvider<AsyncValue<Action>, Action, FutureOr<Action>>
    with $FutureModifier<Action>, $FutureProvider<Action> {
  /// Fetches a single action by its ID from the server.
  ActionDetailProvider._({
    required ActionDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'actionDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$actionDetailHash();

  @override
  String toString() {
    return r'actionDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Action> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Action> create(Ref ref) {
    final argument = this.argument as int;
    return actionDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ActionDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$actionDetailHash() => r'1feee701613f67a1e639dc22e884c70bd02a4e13';

/// Fetches a single action by its ID from the server.

final class ActionDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Action>, int> {
  ActionDetailFamily._()
    : super(
        retry: null,
        name: r'actionDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches a single action by its ID from the server.

  ActionDetailProvider call(int actionId) =>
      ActionDetailProvider._(argument: actionId, from: this);

  @override
  String toString() => r'actionDetailProvider';
}

/// Fetches the [Location] associated with an action's [locationId].
///
/// Returns `null` if the action has no location requirement.
/// This is used by the video review screen to perform on-device geo-fence
/// pre-validation before submission.

@ProviderFor(actionLocation)
final actionLocationProvider = ActionLocationFamily._();

/// Fetches the [Location] associated with an action's [locationId].
///
/// Returns `null` if the action has no location requirement.
/// This is used by the video review screen to perform on-device geo-fence
/// pre-validation before submission.

final class ActionLocationProvider
    extends
        $FunctionalProvider<
          AsyncValue<Location?>,
          Location?,
          FutureOr<Location?>
        >
    with $FutureModifier<Location?>, $FutureProvider<Location?> {
  /// Fetches the [Location] associated with an action's [locationId].
  ///
  /// Returns `null` if the action has no location requirement.
  /// This is used by the video review screen to perform on-device geo-fence
  /// pre-validation before submission.
  ActionLocationProvider._({
    required ActionLocationFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'actionLocationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$actionLocationHash();

  @override
  String toString() {
    return r'actionLocationProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Location?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Location?> create(Ref ref) {
    final argument = this.argument as int;
    return actionLocation(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ActionLocationProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$actionLocationHash() => r'1e8f3a595afae112447317482d1cdf85a6e8a48a';

/// Fetches the [Location] associated with an action's [locationId].
///
/// Returns `null` if the action has no location requirement.
/// This is used by the video review screen to perform on-device geo-fence
/// pre-validation before submission.

final class ActionLocationFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Location?>, int> {
  ActionLocationFamily._()
    : super(
        retry: null,
        name: r'actionLocationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches the [Location] associated with an action's [locationId].
  ///
  /// Returns `null` if the action has no location requirement.
  /// This is used by the video review screen to perform on-device geo-fence
  /// pre-validation before submission.

  ActionLocationProvider call(int actionId) =>
      ActionLocationProvider._(argument: actionId, from: this);

  @override
  String toString() => r'actionLocationProvider';
}
