import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import 'package:verily_server/src/exceptions/server_exceptions.dart';
import 'package:verily_server/src/generated/protocol.dart';
import 'package:verily_server/src/services/solana_service.dart';

/// In-memory challenge store with TTL.
///
/// In production, use Redis or a dedicated challenge table.
final _challenges = <String, _ChallengeEntry>{};

class _ChallengeEntry {
  _ChallengeEntry(this.nonce, this.expiresAt);
  final String nonce;
  final DateTime expiresAt;
  bool get isExpired => DateTime.now().toUtc().isAfter(expiresAt);
}

/// Endpoint for Solana wallet-based authentication.
///
/// Implements a challenge-response flow:
/// 1. Client requests a challenge nonce via [requestChallenge].
/// 2. Client signs the nonce with their wallet private key.
/// 3. Client submits the signed challenge via [verifyChallenge].
/// 4. Server verifies the Ed25519 signature and creates/returns the wallet.
class AuthWalletEndpoint extends Endpoint {
  @override
  bool get requireLogin => false;

  /// Generates a challenge nonce for wallet authentication.
  ///
  /// Returns a base64-encoded random nonce that the client must sign.
  Future<String> requestChallenge(Session session, String publicKey) async {
    if (publicKey.length < 32 || publicKey.length > 44) {
      throw ValidationException('Invalid Solana public key format');
    }

    // Clean up expired challenges.
    _challenges.removeWhere((_, entry) => entry.isExpired);

    // Generate a random 32-byte nonce.
    final random = Random.secure();
    final nonceBytes = Uint8List(32);
    for (var i = 0; i < 32; i++) {
      nonceBytes[i] = random.nextInt(256);
    }

    final nonce = base64Encode(nonceBytes);

    _challenges[publicKey] = _ChallengeEntry(
      nonce,
      DateTime.now().toUtc().add(const Duration(minutes: 5)),
    );

    return nonce;
  }

  /// Verifies a signed challenge and authenticates the user.
  ///
  /// Returns the linked [SolanaWallet] on success.
  Future<SolanaWallet> verifyChallenge(
    Session session,
    String publicKey,
    String signatureBase64,
  ) async {
    final entry = _challenges[publicKey];
    if (entry == null || entry.isExpired) {
      _challenges.remove(publicKey);
      throw ValidationException(
        'No pending challenge found. Request a new challenge first.',
      );
    }

    // Verify the signature.
    final message = base64Decode(entry.nonce);
    final signature = base64Decode(signatureBase64);

    final isValid = SolanaService.verifySignature(
      publicKey: publicKey,
      signature: Uint8List.fromList(signature),
      message: Uint8List.fromList(message),
    );

    if (!isValid) {
      throw ValidationException('Invalid signature');
    }

    // Consume the challenge.
    _challenges.remove(publicKey);

    // Find existing wallet or create new one.
    final existingWallets = await SolanaWallet.db.find(
      session,
      where: (t) => t.publicKey.equals(publicKey),
      limit: 1,
    );

    if (existingWallets.isNotEmpty) {
      return existingWallets.first;
    }

    // Create a new wallet record for this user.
    final wallet = SolanaWallet(
      userId: UuidValue.fromString(const Uuid().v4()),
      publicKey: publicKey,
      walletType: 'external',
      isDefault: true,
      label: 'Mobile Wallet',
      createdAt: DateTime.now().toUtc(),
    );

    return SolanaWallet.db.insertRow(session, wallet);
  }
}
