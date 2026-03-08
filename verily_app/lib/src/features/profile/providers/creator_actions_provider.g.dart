// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'creator_actions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches actions created by the authenticated user.

@ProviderFor(creatorActions)
final creatorActionsProvider = CreatorActionsProvider._();

/// Fetches actions created by the authenticated user.

final class CreatorActionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Action>>,
          List<Action>,
          FutureOr<List<Action>>
        >
    with $FutureModifier<List<Action>>, $FutureProvider<List<Action>> {
  /// Fetches actions created by the authenticated user.
  CreatorActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'creatorActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$creatorActionsHash();

  @$internal
  @override
  $FutureProviderElement<List<Action>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Action>> create(Ref ref) {
    return creatorActions(ref);
  }
}

String _$creatorActionsHash() => r'0fc361932dfa3743b2c0e3bd9bbf18b1efc33993';
