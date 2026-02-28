import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/actions/providers/ai_action_provider.dart';
import 'package:verily_app/src/routing/route_names.dart';
import 'package:verily_core/verily_core.dart';
import 'package:verily_ui/verily_ui.dart';

/// Screen that lets creators describe an action via voice or text,
/// then uses AI to generate a structured action for review.
class AiCreateActionScreen extends HookConsumerWidget {
  const AiCreateActionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final textController = useTextEditingController();
    final isListening = useState(false);
    final aiState = ref.watch(aiActionGeneratorProvider);
    final aiNotifier = ref.read(aiActionGeneratorProvider.notifier);

    // When AI generates an action, show the review screen
    final generatedAction = aiState.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create with AI'),
        actions: [
          TextButton(
            onPressed: () => context.push(RouteNames.createActionPath),
            child: const Text('Manual'),
          ),
        ],
      ),
      body: generatedAction != null
          ? _AiReviewView(
              action: generatedAction,
              onEdit: () => aiNotifier.reset(),
              onConfirm: () {
                // Navigate to the manual create screen with pre-filled data
                // For now, we show success and go back
                context.push(RouteNames.createActionPath);
              },
            )
          : Padding(
              padding: const EdgeInsets.all(SpacingTokens.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(SpacingTokens.lg),
                    decoration: BoxDecoration(
                      gradient: isDark
                          ? GradientTokens.heroCard
                          : GradientTokens.heroCardLight,
                      borderRadius: BorderRadius.circular(RadiusTokens.lg),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 48,
                          color: isDark ? Colors.white : ColorTokens.primary,
                        ),
                        const SizedBox(height: SpacingTokens.md),
                        Text(
                          'Describe your action',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: SpacingTokens.sm),
                        Text(
                          'Tell us what you want people to do. Our AI will structure it into a verifiable action with criteria.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.8)
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: SpacingTokens.lg),

                  // Text input area
                  Expanded(
                    child: VTextField(
                      controller: textController,
                      labelText: 'Describe the action',
                      hintText:
                          'e.g., "I want people to plant a tree in their neighborhood '
                          'and take a video showing them digging the hole, '
                          'planting the sapling, and watering it"',
                      maxLines: 8,
                    ),
                  ),

                  const SizedBox(height: SpacingTokens.md),

                  // Example prompts
                  Text(
                    'Try saying:',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.sm),
                  Wrap(
                    spacing: SpacingTokens.sm,
                    runSpacing: SpacingTokens.sm,
                    children: [
                      _ExampleChip(
                        label: 'Do 50 push-ups at a park',
                        onTap: () => textController.text =
                            'Do 50 push-ups at a park. '
                            'The video should clearly show full body reps.',
                      ),
                      _ExampleChip(
                        label: 'Clean up a beach for 10 min',
                        onTap: () => textController.text =
                            'Pick up litter at a beach for at least 10 minutes. '
                            'Show the before and after in the video.',
                      ),
                      _ExampleChip(
                        label: 'Meditate daily for a week',
                        onTap: () => textController.text =
                            'Meditate for at least 5 minutes every day for 7 days. '
                            'Record a short clip each day showing you in a quiet '
                            'seated position.',
                      ),
                    ],
                  ),

                  const SizedBox(height: SpacingTokens.lg),

                  // Action buttons
                  Row(
                    children: [
                      // Voice button
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isListening.value
                              ? colorScheme.error
                              : colorScheme.primaryContainer,
                        ),
                        child: IconButton(
                          icon: Icon(
                            isListening.value ? Icons.stop : Icons.mic,
                            color: isListening.value
                                ? colorScheme.onError
                                : colorScheme.primary,
                          ),
                          iconSize: 28,
                          onPressed: () {
                            // Toggle speech-to-text
                            isListening.value = !isListening.value;
                            // TODO: Wire to speech_to_text plugin
                          },
                        ),
                      ),
                      const SizedBox(width: SpacingTokens.md),

                      // Generate button
                      Expanded(
                        child: VFilledButton(
                          isLoading: aiState.isLoading,
                          onPressed:
                              aiState.isLoading ||
                                  textController.text.trim().length < 10
                              ? null
                              : () => aiNotifier.generate(
                                  textController.text.trim(),
                                ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.auto_awesome, size: 18),
                              SizedBox(width: SpacingTokens.sm),
                              Text('Generate Action'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Error display
                  if (aiState.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: SpacingTokens.sm),
                      child: Text(
                        'AI generation failed. Check your connection and try again.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                    ),

                  const SizedBox(height: SpacingTokens.md),
                ],
              ),
            ),
    );
  }
}

/// Shows the AI-generated action for review before creating.
class _AiReviewView extends HookWidget {
  const _AiReviewView({
    required this.action,
    required this.onEdit,
    required this.onConfirm,
  });

  final AiGeneratedAction action;
  final VoidCallback onEdit;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(SpacingTokens.md),
            children: [
              // Success banner
              Container(
                padding: const EdgeInsets.all(SpacingTokens.md),
                decoration: BoxDecoration(
                  color: ColorTokens.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(RadiusTokens.md),
                  border: Border.all(
                    color: ColorTokens.success.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: ColorTokens.success),
                    const SizedBox(width: SpacingTokens.sm),
                    Expanded(
                      child: Text(
                        'AI generated your action! Review and edit below.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: ColorTokens.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: SpacingTokens.lg),

              // Title
              _ReviewCard(label: 'Title', value: action.title),
              const SizedBox(height: SpacingTokens.md),

              // Description
              _ReviewCard(label: 'Description', value: action.description),
              const SizedBox(height: SpacingTokens.md),

              // Type
              _ReviewCard(label: 'Type', value: action.actionType),
              const SizedBox(height: SpacingTokens.md),

              // Category
              _ReviewCard(label: 'Category', value: action.suggestedCategory),
              const SizedBox(height: SpacingTokens.md),

              // Verification criteria
              VCard(
                padding: const EdgeInsets.all(SpacingTokens.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verification Criteria',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: SpacingTokens.sm),
                    for (final criterion
                        in action.verificationCriteria
                            .split('\n')
                            .where((line) => line.trim().isNotEmpty))
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: SpacingTokens.xs,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              size: 18,
                              color: ColorTokens.success,
                            ),
                            const SizedBox(width: SpacingTokens.sm),
                            Expanded(
                              child: Text(
                                criterion.replaceFirst(RegExp(r'^[-•]\s*'), ''),
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: SpacingTokens.md),

              // Steps (if sequential)
              if (action.steps.isNotEmpty) ...[
                VCard(
                  padding: const EdgeInsets.all(SpacingTokens.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Steps',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.sm),
                      for (final step in action.steps)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: SpacingTokens.sm,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: colorScheme.primaryContainer,
                                child: Text(
                                  '${step.stepNumber}',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: SpacingTokens.sm),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      step.title,
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Text(
                                      step.description,
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: SpacingTokens.md),
              ],

              // Habit info
              if (action.habitDurationDays != null) ...[
                _ReviewCard(
                  label: 'Duration',
                  value: '${action.habitDurationDays} days',
                ),
                const SizedBox(height: SpacingTokens.md),
                _ReviewCard(
                  label: 'Frequency',
                  value: '${action.habitFrequencyPerWeek ?? 7} times per week',
                ),
                const SizedBox(height: SpacingTokens.md),
              ],

              // Location
              if (action.suggestedLocation != null) ...[
                _ReviewCard(
                  label: 'Location',
                  value:
                      '${action.suggestedLocation!.name} — ${action.suggestedLocation!.address}',
                ),
                const SizedBox(height: SpacingTokens.md),
              ],

              // Tags
              if (action.suggestedTags.isNotEmpty) ...[
                VCard(
                  padding: const EdgeInsets.all(SpacingTokens.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tags',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.sm),
                      Wrap(
                        spacing: SpacingTokens.sm,
                        runSpacing: SpacingTokens.sm,
                        children: action.suggestedTags
                            .map(
                              (tag) => Chip(
                                label: Text(tag),
                                visualDensity: VisualDensity.compact,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: SpacingTokens.lg),
              ],
            ],
          ),
        ),

        // Bottom action buttons
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(SpacingTokens.md),
            child: Row(
              children: [
                Expanded(
                  child: VOutlinedButton(
                    onPressed: onEdit,
                    child: const Text('Edit Prompt'),
                  ),
                ),
                const SizedBox(width: SpacingTokens.md),
                Expanded(
                  flex: 2,
                  child: VFilledButton(
                    onPressed: onConfirm,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check, size: 18),
                        SizedBox(width: SpacingTokens.sm),
                        Text('Create Action'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ReviewCard extends HookWidget {
  const _ReviewCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return VCard(
      padding: const EdgeInsets.all(SpacingTokens.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SpacingTokens.xs),
          Text(value, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _ExampleChip extends HookWidget {
  const _ExampleChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ActionChip(
      label: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.primary),
      ),
      onPressed: onTap,
      backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.3),
      side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.2)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.md),
      ),
    );
  }
}
