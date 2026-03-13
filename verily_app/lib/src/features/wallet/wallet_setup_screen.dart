import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/l10n/generated/app_localizations.dart';
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
          .createCustodialWallet(
            label: AppLocalizations.of(context).walletMyVerilyWallet,
          );
      if (context.mounted) {
        context.go(RouteNames.walletPath);
      }
    }

    Future<void> showLinkDialog() async {
      final publicKey = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(AppLocalizations.of(ctx).walletLinkWallet),
          content: VTextField(
            controller: linkKeyController,
            labelText: AppLocalizations.of(ctx).walletPublicKey,
            hintText: AppLocalizations.of(ctx).walletEnterSolanaPublicKey,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(AppLocalizations.of(ctx).cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, linkKeyController.text),
              child: Text(AppLocalizations.of(ctx).walletLink),
            ),
          ],
        ),
      );

      if (publicKey != null && publicKey.isNotEmpty && context.mounted) {
        isCreating.value = true;
        await ref
            .read(walletManagerProvider.notifier)
            .linkExternalWallet(
              publicKey: publicKey,
              label: AppLocalizations.of(context).walletExternalWallet,
            );
        if (context.mounted) {
          context.go(RouteNames.walletPath);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).walletSetUpTitle),
      ),
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
                  : Text(AppLocalizations.of(context).walletCreateWallet),
            ),
            const SizedBox(height: 12),

            // Link existing wallet
            VOutlinedButton(
              onPressed: isCreating.value ? null : showLinkDialog,
              child: Text(AppLocalizations.of(context).walletLinkExisting),
            ),

            const SizedBox(height: 12),

            // Skip for now
            VTextButton(
              onPressed: isCreating.value
                  ? null
                  : () => context.go(RouteNames.feedPath),
              child: Text(AppLocalizations.of(context).walletSkipForNow),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
