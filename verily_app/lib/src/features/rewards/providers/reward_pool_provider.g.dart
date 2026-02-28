// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_pool_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches a single reward pool by its database [poolId].

@ProviderFor(fetchRewardPool)
final fetchRewardPoolProvider = FetchRewardPoolFamily._();

/// Fetches a single reward pool by its database [poolId].

final class FetchRewardPoolProvider
    extends
        $FunctionalProvider<
          AsyncValue<RewardPool>,
          RewardPool,
          FutureOr<RewardPool>
        >
    with $FutureModifier<RewardPool>, $FutureProvider<RewardPool> {
  /// Fetches a single reward pool by its database [poolId].
  FetchRewardPoolProvider._({
    required FetchRewardPoolFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'fetchRewardPoolProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fetchRewardPoolHash();

  @override
  String toString() {
    return r'fetchRewardPoolProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<RewardPool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<RewardPool> create(Ref ref) {
    final argument = this.argument as int;
    return fetchRewardPool(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchRewardPoolProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fetchRewardPoolHash() => r'bf1e5acbfc56de5851aaec354bf5cf0c934b8f1b';

/// Fetches a single reward pool by its database [poolId].

final class FetchRewardPoolFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<RewardPool>, int> {
  FetchRewardPoolFamily._()
    : super(
        retry: null,
        name: r'fetchRewardPoolProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches a single reward pool by its database [poolId].

  FetchRewardPoolProvider call(int poolId) =>
      FetchRewardPoolProvider._(argument: poolId, from: this);

  @override
  String toString() => r'fetchRewardPoolProvider';
}

/// Fetches all reward pools for an [actionId].

@ProviderFor(rewardPoolsByAction)
final rewardPoolsByActionProvider = RewardPoolsByActionFamily._();

/// Fetches all reward pools for an [actionId].

final class RewardPoolsByActionProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RewardPool>>,
          List<RewardPool>,
          FutureOr<List<RewardPool>>
        >
    with $FutureModifier<List<RewardPool>>, $FutureProvider<List<RewardPool>> {
  /// Fetches all reward pools for an [actionId].
  RewardPoolsByActionProvider._({
    required RewardPoolsByActionFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'rewardPoolsByActionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$rewardPoolsByActionHash();

  @override
  String toString() {
    return r'rewardPoolsByActionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<RewardPool>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RewardPool>> create(Ref ref) {
    final argument = this.argument as int;
    return rewardPoolsByAction(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RewardPoolsByActionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rewardPoolsByActionHash() =>
    r'ef2b891bbbcc4759403aca98e2e568f24f987d1e';

/// Fetches all reward pools for an [actionId].

final class RewardPoolsByActionFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<RewardPool>>, int> {
  RewardPoolsByActionFamily._()
    : super(
        retry: null,
        name: r'rewardPoolsByActionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches all reward pools for an [actionId].

  RewardPoolsByActionProvider call(int actionId) =>
      RewardPoolsByActionProvider._(argument: actionId, from: this);

  @override
  String toString() => r'rewardPoolsByActionProvider';
}

/// Fetches distributions for a reward pool.

@ProviderFor(rewardDistributions)
final rewardDistributionsProvider = RewardDistributionsFamily._();

/// Fetches distributions for a reward pool.

final class RewardDistributionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RewardDistribution>>,
          List<RewardDistribution>,
          FutureOr<List<RewardDistribution>>
        >
    with
        $FutureModifier<List<RewardDistribution>>,
        $FutureProvider<List<RewardDistribution>> {
  /// Fetches distributions for a reward pool.
  RewardDistributionsProvider._({
    required RewardDistributionsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'rewardDistributionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$rewardDistributionsHash();

  @override
  String toString() {
    return r'rewardDistributionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<RewardDistribution>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RewardDistribution>> create(Ref ref) {
    final argument = this.argument as int;
    return rewardDistributions(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RewardDistributionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rewardDistributionsHash() =>
    r'e5d79ce80ca1398994eed83a582be3f699e862bb';

/// Fetches distributions for a reward pool.

final class RewardDistributionsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<RewardDistribution>>, int> {
  RewardDistributionsFamily._()
    : super(
        retry: null,
        name: r'rewardDistributionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches distributions for a reward pool.

  RewardDistributionsProvider call(int poolId) =>
      RewardDistributionsProvider._(argument: poolId, from: this);

  @override
  String toString() => r'rewardDistributionsProvider';
}

/// Manages reward pool creation.

@ProviderFor(RewardPoolNotifier)
final rewardPoolProvider = RewardPoolNotifierProvider._();

/// Manages reward pool creation.
final class RewardPoolNotifierProvider
    extends $NotifierProvider<RewardPoolNotifier, AsyncValue<RewardPool?>> {
  /// Manages reward pool creation.
  RewardPoolNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rewardPoolProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rewardPoolNotifierHash();

  @$internal
  @override
  RewardPoolNotifier create() => RewardPoolNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<RewardPool?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<RewardPool?>>(value),
    );
  }
}

String _$rewardPoolNotifierHash() =>
    r'a976d891a6813d3a6d4e3ac54d80bbfd256d5e6e';

/// Manages reward pool creation.

abstract class _$RewardPoolNotifier extends $Notifier<AsyncValue<RewardPool?>> {
  AsyncValue<RewardPool?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<RewardPool?>, AsyncValue<RewardPool?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<RewardPool?>, AsyncValue<RewardPool?>>,
              AsyncValue<RewardPool?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
