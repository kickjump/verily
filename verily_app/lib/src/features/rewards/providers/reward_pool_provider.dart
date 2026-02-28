import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:verily_app/src/app/providers/serverpod_client_provider.dart';
import 'package:verily_client/verily_client.dart';

part 'reward_pool_provider.g.dart';

/// Fetches a single reward pool by its database [poolId].
@riverpod
Future<RewardPool> fetchRewardPool(Ref ref, int poolId) async {
  final client = ref.watch(serverpodClientProvider);
  return client.rewardPool.get(poolId);
}

/// Fetches all reward pools for an [actionId].
@riverpod
Future<List<RewardPool>> rewardPoolsByAction(Ref ref, int actionId) async {
  final client = ref.watch(serverpodClientProvider);
  return client.rewardPool.listByAction(actionId);
}

/// Fetches distributions for a reward pool.
@riverpod
Future<List<RewardDistribution>> rewardDistributions(
  Ref ref,
  int poolId,
) async {
  final client = ref.watch(serverpodClientProvider);
  return client.rewardPool.getDistributions(poolId);
}

/// Manages reward pool creation.
@riverpod
class RewardPoolNotifier extends _$RewardPoolNotifier {
  @override
  AsyncValue<RewardPool?> build() => const AsyncData(null);

  /// Creates a new reward pool for the given [actionId].
  Future<RewardPool?> create({
    required int actionId,
    required String rewardType,
    required double totalAmount,
    required double perPersonAmount,
    String? tokenMintAddress,
    int? maxRecipients,
    DateTime? expiresAt,
  }) async {
    state = const AsyncLoading();
    try {
      final client = ref.read(serverpodClientProvider);
      final pool = await client.rewardPool.create(
        actionId,
        rewardType,
        totalAmount,
        perPersonAmount,
        tokenMintAddress: tokenMintAddress,
        maxRecipients: maxRecipients,
        expiresAt: expiresAt,
      );
      state = AsyncData(pool);
      return pool;
    } on Exception catch (e, st) {
      debugPrint('Failed to create reward pool: $e');
      state = AsyncError(e, st);
      return null;
    }
  }

  /// Cancels a reward pool by [poolId].
  Future<RewardPool?> cancel(int poolId) async {
    state = const AsyncLoading();
    try {
      final client = ref.read(serverpodClientProvider);
      final pool = await client.rewardPool.cancel(poolId);
      state = AsyncData(pool);
      return pool;
    } on Exception catch (e, st) {
      debugPrint('Failed to cancel reward pool: $e');
      state = AsyncError(e, st);
      return null;
    }
  }

  void reset() {
    state = const AsyncData(null);
  }
}
