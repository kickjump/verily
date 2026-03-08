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
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isCreating = useState(false);
    final linkKeyController = useTextEditingController();

    Future<void> createWallet() async {
      isCreating.value = true;
      await ref
          .read(walletManagerProvider.notifier)
          .createCustodialWallet(label: l10n.walletMyVerilyWallet);
      if (context.mounted) {
        context.go(RouteNames.walletPath);
      }
    }

    Future<void> showLinkDialog() async {
      final publicKey = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.walletLinkWallet),
          content: VTextField(
            controller: linkKeyController,
            labelText: l10n.walletPublicKey,
            hintText: l10n.walletEnterSolanaPublicKey,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, linkKeyController.text),
              child: Text(l10n.walletLink),
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
              label: l10n.walletExternalWallet,
            );
        if (context.mounted) {
          context.go(RouteNames.walletPath);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.walletSetUpTitle)),
      body: Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: isDark
                  ? GradientTokens.shellBackground
                  : GradientTokens.shellBackgroundLight,
            ),
            child: const SizedBox.expand(),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(SpacingTokens.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(RadiusTokens.xl),
                      gradient: isDark
                          ? GradientTokens.heroCard
                          : GradientTokens.heroCardLight,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF15315E,
                          ).withValues(alpha: 0.22),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(SpacingTokens.lg),
                      child: Column(
                        children: [
                          Container(
                            width: 82,
                            height: 82,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                RadiusTokens.lg,
                              ),
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                            child: Icon(
                              Icons.account_balance_wallet,
                              size: 42,
                              color: isDark
                                  ? Colors.white
                                  : ColorTokens.primary,
                            ),
                          ),
                          const SizedBox(height: SpacingTokens.md),
                          Text(
                            l10n.walletYourVerilyWallet,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : ColorTokens.ink,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: SpacingTokens.sm),
                          Text(
                            l10n.walletSetupDescription,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.86)
                                  : ColorTokens.ink.withValues(alpha: 0.72),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  VCard(
                    padding: const EdgeInsets.all(SpacingTokens.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        VFilledButton(
                          onPressed: isCreating.value ? null : createWallet,
                          child: isCreating.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(l10n.walletCreateWallet),
                        ),
                        const SizedBox(height: SpacingTokens.sm),
                        VOutlinedButton(
                          onPressed: isCreating.value ? null : showLinkDialog,
                          child: Text(l10n.walletLinkExisting),
                        ),
                        const SizedBox(height: SpacingTokens.xs),
                        VTextButton(
                          onPressed: isCreating.value
                              ? null
                              : () => context.go(RouteNames.feedPath),
                          child: Text(l10n.walletSkipForNow),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
