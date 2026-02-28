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

String _$actionDetailHash() => r'ad7e736fa0439eae6d1adf946118bda17a06efc3';

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
