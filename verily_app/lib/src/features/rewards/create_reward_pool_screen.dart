import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/l10n/generated/app_localizations.dart';
import 'package:verily_app/src/features/rewards/providers/reward_pool_provider.dart';
import 'package:verily_app/src/routing/route_names.dart';
import 'package:verily_ui/verily_ui.dart';

/// Screen for creating a reward pool for an action.
class CreateRewardPoolScreen extends HookConsumerWidget {
  const CreateRewardPoolScreen({required this.actionId, super.key});

  final String actionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewardType = useState('sol');
    final totalAmountController = useTextEditingController();
    final perPersonController = useTextEditingController();
    final maxRecipientsController = useTextEditingController();
    final tokenMintController = useTextEditingController();
    final hasExpiry = useState(false);
    final expiryDate = useState<DateTime?>(null);
    final isSubmitting = useState(false);

    Future<void> pickExpiryDate() async {
      final picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(const Duration(days: 30)),
        firstDate: DateTime.now().add(const Duration(days: 1)),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );
      if (picked != null) {
        expiryDate.value = picked;
      }
    }

    Future<void> createPool() async {
      final totalAmount = double.tryParse(totalAmountController.text);
      final perPerson = double.tryParse(perPersonController.text);

      if (totalAmount == null || totalAmount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(
                context,
              ).rewardPoolPleaseEnterValidTotalAmount,
            ),
          ),
        );
        return;
      }

      if (rewardType.value != 'nft' && (perPerson == null || perPerson <= 0)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(
                context,
              ).rewardPoolPleaseEnterValidPerPersonAmount,
            ),
          ),
        );
        return;
      }

      if (rewardType.value == 'spl_token' && tokenMintController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(
                context,
              ).rewardPoolPleaseEnterTokenMintAddress,
            ),
          ),
        );
        return;
      }

      isSubmitting.value = true;
      final actionIdInt = int.tryParse(actionId) ?? 0;
      final maxRecipients = int.tryParse(maxRecipientsController.text);

      final pool = await ref
          .read(rewardPoolProvider.notifier)
          .create(
            actionId: actionIdInt,
            rewardType: rewardType.value,
            totalAmount: totalAmount,
            perPersonAmount: rewardType.value == 'nft' ? 1.0 : perPerson!,
            tokenMintAddress: rewardType.value == 'spl_token'
                ? tokenMintController.text
                : null,
            maxRecipients: maxRecipients,
            expiresAt: hasExpiry.value ? expiryDate.value : null,
          );

      if (pool != null && context.mounted) {
        context.go(
          RouteNames.rewardPoolDetailPath.replaceFirst(':poolId', '${pool.id}'),
        );
      } else if (context.mounted) {
        isSubmitting.value = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).rewardPoolCreateFailedTryAgain,
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).rewardPoolCreateRewardPool),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Reward type selector
            Text(
              AppLocalizations.of(context).rewardPoolRewardType,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(
                  value: 'sol',
                  label: Text(AppLocalizations.of(context).rewardPoolSol),
                  icon: const Icon(Icons.currency_exchange),
                ),
                ButtonSegment(
                  value: 'spl_token',
                  label: Text(AppLocalizations.of(context).rewardPoolToken),
                  icon: const Icon(Icons.token),
                ),
                ButtonSegment(
                  value: 'nft',
                  label: Text(AppLocalizations.of(context).rewardPoolNft),
                  icon: const Icon(Icons.collections),
                ),
              ],
              selected: {rewardType.value},
              onSelectionChanged: (values) {
                rewardType.value = values.first;
              },
            ),
            const SizedBox(height: 24),

            // Token mint address (only for SPL tokens)
            if (rewardType.value == 'spl_token') ...[
              VTextField(
                controller: tokenMintController,
                labelText: AppLocalizations.of(
                  context,
                ).rewardPoolTokenMintAddress,
                hintText: AppLocalizations.of(
                  context,
                ).rewardPoolEnterSplTokenMintAddress,
              ),
              const SizedBox(height: 16),
            ],

            // Total amount
            VTextField(
              controller: totalAmountController,
              labelText: rewardType.value == 'nft'
                  ? 'Number of NFTs'
                  : 'Total Amount',
              hintText: rewardType.value == 'nft'
                  ? 'How many NFTs to mint'
                  : 'Total pool amount',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Per person amount
            if (rewardType.value != 'nft') ...[
              VTextField(
                controller: perPersonController,
                labelText: AppLocalizations.of(
                  context,
                ).rewardPoolPerPersonAmount,
                hintText: AppLocalizations.of(
                  context,
                ).rewardPoolPerPersonAmountHint,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
            ],

            // Max recipients
            VTextField(
              controller: maxRecipientsController,
              labelText: AppLocalizations.of(
                context,
              ).rewardPoolMaxRecipientsOptional,
              hintText: AppLocalizations.of(context).actionMaxParticipantsHint,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Expiry
            SwitchListTile(
              title: Text(AppLocalizations.of(context).rewardPoolSetExpiryDate),
              subtitle: hasExpiry.value && expiryDate.value != null
                  ? Text(
                      'Expires: ${expiryDate.value!.toLocal().toString().substring(0, 16)}',
                    )
                  : Text(
                      AppLocalizations.of(
                        context,
                      ).rewardPoolWillRemainActiveUntilDepleted,
                    ),
              value: hasExpiry.value,
              onChanged: (value) {
                hasExpiry.value = value;
                if (value) {
                  pickExpiryDate();
                } else {
                  expiryDate.value = null;
                }
              },
            ),
            const SizedBox(height: 16),

            // Platform fee info
            VCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'A 5% platform fee is deducted from each distribution '
                        'to support Verily operations.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Create button
            VFilledButton(
              isLoading: isSubmitting.value,
              onPressed: isSubmitting.value ? null : createPool,
              child: Text(
                AppLocalizations.of(context).rewardPoolFundAndCreatePool,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
