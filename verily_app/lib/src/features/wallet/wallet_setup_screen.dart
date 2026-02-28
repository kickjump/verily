import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/wallet/wallet_provider.dart';
import 'package:verily_app/src/routing/route_names.dart';
import 'package:verily_ui/verily_ui.dart';

/// Initial wallet setup screen shown during onboarding.
class WalletSetupScreen extends HookConsumerWidget {
  const WalletSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCreating = useState(false);
    final linkKeyController = useTextEditingController();

    Future<void> createWallet() async {
      isCreating.value = true;
      await ref
          .read(walletManagerProvider.notifier)
          .createCustodialWallet(label: 'My Verily Wallet');
      if (context.mounted) {
        context.go(RouteNames.walletPath);
      }
    }

    Future<void> showLinkDialog() async {
      final publicKey = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Link Wallet'),
          content: VTextField(
            controller: linkKeyController,
            labelText: 'Public Key',
            hintText: 'Enter your Solana public key',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, linkKeyController.text),
              child: const Text('Link'),
            ),
          ],
        ),
      );

      if (publicKey != null && publicKey.isNotEmpty && context.mounted) {
        isCreating.value = true;
        await ref
            .read(walletManagerProvider.notifier)
            .linkExternalWallet(publicKey: publicKey, label: 'External Wallet');
        if (context.mounted) {
          context.go(RouteNames.walletPath);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Set Up Wallet')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),

            // Icon
            Icon(
              Icons.account_balance_wallet,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              'Your Verily Wallet',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              'Create a wallet to receive SOL, tokens, and NFT rewards '
              'for completing actions. You can also link an existing '
              'Solana wallet.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),

            const Spacer(),

            // Create wallet button
            VFilledButton(
              onPressed: isCreating.value ? null : createWallet,
              child: isCreating.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create Wallet'),
            ),
            const SizedBox(height: 12),

            // Link existing wallet
            VOutlinedButton(
              onPressed: isCreating.value ? null : showLinkDialog,
              child: const Text('Link Existing Wallet'),
            ),

            const SizedBox(height: 12),

            // Skip for now
            VTextButton(
              onPressed: isCreating.value
                  ? null
                  : () => context.go(RouteNames.feedPath),
              child: const Text('Skip for now'),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
