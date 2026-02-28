// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rewards_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches all rewards earned by the authenticated user.

@ProviderFor(userRewards)
final userRewardsProvider = UserRewardsProvider._();

/// Fetches all rewards earned by the authenticated user.

final class UserRewardsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UserReward>>,
          List<UserReward>,
          FutureOr<List<UserReward>>
        >
    with $FutureModifier<List<UserReward>>, $FutureProvider<List<UserReward>> {
  /// Fetches all rewards earned by the authenticated user.
  UserRewardsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userRewardsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userRewardsHash();

  @$internal
  @override
  $FutureProviderElement<List<UserReward>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<UserReward>> create(Ref ref) {
    return userRewards(ref);
  }
}

String _$userRewardsHash() => r'905241cea4a2ab1fca2c16de55914fad45c5d32d';

/// Fetches the leaderboard of top users by reward points.

@ProviderFor(leaderboard)
final leaderboardProvider = LeaderboardProvider._();

/// Fetches the leaderboard of top users by reward points.

final class LeaderboardProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UserReward>>,
          List<UserReward>,
          FutureOr<List<UserReward>>
        >
    with $FutureModifier<List<UserReward>>, $FutureProvider<List<UserReward>> {
  /// Fetches the leaderboard of top users by reward points.
  LeaderboardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leaderboardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leaderboardHash();

  @$internal
  @override
  $FutureProviderElement<List<UserReward>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<UserReward>> create(Ref ref) {
    return leaderboard(ref);
  }
}

String _$leaderboardHash() => r'b197ae78de70d58e4b8adff06ddf6590bbf03c0c';
