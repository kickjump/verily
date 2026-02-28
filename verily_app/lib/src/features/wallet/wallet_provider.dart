import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:verily_app/src/app/providers/serverpod_client_provider.dart';
import 'package:verily_client/verily_client.dart';

part 'wallet_provider.g.dart';

/// Provides the list of wallets for the authenticated user.
@riverpod
Future<List<SolanaWallet>> userWallets(Ref ref) async {
  final client = ref.watch(serverpodClientProvider);
  try {
    return await client.solana.getWallets();
  } on Exception catch (e) {
    debugPrint('Failed to fetch wallets: $e');
    return [];
  }
}

/// Provides the SOL balance of the user's default wallet.
@riverpod
Future<double> walletBalance(Ref ref) async {
  final client = ref.watch(serverpodClientProvider);
  try {
    return await client.solana.getBalance();
  } on Exception catch (e) {
    debugPrint('Failed to fetch balance: $e');
    return 0.0;
  }
}

/// Manages wallet creation and linking.
@Riverpod(keepAlive: true)
class WalletManager extends _$WalletManager {
  @override
  AsyncValue<SolanaWallet?> build() => const AsyncData(null);

  /// Creates a custodial wallet for the authenticated user.
  Future<void> createCustodialWallet({String? label}) async {
    state = const AsyncLoading();
    try {
      final client = ref.read(serverpodClientProvider);
      final wallet = await client.solana.createWallet(label: label);
      state = AsyncData(wallet);
      // Invalidate wallet list and balance to refresh.
      ref.invalidate(userWalletsProvider);
      ref.invalidate(walletBalanceProvider);
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Links an external wallet by public key.
  Future<void> linkExternalWallet({
    required String publicKey,
    String? label,
  }) async {
    state = const AsyncLoading();
    try {
      final client = ref.read(serverpodClientProvider);
      final wallet = await client.solana.linkWallet(publicKey, label: label);
      state = AsyncData(wallet);
      ref.invalidate(userWalletsProvider);
      ref.invalidate(walletBalanceProvider);
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Sets a wallet as the default for receiving rewards.
  Future<void> setDefault(int walletId) async {
    state = const AsyncLoading();
    try {
      final client = ref.read(serverpodClientProvider);
      final wallet = await client.solana.setDefaultWallet(walletId);
      state = AsyncData(wallet);
      ref.invalidate(userWalletsProvider);
      ref.invalidate(walletBalanceProvider);
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
