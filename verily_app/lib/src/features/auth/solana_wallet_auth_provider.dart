import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'solana_wallet_auth_provider.g.dart';

/// Whether the current platform supports Mobile Wallet Adapter.
///
/// MWA is only available on Android devices (not web, iOS, macOS, etc.).
bool get isMwaSupported =>
    !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

/// State for a wallet auth connection attempt.
sealed class WalletAuthState {
  const WalletAuthState();
}

class WalletAuthIdle extends WalletAuthState {
  const WalletAuthIdle();
}

class WalletAuthConnecting extends WalletAuthState {
  const WalletAuthConnecting();
}

class WalletAuthConnected extends WalletAuthState {
  const WalletAuthConnected({required this.publicKey, required this.authToken});

  final String publicKey;
  final String authToken;
}

class WalletAuthError extends WalletAuthState {
  const WalletAuthError(this.message);
  final String message;
}

/// Provides wallet authentication state and operations via Mobile Wallet
/// Adapter on Android.
@Riverpod(keepAlive: true)
class WalletAuth extends _$WalletAuth {
  @override
  WalletAuthState build() => const WalletAuthIdle();

  /// Attempts to connect to a wallet app via Mobile Wallet Adapter.
  ///
  /// This only works on Android. On other platforms it returns an error state.
  Future<void> connect() async {
    if (!isMwaSupported) {
      state = const WalletAuthError(
        'Mobile Wallet Adapter is only supported on Android.',
      );
      return;
    }

    state = const WalletAuthConnecting();

    try {
      // Generate a nonce for the Sign In With Solana flow.
      final nonce = _generateNonce();

      // Build the sign-in payload. The actual MWA session connection
      // requires Android-specific intent handling that will be bridged
      // through platform channels.
      final payload = <String, dynamic>{
        'domain': 'verily.fun',
        'statement': 'Sign in to Verily',
        'nonce': nonce,
        'issuedAt': DateTime.now().toUtc().toIso8601String(),
      };

      state = WalletAuthConnected(
        publicKey: '', // Filled after MWA handshake completes
        authToken: jsonEncode(payload),
      );
    } on Exception catch (e) {
      debugPrint('Wallet connection failed: $e');
      state = WalletAuthError('Failed to connect wallet: $e');
    }
  }

  /// Completes wallet authentication with the public key from MWA.
  void completeWithPublicKey(String publicKey) {
    final current = state;
    if (current is WalletAuthConnected) {
      state = WalletAuthConnected(
        publicKey: publicKey,
        authToken: current.authToken,
      );
    }
  }

  /// Disconnects the current wallet session.
  void disconnect() {
    state = const WalletAuthIdle();
  }

  /// Generates a random nonce string.
  String _generateNonce() {
    final random = Random.secure();
    final bytes = List.generate(16, (_) => random.nextInt(256));
    return base64Encode(bytes);
  }
}
