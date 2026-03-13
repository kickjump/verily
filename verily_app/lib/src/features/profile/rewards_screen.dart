import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/profile/providers/rewards_provider.dart';
import 'package:verily_client/verily_client.dart' as vc;
import 'package:verily_ui/verily_ui.dart';

/// Screen displaying the user's earned rewards and leaderboard link.
class RewardsScreen extends HookConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final rewardsAsync = ref.watch(userRewardsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Rewards')),
      body: rewardsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: colorScheme.error),
              const SizedBox(height: SpacingTokens.md),
              Text(
                'Failed to load rewards',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: SpacingTokens.md),
              FilledButton(
                onPressed: () => ref.invalidate(userRewardsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (rewards) => _RewardsBody(rewards: rewards),
      ),
    );
  }
}

class _RewardsBody extends HookWidget {
  const _RewardsBody({required this.rewards});

  final List<vc.UserReward> rewards;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(SpacingTokens.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Rewards count card
          VCard(
            padding: const EdgeInsets.all(SpacingTokens.lg),
            child: Column(
              children: [
                const Icon(
                  Icons.emoji_events,
                  size: 48,
                  color: ColorTokens.secondary,
                ),
                const SizedBox(height: SpacingTokens.sm),
                Text(
                  '${rewards.length}',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorTokens.secondary,
                  ),
                ),
                Text(
                  'Total Rewards',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: SpacingTokens.lg),

          // Rewards list header
          Row(
            children: [
              Icon(
                Icons.military_tech_outlined,
                size: 20,
                color: colorScheme.primary,
              ),
              const SizedBox(width: SpacingTokens.sm),
              Text(
                'Earned Rewards',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: SpacingTokens.md),

          if (rewards.isEmpty)
            VCard(
              padding: const EdgeInsets.all(SpacingTokens.lg),
              child: Column(
                children: [
                  Icon(
                    Icons.military_tech_outlined,
                    size: 48,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: SpacingTokens.sm),
                  Text(
                    'No rewards yet',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.xs),
                  Text(
                    'Complete actions to start earning rewards',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ...rewards.map((reward) => _RewardCard(reward: reward)),
        ],
      ),
    );
  }
}

class _RewardCard extends HookWidget {
  const _RewardCard({required this.reward});

  final vc.UserReward reward;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: SpacingTokens.sm),
      child: VCard(
        padding: const EdgeInsets.all(SpacingTokens.md),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorTokens.secondary.withAlpha(30),
              ),
              child: const Icon(
                Icons.emoji_events_outlined,
                color: ColorTokens.secondary,
              ),
            ),
            const SizedBox(width: SpacingTokens.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reward #${reward.rewardId}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.xs),
                  Text(
                    'Earned ${_formatDate(reward.earnedAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.check_circle,
              color: ColorTokens.success,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
