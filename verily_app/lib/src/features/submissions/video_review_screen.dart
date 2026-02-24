import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_ui/verily_ui.dart';

/// Screen for reviewing a recorded video before submitting.
class VideoReviewScreen extends HookConsumerWidget {
  const VideoReviewScreen({required this.actionId, super.key});

  /// The action this submission is for.
  final String actionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSubmitting = useState(false);

    Future<void> submitVideo() async {
      isSubmitting.value = true;
      try {
        // TODO: Upload video to Serverpod and create submission.
        await Future<void>.delayed(const Duration(seconds: 2));
        if (context.mounted) {
          context.go('/submissions/status/$actionId');
        }
      } on Exception {
        isSubmitting.value = false;
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to submit video. Please try again.'),
            ),
          );
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Review Video'),
      ),
      body: Column(
        children: [
          // Video preview
          Expanded(
            child: VVideoPlayer(
              aspectRatio: 9 / 16,
              onPlay: () {
                // TODO: Play the recorded video.
              },
            ),
          ),
          const SizedBox(height: SpacingTokens.md),

          // Video metadata
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: SpacingTokens.md),
            child: VCard(
              padding: EdgeInsets.all(SpacingTokens.md),
              child: Column(
                children: [
                  _MetadataItem(
                    icon: Icons.timer_outlined,
                    label: 'Duration',
                    value: '0:32',
                  ),
                  SizedBox(height: SpacingTokens.sm),
                  _MetadataItem(
                    icon: Icons.gps_fixed,
                    label: 'Location',
                    value: 'GPS coordinates captured',
                    valueColor: ColorTokens.success,
                  ),
                  SizedBox(height: SpacingTokens.sm),
                  _MetadataItem(
                    icon: Icons.high_quality_outlined,
                    label: 'Quality',
                    value: '1080p',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: SpacingTokens.md),

          // Action buttons
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(SpacingTokens.md),
              child: Row(
                children: [
                  // Retake button
                  Expanded(
                    child: VOutlinedButton(
                      onPressed: isSubmitting.value
                          ? null
                          : () => context.pop(),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.replay),
                          SizedBox(width: SpacingTokens.sm),
                          Text('Retake'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: SpacingTokens.md),

                  // Submit button
                  Expanded(
                    flex: 2,
                    child: VFilledButton(
                      isLoading: isSubmitting.value,
                      onPressed: isSubmitting.value ? null : submitVideo,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send),
                          SizedBox(width: SpacingTokens.sm),
                          Text('Submit'),
                        ],
                      ),
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

/// Displays a single metadata row with icon, label, and value.
class _MetadataItem extends HookWidget {
  const _MetadataItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: SpacingTokens.sm),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
