import 'dart:math';

import 'package:serverpod/serverpod.dart';
import 'package:verily_core/verily_core.dart';

import '../exceptions/server_exceptions.dart';
import '../generated/protocol.dart';

/// Service for Solana blockchain operations including wallet management,
/// token transfers, and NFT minting.
///
/// For MVP, this uses a simplified approach:
/// - Custodial wallets generate keypairs server-side
/// - External wallets store only the public key
/// - Actual on-chain operations require solana_kit integration
///
/// All methods are static and accept a [Session] as the first parameter.
class SolanaService {
  SolanaService._();

  static final _log = VLogger('SolanaService');

  /// The Solana cluster RPC URL. Reads from passwords.yaml.
  static String _getRpcUrl(Session session) {
    return session.passwords['solanaRpcUrl'] ??
        'https://api.devnet.solana.com';
  }

  // ---------------------------------------------------------------------------
  // Wallet management
  // ---------------------------------------------------------------------------

  /// Creates a custodial wallet for a user.
  ///
  /// The server generates and stores the keypair. In production, use a
  /// proper key management service (KMS).
  static Future<SolanaWallet> createCustodialWallet(
    Session session, {
    required UuidValue userId,
    String? label,
  }) async {
    // TODO: Replace with actual solana_kit keypair generation:
    // final keyPair = generateKeyPair();
    // final publicKey = getAddressFromPublicKey(keyPair.publicKey);
    //
    // For now, generate a placeholder public key.
    final publicKey = _generatePlaceholderPublicKey();

    // Check if user already has a wallet with this public key.
    final existing = await SolanaWallet.db.find(
      session,
      where: (t) => t.publicKey.equals(publicKey),
      limit: 1,
    );
    if (existing.isNotEmpty) {
      return existing.first;
    }

    // Check if user already has a default wallet.
    final hasDefault = await _hasDefaultWallet(session, userId: userId);

    final wallet = SolanaWallet(
      userId: userId,
      publicKey: publicKey,
      walletType: 'custodial',
      isDefault: !hasDefault,
      label: label ?? 'Default Wallet',
      createdAt: DateTime.now().toUtc(),
    );

    final inserted = await SolanaWallet.db.insertRow(session, wallet);
    _log.info(
      'Created custodial wallet for user $userId: ${inserted.publicKey}',
    );
    return inserted;
  }

  /// Links an external wallet (user provides their public key).
  static Future<SolanaWallet> linkExternalWallet(
    Session session, {
    required UuidValue userId,
    required String publicKey,
    String? label,
  }) async {
    // Validate the public key format (base58, 32-44 chars).
    if (publicKey.length < 32 || publicKey.length > 44) {
      throw ValidationException(
        'Invalid Solana public key format',
      );
    }

    // Check for duplicate.
    final existing = await SolanaWallet.db.find(
      session,
      where: (t) => t.publicKey.equals(publicKey),
      limit: 1,
    );
    if (existing.isNotEmpty) {
      if (existing.first.userId != userId) {
        throw ValidationException(
          'This wallet is already linked to another account',
        );
      }
      return existing.first;
    }

    final hasDefault = await _hasDefaultWallet(session, userId: userId);

    final wallet = SolanaWallet(
      userId: userId,
      publicKey: publicKey,
      walletType: 'external',
      isDefault: !hasDefault,
      label: label ?? 'External Wallet',
      createdAt: DateTime.now().toUtc(),
    );

    final inserted = await SolanaWallet.db.insertRow(session, wallet);
    _log.info('Linked external wallet for user $userId: $publicKey');
    return inserted;
  }

  /// Gets all wallets for a user.
  static Future<List<SolanaWallet>> getUserWallets(
    Session session, {
    required UuidValue userId,
  }) async {
    return SolanaWallet.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      orderBy: (t) => t.createdAt,
    );
  }

  /// Gets the user's default wallet.
  static Future<SolanaWallet?> getDefaultWallet(
    Session session, {
    required UuidValue userId,
  }) async {
    final wallets = await SolanaWallet.db.find(
      session,
      where: (t) => t.userId.equals(userId) & t.isDefault.equals(true),
      limit: 1,
    );
    return wallets.isEmpty ? null : wallets.first;
  }

  /// Sets a wallet as the default for a user.
  static Future<SolanaWallet> setDefaultWallet(
    Session session, {
    required UuidValue userId,
    required int walletId,
  }) async {
    // Verify wallet belongs to user.
    final wallet = await SolanaWallet.db.findById(session, walletId);
    if (wallet == null || wallet.userId != userId) {
      throw NotFoundException('Wallet not found');
    }

    // Unset all other defaults.
    final userWallets = await getUserWallets(session, userId: userId);
    for (final w in userWallets) {
      if (w.isDefault && w.id != walletId) {
        w.isDefault = false;
        await SolanaWallet.db.updateRow(session, w);
      }
    }

    // Set this one as default.
    wallet.isDefault = true;
    final updated = await SolanaWallet.db.updateRow(session, wallet);
    _log.info('Set default wallet for user $userId: ${wallet.publicKey}');
    return updated;
  }

  // ---------------------------------------------------------------------------
  // Balance queries
  // ---------------------------------------------------------------------------

  /// Gets the SOL balance for a wallet.
  ///
  /// Returns balance in SOL (not lamports).
  static Future<double> getBalance(
    Session session, {
    required String publicKey,
  }) async {
    // TODO: Integrate with solana_kit RPC:
    // final rpc = createSolanaRpc(_getRpcUrl(session));
    // final balance = await rpc.getBalance(Address.fromBase58(publicKey)).send();
    // return balance.value / 1e9; // lamports to SOL
    _log.info('getBalance called for $publicKey (stub)');
    return 0.0;
  }

  /// Gets the SPL token balance for a wallet.
  static Future<double> getTokenBalance(
    Session session, {
    required String publicKey,
    required String mintAddress,
  }) async {
    // TODO: Integrate with solana_kit RPC for SPL token balance
    _log.info(
      'getTokenBalance called for $publicKey, mint $mintAddress (stub)',
    );
    return 0.0;
  }

  // ---------------------------------------------------------------------------
  // Reward distribution
  // ---------------------------------------------------------------------------

  /// Distributes a reward from a pool to a performer's wallet.
  ///
  /// Creates a RewardDistribution record and initiates the on-chain transfer.
  static Future<RewardDistribution> distributeReward(
    Session session, {
    required int rewardPoolId,
    required UuidValue recipientId,
    required int submissionId,
  }) async {
    final pool = await RewardPool.db.findById(session, rewardPoolId);
    if (pool == null) {
      throw NotFoundException('Reward pool $rewardPoolId not found');
    }

    if (pool.status != PoolStatus.active.value) {
      throw ValidationException('Reward pool is not active');
    }

    if (pool.remainingAmount < pool.perPersonAmount) {
      throw ValidationException('Insufficient funds in reward pool');
    }

    // Check max recipients.
    if (pool.maxRecipients != null) {
      final distributionCount = await RewardDistribution.db.count(
        session,
        where: (t) =>
            t.rewardPoolId.equals(rewardPoolId) &
            t.status.notEquals(DistributionStatus.failed.value),
      );
      if (distributionCount >= pool.maxRecipients!) {
        throw ValidationException('Maximum recipients reached for this pool');
      }
    }

    // Check for duplicate distribution.
    final existing = await RewardDistribution.db.find(
      session,
      where: (t) =>
          t.rewardPoolId.equals(rewardPoolId) &
          t.submissionId.equals(submissionId),
      limit: 1,
    );
    if (existing.isNotEmpty) {
      _log.info(
        'Distribution already exists for pool $rewardPoolId, '
        'submission $submissionId',
      );
      return existing.first;
    }

    // Calculate amounts.
    final platformFee = pool.perPersonAmount * (pool.platformFeePercent / 100);
    final performerAmount = pool.perPersonAmount - platformFee;

    // Create distribution record.
    final distribution = RewardDistribution(
      rewardPoolId: rewardPoolId,
      recipientId: recipientId,
      submissionId: submissionId,
      amount: performerAmount,
      status: DistributionStatus.pending.value,
      createdAt: DateTime.now().toUtc(),
    );

    final inserted =
        await RewardDistribution.db.insertRow(session, distribution);

    // Deduct from pool.
    pool.remainingAmount -= pool.perPersonAmount;
    if (pool.remainingAmount <= 0) {
      pool.status = PoolStatus.depleted.value;
      pool.remainingAmount = 0;
    }
    await RewardPool.db.updateRow(session, pool);

    // TODO: Initiate on-chain transfer via solana_kit
    // try {
    //   final txSig = await _sendSolTransfer(session, ...);
    //   inserted.txSignature = txSig;
    //   inserted.status = DistributionStatus.sent.value;
    //   await RewardDistribution.db.updateRow(session, inserted);
    // } catch (e) {
    //   inserted.status = DistributionStatus.failed.value;
    //   await RewardDistribution.db.updateRow(session, inserted);
    //   // Re-credit the pool.
    //   pool.remainingAmount += pool.perPersonAmount;
    //   pool.status = PoolStatus.active.value;
    //   await RewardPool.db.updateRow(session, pool);
    // }

    _log.info(
      'Created distribution from pool $rewardPoolId to $recipientId: '
      '$performerAmount (fee: $platformFee)',
    );
    return inserted;
  }

  /// Mints an NFT badge for action completion.
  ///
  /// Returns the transaction signature.
  static Future<String?> mintBadgeNft(
    Session session, {
    required UuidValue recipientId,
    required int actionId,
    required String metadataUri,
  }) async {
    // TODO: Integrate with solana_kit for Metaplex NFT minting
    _log.info(
      'mintBadgeNft called for user $recipientId, action $actionId (stub)',
    );
    return null;
  }

  // ---------------------------------------------------------------------------
  // Pool lifecycle
  // ---------------------------------------------------------------------------

  /// Processes expired reward pools.
  ///
  /// Should be called periodically (e.g., via a cron job or future call).
  static Future<int> processExpiredPools(Session session) async {
    final now = DateTime.now().toUtc();
    final expiredPools = await RewardPool.db.find(
      session,
      where: (t) =>
          t.status.equals(PoolStatus.active.value) &
          t.expiresAt.notEquals(null) &
          t.expiresAt <= now,
    );

    for (final pool in expiredPools) {
      pool.status = PoolStatus.expired.value;
      await RewardPool.db.updateRow(session, pool);
      _log.info('Expired reward pool id=${pool.id}');

      // TODO: Refund remaining amount to creator's wallet
    }

    return expiredPools.length;
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  static Future<bool> _hasDefaultWallet(
    Session session, {
    required UuidValue userId,
  }) async {
    final count = await SolanaWallet.db.count(
      session,
      where: (t) => t.userId.equals(userId) & t.isDefault.equals(true),
    );
    return count > 0;
  }

  /// Generates a placeholder base58 public key for development.
  static String _generatePlaceholderPublicKey() {
    const chars =
        '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
    final random = Random.secure();
    return List.generate(44, (_) => chars[random.nextInt(chars.length)]).join();
  }
}
