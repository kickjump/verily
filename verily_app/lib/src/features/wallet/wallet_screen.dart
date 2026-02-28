import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(gradient: GradientTokens.shellBackground),
            child: SizedBox.expand(),
          ),
          SafeArea(
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
                            'Wallet',
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

                // Balance card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SpacingTokens.lg,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: GradientTokens.heroCard,
                        borderRadius: BorderRadius.circular(RadiusTokens.xl),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(SpacingTokens.xl),
                        child: Column(
                          children: [
                            Text(
                              'Total Balance',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(height: SpacingTokens.sm),
                            balanceAsync.when(
                              data: (balance) => Text(
                                '${balance.toStringAsFixed(4)} SOL',
                                style: theme.textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              loading: () => const SizedBox(
                                height: 36,
                                width: 36,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                              error: (_, __) => Text(
                                '-- SOL',
                                style: theme.textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: SpacingTokens.lg),
                            // Action buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _WalletActionButton(
                                  icon: Icons.arrow_downward,
                                  label: 'Receive',
                                  onTap: () => _showReceiveDialog(context, ref),
                                ),
                                _WalletActionButton(
                                  icon: Icons.arrow_upward,
                                  label: 'Send',
                                  onTap: () {},
                                ),
                                _WalletActionButton(
                                  icon: Icons.refresh,
                                  label: 'Refresh',
                                  onTap: () {
                                    ref
                                      ..invalidate(walletBalanceProvider)
                                      ..invalidate(userWalletsProvider);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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
                    child: Text(
                      'Your Wallets',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
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
                                  'No wallets yet',
                                  style: theme.textTheme.titleSmall,
                                ),
                                const SizedBox(height: SpacingTokens.sm),
                                Text(
                                  'Create or connect a wallet to get started',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: SpacingTokens.lg),
                                VFilledButton(
                                  onPressed: () =>
                                      _showAddWalletDialog(context, ref),
                                  child: const Text('Add Wallet'),
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
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(
                            SpacingTokens.lg,
                            0,
                            SpacingTokens.lg,
                            SpacingTokens.sm,
                          ),
                          child: VCard(
                            padding: const EdgeInsets.all(SpacingTokens.md),
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(text: wallet.publicKey),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Address copied')),
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
                                        : colorScheme.surfaceContainerHighest,
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
                                            wallet.label ?? 'Wallet',
                                            style: theme.textTheme.titleSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                          if (wallet.isDefault) ...[
                                            const SizedBox(
                                              width: SpacingTokens.xs,
                                            ),
                                            const VBadgeChip(label: 'Default'),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        shortKey,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                              fontFamily: 'monospace',
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  wallet.walletType == 'custodial'
                                      ? 'Custodial'
                                      : 'External',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(SpacingTokens.xl),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  error: (_, __) => SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(SpacingTokens.lg),
                      child: VCard(
                        padding: const EdgeInsets.all(SpacingTokens.lg),
                        child: Text(
                          'Failed to load wallets. Pull to refresh.',
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
                    child: SegmentedButton<int>(
                      segments: const [
                        ButtonSegment(value: 0, label: Text('Tokens')),
                        ButtonSegment(value: 1, label: Text('NFTs')),
                        ButtonSegment(value: 2, label: Text('Activity')),
                      ],
                      selected: {selectedTab.value},
                      onSelectionChanged: (values) {
                        selectedTab.value = values.first;
                      },
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
                      title: 'No tokens yet',
                      subtitle: 'Complete actions to earn token rewards',
                    ),
                    1 => _buildEmptyState(
                      context,
                      icon: Icons.collections_outlined,
                      title: 'No NFTs yet',
                      subtitle: 'Earn NFT badges by completing actions',
                    ),
                    _ => _buildEmptyState(
                      context,
                      icon: Icons.history,
                      title: 'No activity yet',
                      subtitle: 'Your transaction history will appear here',
                    ),
                  },
                ),
              ],
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          ),
        ],
      ),
    );
  }

  void _showAddWalletDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(SpacingTokens.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add Wallet',
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline),
                  SizedBox(width: SpacingTokens.sm),
                  Text('Create Custodial Wallet'),
                ],
              ),
            ),
            const SizedBox(height: SpacingTokens.md),
            VOutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                _showLinkWalletDialog(context, ref);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.link),
                  SizedBox(width: SpacingTokens.sm),
                  Text('Link External Wallet'),
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
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Link Wallet'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Solana Public Key',
            hintText: 'Enter your wallet address',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
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
            child: const Text('Link'),
          ),
        ],
      ),
    );
  }

  void _showReceiveDialog(BuildContext context, WidgetRef ref) {
    ref.read(userWalletsProvider).whenData((wallets) {
      final defaultWallet = wallets.where((w) => w.isDefault).firstOrNull;
      if (defaultWallet == null) return;

      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Receive SOL'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Your wallet address:'),
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
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Address copied')));
              },
              child: const Text('Copy Address'),
            ),
          ],
        ),
      );
    });
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
