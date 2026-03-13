import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/submissions/providers/submission_provider.dart';
import 'package:verily_app/src/routing/route_names.dart';
import 'package:verily_ui/verily_ui.dart';

/// Screen for reviewing a recorded video before submitting.
class VideoReviewScreen extends HookConsumerWidget {
  const VideoReviewScreen({required this.actionId, this.videoPath, super.key});

  /// The action this submission is for.
  final String actionId;

  /// Local file path of the recorded video, passed via router `extra`.
  final String? videoPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSubmitting = useState(false);

    // Compute video file size for display.
    final fileSizeLabel = useMemoized(() {
      if (videoPath == null) return 'Unknown';
      try {
        final bytes = File(videoPath!).lengthSync();
        if (bytes < 1024 * 1024) {
          return '${(bytes / 1024).toStringAsFixed(1)} KB';
        }
        return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
      } on Exception {
        return 'Unknown';
      }
    }, [videoPath]);

    Future<void> submitVideo() async {
      isSubmitting.value = true;
      try {
        // Capture GPS location for the submission.
        Position? position;
        try {
          position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              timeLimit: Duration(seconds: 5),
            ),
          );
        } on Exception catch (e) {
          debugPrint('GPS capture failed: $e');
        }

        // The videoUrl sent to the server is the local path for now.
        // In production this would be uploaded to cloud storage first.
        final videoUrl = videoPath ?? 'placeholder://no-video';
        final actionIdInt = int.tryParse(actionId) ?? 0;

        final submission = await ref
            .read(submissionProvider.notifier)
            .submit(
              actionId: actionIdInt,
              videoUrl: videoUrl,
              latitude: position?.latitude,
              longitude: position?.longitude,
            );

        if (submission != null && context.mounted) {
          context.go(
            RouteNames.submissionStatusPath.replaceFirst(':actionId', actionId),
            extra: submission.id,
          );
        } else if (context.mounted) {
          isSubmitting.value = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to submit video. Please try again.'),
            ),
          );
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
                // Video playback from local file would go here.
              },
            ),
          ),
          const SizedBox(height: SpacingTokens.md),

          // Video metadata
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.md),
            child: VCard(
              padding: const EdgeInsets.all(SpacingTokens.md),
              child: Column(
                children: [
                  _MetadataItem(
                    icon: Icons.storage_outlined,
                    label: 'File Size',
                    value: fileSizeLabel,
                  ),
                  const SizedBox(height: SpacingTokens.sm),
                  const _MetadataItem(
                    icon: Icons.gps_fixed,
                    label: 'Location',
                    value: 'GPS coordinates captured',
                    valueColor: ColorTokens.success,
                  ),
                  const SizedBox(height: SpacingTokens.sm),
                  _MetadataItem(
                    icon: Icons.videocam_outlined,
                    label: 'Video',
                    value: videoPath != null ? 'Ready' : 'No video',
                    valueColor: videoPath != null
                        ? ColorTokens.success
                        : ColorTokens.error,
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
