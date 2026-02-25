// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_action_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stores the user-selected active action context for verification flow.

@ProviderFor(ActiveActionController)
final activeActionControllerProvider = ActiveActionControllerProvider._();

/// Stores the user-selected active action context for verification flow.
final class ActiveActionControllerProvider
    extends $NotifierProvider<ActiveActionController, ActiveAction?> {
  /// Stores the user-selected active action context for verification flow.
  ActiveActionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeActionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeActionControllerHash();

  @$internal
  @override
  ActiveActionController create() => ActiveActionController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActiveAction? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActiveAction?>(value),
    );
  }
}

String _$activeActionControllerHash() =>
    r'5c3c657b3d453b0ae54b46b2259cfc3cffd5c2dd';

/// Stores the user-selected active action context for verification flow.

abstract class _$ActiveActionController extends $Notifier<ActiveAction?> {
  ActiveAction? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ActiveAction?, ActiveAction?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ActiveAction?, ActiveAction?>,
              ActiveAction?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
