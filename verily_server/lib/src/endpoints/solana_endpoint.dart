import 'package:serverpod/serverpod.dart';
import 'package:verily_core/verily_core.dart';

import '../generated/protocol.dart';
import '../services/solana_service.dart';

/// Endpoint for Solana wallet management.
///
/// Allows users to create custodial wallets, link external wallets,
/// and query balances.
class SolanaEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Creates a custodial wallet for the authenticated user.
  Future<SolanaWallet> createWallet(
    Session session, {
    String? label,
  }) async {
    final userId =
        UuidValue.fromString(session.authenticated!.userId.toString());
    return SolanaService.createCustodialWallet(
      session,
      userId: userId,
      label: label,
    );
  }

  /// Links an external Solana wallet.
  Future<SolanaWallet> linkWallet(
    Session session,
    String publicKey, {
    String? label,
  }) async {
    final userId =
        UuidValue.fromString(session.authenticated!.userId.toString());
    return SolanaService.linkExternalWallet(
      session,
      userId: userId,
      publicKey: publicKey,
      label: label,
    );
  }

  /// Lists all wallets for the authenticated user.
  Future<List<SolanaWallet>> getWallets(Session session) async {
    final userId =
        UuidValue.fromString(session.authenticated!.userId.toString());
    return SolanaService.getUserWallets(session, userId: userId);
  }

  /// Sets a wallet as the user's default for receiving rewards.
  Future<SolanaWallet> setDefaultWallet(
    Session session,
    int walletId,
  ) async {
    final userId =
        UuidValue.fromString(session.authenticated!.userId.toString());
    return SolanaService.setDefaultWallet(
      session,
      userId: userId,
      walletId: walletId,
    );
  }

  /// Gets the SOL balance of the user's default wallet.
  Future<double> getBalance(Session session) async {
    final userId =
        UuidValue.fromString(session.authenticated!.userId.toString());
    final wallet =
        await SolanaService.getDefaultWallet(session, userId: userId);
    if (wallet == null) return 0;
    return SolanaService.getBalance(session, publicKey: wallet.publicKey);
  }
}
