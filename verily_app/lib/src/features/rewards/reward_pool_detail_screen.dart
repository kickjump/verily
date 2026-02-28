import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/rewards/providers/reward_pool_provider.dart';
import 'package:verily_ui/verily_ui.dart';

/// Screen showing details of a reward pool and its distributions.
class RewardPoolDetailScreen extends HookConsumerWidget {
  const RewardPoolDetailScreen({required this.poolId, super.key});

  final String poolId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poolIdInt = int.tryParse(poolId) ?? 0;
    final poolAsync = ref.watch(fetchRewardPoolProvider(poolIdInt));
    final distributionsAsync = ref.watch(
      rewardDistributionsProvider(poolIdInt),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reward Pool'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'cancel') {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Cancel Pool?'),
                    content: const Text(
                      'Remaining funds will be returned to your wallet.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Keep'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Cancel Pool'),
                      ),
                    ],
                  ),
                );
                if ((confirmed ?? false) && context.mounted) {
                  await ref.read(rewardPoolProvider.notifier).cancel(poolIdInt);
                  if (context.mounted) {
                    ref.invalidate(fetchRewardPoolProvider(poolIdInt));
                  }
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'cancel', child: Text('Cancel Pool')),
            ],
          ),
        ],
      ),
      body: poolAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 16),
              Text('Failed to load pool: $error'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () =>
                    ref.invalidate(fetchRewardPoolProvider(poolIdInt)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (pool) {
          final distributed = pool.totalAmount - pool.remainingAmount;
          final progress = pool.totalAmount > 0
              ? distributed / pool.totalAmount
              : 0.0;

          final statusColor = switch (pool.status) {
            'active' => Colors.green,
            'depleted' => Colors.orange,
            'cancelled' => Colors.red,
            'expired' => Colors.grey,
            _ => Colors.grey,
          };

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Pool status card
                VCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Status',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            VBadgeChip(
                              label: pool.status.toUpperCase(),
                              backgroundColor: statusColor,
                              foregroundColor: Colors.white,
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(context, 'Type', pool.rewardType),
                        _buildInfoRow(
                          context,
                          'Total Amount',
                          '${pool.totalAmount} ${pool.rewardType.toUpperCase()}',
                        ),
                        _buildInfoRow(
                          context,
                          'Remaining',
                          '${pool.remainingAmount} ${pool.rewardType.toUpperCase()}',
                        ),
                        _buildInfoRow(
                          context,
                          'Per Person',
                          '${pool.perPersonAmount} ${pool.rewardType.toUpperCase()}',
                        ),
                        _buildInfoRow(
                          context,
                          'Platform Fee',
                          '${pool.platformFeePercent.toStringAsFixed(0)}%',
                        ),
                        if (pool.maxRecipients != null)
                          _buildInfoRow(
                            context,
                            'Max Recipients',
                            '${pool.maxRecipients}',
                          ),
                        if (pool.expiresAt != null)
                          _buildInfoRow(
                            context,
                            'Expires',
                            pool.expiresAt!.toLocal().toString().substring(
                              0,
                              16,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Progress indicator
                VCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Distribution Progress',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${(progress * 100).toStringAsFixed(0)}% distributed',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Recent distributions
                Text(
                  'Recent Distributions',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                distributionsAsync.when(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (_, __) => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('Failed to load distributions'),
                    ),
                  ),
                  data: (distributions) {
                    if (distributions.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            'No distributions yet',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: [
                        for (final dist in distributions)
                          ListTile(
                            leading: const Icon(Icons.send),
                            title: Text(
                              '${dist.amount} ${pool.rewardType.toUpperCase()}',
                            ),
                            subtitle: Text(dist.status),
                            trailing: Text(
                              dist.createdAt.toLocal().toString().substring(
                                0,
                                10,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
