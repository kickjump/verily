import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/l10n/generated/app_localizations.dart';
import 'package:verily_app/src/common_widgets/shimmer_skeleton.dart';
import 'package:verily_app/src/features/wallet/wallet_provider.dart';
import 'package:verily_ui/verily_ui.dart';

/// Screen for managing Solana wallets and viewing balances.
class WalletScreen extends HookConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selectedTab = useState(0);
    final balanceAsync = ref.watch(walletBalanceProvider);
    final walletsAsync = ref.watch(userWalletsProvider);
    final walletCount =
        walletsAsync.whenOrNull(data: (wallets) => wallets.length) ?? 0;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(gradient: GradientTokens.shellBackground),
            child: SizedBox.expand(),
          ),
          SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                ref
                  ..invalidate(walletBalanceProvider)
                  ..invalidate(userWalletsProvider);
              },
              child: CustomScrollView(
                slivers: [
                  // App bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        SpacingTokens.lg,
                        SpacingTokens.lg,
                        SpacingTokens.lg,
                        SpacingTokens.md,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          Expanded(
                            child: Text(
                              l10n.walletTitle,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.white),
                            onPressed: () => _showAddWalletDialog(context, ref),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Balance card (animated)
                  SliverToBoxAdapter(
                    child:
                        Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: SpacingTokens.lg,
                              ),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: isDark
                                      ? GradientTokens.heroCard
                                      : GradientTokens.heroCardLight,
                                  borderRadius: BorderRadius.circular(
                                    RadiusTokens.xl,
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.15),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                    SpacingTokens.xl,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        l10n.walletTotalBalance,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: Colors.white.withValues(
                                                alpha: 0.7,
                                              ),
                                            ),
                                      ),
                                      const SizedBox(height: SpacingTokens.sm),
                                      balanceAsync.when(
                                        data: (balance) => Text(
                                          '${balance.toStringAsFixed(4)} SOL',
                                          style: theme.textTheme.headlineLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                        ),
                                        loading: () =>
                                            const ShimmerWalletBalance(),
                                        error: (_, __) => Text(
                                          '-- SOL',
                                          style: theme.textTheme.headlineLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(height: SpacingTokens.md),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          _WalletPill(
                                            icon: Icons
                                                .account_balance_wallet_outlined,
                                            label: l10n.walletCount(
                                              walletCount,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: SpacingTokens.sm,
                                          ),
                                          _WalletPill(
                                            icon: Icons.verified_outlined,
                                            label: l10n.walletSecureCustody,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: SpacingTokens.lg),
                                      // Action buttons
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          _WalletActionButton(
                                            icon: Icons.arrow_downward,
                                            label: l10n.walletReceive,
                                            onTap: () => _showReceiveDialog(
                                              context,
                                              ref,
                                            ),
                                          ),
                                          _WalletActionButton(
                                            icon: Icons.arrow_upward,
                                            label: l10n.walletSend,
                                            onTap: () {},
                                          ),
                                          _WalletActionButton(
                                            icon: Icons.refresh,
                                            label: l10n.walletRefresh,
                                            onTap: () {
                                              ref
                                                ..invalidate(
                                                  walletBalanceProvider,
                                                )
                                                ..invalidate(
                                                  userWalletsProvider,
                                                );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 500.ms, delay: 100.ms)
                            .slideY(
                              begin: 0.05,
                              end: 0,
                              duration: 500.ms,
                              delay: 100.ms,
                            ),
                  ),

                  // Wallets list
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        SpacingTokens.lg,
                        SpacingTokens.lg,
                        SpacingTokens.lg,
                        SpacingTokens.sm,
                      ),
                      child:
                          Text(
                                l10n.walletYourWallets,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 400.ms, delay: 300.ms)
                              .slideX(
                                begin: -0.05,
                                end: 0,
                                duration: 400.ms,
                                delay: 300.ms,
                              ),
                    ),
                  ),

                  walletsAsync.when(
                    data: (wallets) {
                      if (wallets.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(SpacingTokens.lg),
                            child: VCard(
                              padding: const EdgeInsets.all(SpacingTokens.xl),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.account_balance_wallet_outlined,
                                    size: 48,
                                    color: colorScheme.outline,
                                  ),
                                  const SizedBox(height: SpacingTokens.md),
                                  Text(
                                    l10n.walletNoWalletsYet,
                                    style: theme.textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: SpacingTokens.sm),
                                  Text(
                                    l10n.walletCreateOrConnect,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: SpacingTokens.lg),
                                  VFilledButton(
                                    onPressed: () =>
                                        _showAddWalletDialog(context, ref),
                                    child: Text(l10n.walletAddWallet),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      return SliverList.builder(
                        itemCount: wallets.length,
                        itemBuilder: (context, index) {
                          final wallet = wallets[index];
                          final shortKey =
                              '${wallet.publicKey.substring(0, 4)}...${wallet.publicKey.substring(wallet.publicKey.length - 4)}';
                          return RepaintBoundary(
                                key: ValueKey(wallet.id),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    SpacingTokens.lg,
                                    0,
                                    SpacingTokens.lg,
                                    SpacingTokens.sm,
                                  ),
                                  child: VCard(
                                    padding: const EdgeInsets.all(
                                      SpacingTokens.md,
                                    ),
                                    onTap: () {
                                      Clipboard.setData(
                                        ClipboardData(text: wallet.publicKey),
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            l10n.walletAddressCopied,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              RadiusTokens.sm,
                                            ),
                                            color: wallet.isDefault
                                                ? colorScheme.primaryContainer
                                                : colorScheme
                                                      .surfaceContainerHighest,
                                          ),
                                          child: Icon(
                                            wallet.walletType == 'custodial'
                                                ? Icons.lock_outline
                                                : Icons.link,
                                            color: wallet.isDefault
                                                ? colorScheme.primary
                                                : colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        const SizedBox(width: SpacingTokens.md),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    wallet.label ??
                                                        l10n.walletTitle,
                                                    style: theme
                                                        .textTheme
                                                        .titleSmall
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                  ),
                                                  if (wallet.isDefault) ...[
                                                    const SizedBox(
                                                      width: SpacingTokens.xs,
                                                    ),
                                                    VBadgeChip(
                                                      label: l10n.walletDefault,
                                                    ),
                                                  ],
                                                ],
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                shortKey,
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                      color: colorScheme
                                                          .onSurfaceVariant,
                                                      fontFamily: 'monospace',
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          wallet.walletType == 'custodial'
                                              ? l10n.walletTypeCustodial
                                              : l10n.walletTypeExternal,
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                                color: colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .animate()
                              .fadeIn(
                                duration: 400.ms,
                                delay: (400 + index * 80).ms,
                              )
                              .slideY(
                                begin: 0.05,
                                end: 0,
                                duration: 400.ms,
                                delay: (400 + index * 80).ms,
                              );
                        },
                      );
                    },
                    loading: () =>
                        const SliverToBoxAdapter(child: ShimmerWalletList()),
                    error: (_, __) => SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(SpacingTokens.lg),
                        child: VCard(
                          padding: const EdgeInsets.all(SpacingTokens.lg),
                          child: Text(
                            l10n.walletLoadFailed,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Tab bar for tokens/NFTs/activity
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        SpacingTokens.lg,
                        SpacingTokens.lg,
                        SpacingTokens.lg,
                        SpacingTokens.md,
                      ),
                      child: VCard(
                        padding: const EdgeInsets.all(SpacingTokens.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.walletPortfolio,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: SpacingTokens.sm),
                            SegmentedButton<int>(
                              segments: [
                                ButtonSegment(
                                  value: 0,
                                  label: Text(l10n.walletTokens),
                                ),
                                ButtonSegment(
                                  value: 1,
                                  label: Text(l10n.walletNfts),
                                ),
                                ButtonSegment(
                                  value: 2,
                                  label: Text(l10n.walletActivity),
                                ),
                              ],
                              selected: {selectedTab.value},
                              onSelectionChanged: (values) {
                                selectedTab.value = values.first;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Tab content
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: switch (selectedTab.value) {
                      0 => _buildEmptyState(
                        context,
                        icon: Icons.token_outlined,
                        title: l10n.walletNoTokensYet,
                        subtitle: l10n.walletNoTokensSubtitle,
                      ),
                      1 => _buildEmptyState(
                        context,
                        icon: Icons.collections_outlined,
                        title: l10n.walletNoNftsYet,
                        subtitle: l10n.walletNoNftsSubtitle,
                      ),
                      _ => _buildEmptyState(
                        context,
                        icon: Icons.history,
                        title: l10n.walletNoActivityYet,
                        subtitle: l10n.walletNoActivitySubtitle,
                      ),
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.lg),
        child: VCard(
          padding: const EdgeInsets.all(SpacingTokens.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: theme.colorScheme.outline),
              const SizedBox(height: SpacingTokens.md),
              Text(title, style: theme.textTheme.titleSmall),
              const SizedBox(height: SpacingTokens.xs),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddWalletDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet<void>(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(SpacingTokens.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.walletAddWallet,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: SpacingTokens.lg),
            VFilledButton(
              onPressed: () {
                Navigator.pop(context);
                ref
                    .read(walletManagerProvider.notifier)
                    .createCustodialWallet();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline),
                  const SizedBox(width: SpacingTokens.sm),
                  Text(l10n.walletCreateCustodial),
                ],
              ),
            ),
            const SizedBox(height: SpacingTokens.md),
            VOutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                _showLinkWalletDialog(context, ref);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.link),
                  const SizedBox(width: SpacingTokens.sm),
                  Text(l10n.walletLinkExternal),
                ],
              ),
            ),
            const SizedBox(height: SpacingTokens.lg),
          ],
        ),
      ),
    );
  }

  void _showLinkWalletDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    final l10n = AppLocalizations.of(context);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.walletLinkWallet),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.walletSolanaPublicKey,
            hintText: l10n.walletEnterWalletAddress,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final key = controller.text.trim();
              if (key.isNotEmpty) {
                Navigator.pop(context);
                ref
                    .read(walletManagerProvider.notifier)
                    .linkExternalWallet(publicKey: key);
              }
            },
            child: Text(l10n.walletLink),
          ),
        ],
      ),
    );
  }

  void _showReceiveDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    ref.read(userWalletsProvider).whenData((wallets) {
      final defaultWallet = wallets.where((w) => w.isDefault).firstOrNull;
      if (defaultWallet == null) return;

      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.walletReceiveSol),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.walletYourWalletAddress),
              const SizedBox(height: SpacingTokens.md),
              SelectableText(
                defaultWallet.publicKey,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: defaultWallet.publicKey));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.walletAddressCopied)),
                );
              },
              child: Text(l10n.walletCopyAddress),
            ),
          ],
        ),
      );
    });
  }
}

class _WalletPill extends HookWidget {
  const _WalletPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.sm,
        vertical: SpacingTokens.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(RadiusTokens.xl),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: SpacingTokens.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletActionButton extends HookWidget {
  const _WalletActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RadiusTokens.md),
      child: Padding(
        padding: const EdgeInsets.all(SpacingTokens.sm),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.15),
                border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: SpacingTokens.xs),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
