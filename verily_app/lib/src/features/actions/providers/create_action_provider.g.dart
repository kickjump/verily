// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_action_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages the lifecycle of creating a new action on the server.

@ProviderFor(CreateAction)
final createActionProvider = CreateActionProvider._();

/// Manages the lifecycle of creating a new action on the server.
final class CreateActionProvider
    extends $NotifierProvider<CreateAction, AsyncValue<Action?>> {
  /// Manages the lifecycle of creating a new action on the server.
  CreateActionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createActionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createActionHash();

  @$internal
  @override
  CreateAction create() => CreateAction();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Action?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Action?>>(value),
    );
  }
}

String _$createActionHash() => r'2164d399b62517e2cd2afd8c7b1e0eeec7bd39ec';

/// Manages the lifecycle of creating a new action on the server.

abstract class _$CreateAction extends $Notifier<AsyncValue<Action?>> {
  AsyncValue<Action?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Action?>, AsyncValue<Action?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Action?>, AsyncValue<Action?>>,
              AsyncValue<Action?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
