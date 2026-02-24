import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_ui/verily_ui.dart';

/// Screen showing details of a reward pool and its distributions.
class RewardPoolDetailScreen extends HookConsumerWidget {
  const RewardPoolDetailScreen({required this.poolId, super.key});

  final String poolId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reward Pool'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'cancel') {
                // TODO: Show confirmation and call RewardPoolEndpoint.cancel()
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'cancel', child: Text('Cancel Pool')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                        const VBadgeChip(
                          label: 'Active',
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(context, 'Type', 'SOL'),
                    _buildInfoRow(context, 'Total Amount', '10.0 SOL'),
                    _buildInfoRow(context, 'Remaining', '8.5 SOL'),
                    _buildInfoRow(context, 'Per Person', '0.5 SOL'),
                    _buildInfoRow(context, 'Platform Fee', '5%'),
                    _buildInfoRow(context, 'Recipients', '3 / unlimited'),
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
                      value: 0.15,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '15% distributed',
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
            // TODO: Replace with real distribution data
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'No distributions yet',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          ],
        ),
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
