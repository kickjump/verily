import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/auth/auth_provider.dart';
import 'package:verily_app/src/features/auth/solana_wallet_auth_provider.dart';
import 'package:verily_ui/verily_ui.dart';

/// A "Connect Wallet" button that only renders on Android (MWA-supported).
///
/// On non-Android platforms this widget renders [SizedBox.shrink].
class WalletLoginButton extends HookConsumerWidget {
  const WalletLoginButton({super.key, this.isLoading = false});

  final bool isLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!isMwaSupported) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final walletState = ref.watch(walletAuthProvider);
    final isConnecting = walletState is WalletAuthConnecting;

    ref.listen(walletAuthProvider, (previous, next) {
      if (next is WalletAuthConnected && next.publicKey.isNotEmpty) {
        ref
            .read(authProvider.notifier)
            .loginWithWallet(publicKey: next.publicKey);
      }
      if (next is WalletAuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: SpacingTokens.sm),
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.md),
              child: Text(
                'or',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: SpacingTokens.sm),
        _SolanaWalletButton(
          isLoading: isLoading || isConnecting,
          onPressed: isLoading || isConnecting
              ? null
              : () => ref.read(walletAuthProvider.notifier).connect(),
        ),
      ],
    );
  }
}

class _SolanaWalletButton extends HookWidget {
  const _SolanaWalletButton({required this.isLoading, this.onPressed});

  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF9945FF),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: SpacingTokens.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.md),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Solana logo placeholder
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(30),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                    child: Text(
                      'S',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: SpacingTokens.sm),
                Text(
                  'Connect Wallet',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }
}
