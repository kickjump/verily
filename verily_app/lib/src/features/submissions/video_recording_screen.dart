import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:verily_app/src/routing/route_names.dart';
import 'package:verily_ui/verily_ui.dart';

/// Screen for recording video proof of an action.
class VideoRecordingScreen extends HookConsumerWidget {
  const VideoRecordingScreen({required this.actionId, super.key});

  /// The action this video submission is for.
  final String actionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isRecording = useState(false);
    final elapsedSeconds = useState(0);
    final isFrontCamera = useState(false);
    final hasGpsSignal = useState(true);
    final isLaunching = useState(false);

    // Recording timer
    useEffect(() {
      if (!isRecording.value) return null;

      final stopwatch = Stopwatch()..start();
      Future<void> tick() async {
        while (isRecording.value) {
          await Future<void>.delayed(const Duration(seconds: 1));
          if (isRecording.value) {
            elapsedSeconds.value = stopwatch.elapsed.inSeconds;
          }
        }
      }

      tick();
      return stopwatch.stop;
    }, [isRecording.value]);

    String formatTime(int seconds) {
      final mins = (seconds ~/ 60).toString().padLeft(2, '0');
      final secs = (seconds % 60).toString().padLeft(2, '0');
      return '$mins:$secs';
    }

    Future<void> launchCamera() async {
      isLaunching.value = true;
      try {
        final picker = ImagePicker();
        final video = await picker.pickVideo(
          source: ImageSource.camera,
          preferredCameraDevice: isFrontCamera.value
              ? CameraDevice.front
              : CameraDevice.rear,
          maxDuration: const Duration(minutes: 5),
        );

        if (video != null && context.mounted) {
          unawaited(
            context.push(
              RouteNames.videoReviewPath.replaceFirst(':actionId', actionId),
              extra: video.path,
            ),
          );
        }
      } on Exception catch (e) {
        debugPrint('Camera error: $e');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to open camera. Please try again.'),
            ),
          );
        }
      } finally {
        isLaunching.value = false;
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera preview placeholder
          ColoredBox(
            color: Colors.black87,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isFrontCamera.value
                        ? Icons.camera_front
                        : Icons.camera_rear,
                    size: 80,
                    color: Colors.white30,
                  ),
                  const SizedBox(height: SpacingTokens.md),
                  Text(
                    'Camera Preview',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white30,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.xs),
                  Text(
                    'Tap record to open camera',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white24,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Top bar overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(SpacingTokens.md),
                child: Row(
                  children: [
                    // Close button
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: isRecording.value ? null : () => context.pop(),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black45,
                      ),
                    ),
                    const Spacer(),

                    // GPS status indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SpacingTokens.sm,
                        vertical: SpacingTokens.xs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(RadiusTokens.xl),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            hasGpsSignal.value
                                ? Icons.gps_fixed
                                : Icons.gps_off,
                            size: 16,
                            color: hasGpsSignal.value
                                ? ColorTokens.success
                                : ColorTokens.error,
                          ),
                          const SizedBox(width: SpacingTokens.xs),
                          Text(
                            hasGpsSignal.value ? 'GPS Ready' : 'No GPS',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),

                    // Switch camera button
                    IconButton(
                      icon: const Icon(
                        Icons.flip_camera_ios_outlined,
                        color: Colors.white,
                      ),
                      onPressed: isRecording.value
                          ? null
                          : () {
                              isFrontCamera.value = !isFrontCamera.value;
                            },
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Recording timer
          if (isRecording.value)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 70),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SpacingTokens.md,
                        vertical: SpacingTokens.xs,
                      ),
                      decoration: BoxDecoration(
                        color: ColorTokens.error.withAlpha(200),
                        borderRadius: BorderRadius.circular(RadiusTokens.xl),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: SpacingTokens.sm),
                          Text(
                            formatTime(elapsedSeconds.value),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(SpacingTokens.xl),
                child: Column(
                  children: [
                    // Action info
                    if (!isRecording.value)
                      Container(
                        margin: const EdgeInsets.only(bottom: SpacingTokens.lg),
                        padding: const EdgeInsets.all(SpacingTokens.md),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(RadiusTokens.md),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Colors.white70,
                              size: 20,
                            ),
                            const SizedBox(width: SpacingTokens.sm),
                            Expanded(
                              child: Text(
                                'Record a clear video showing you '
                                'completing the action. GPS location '
                                'will be captured automatically.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Record button
                    GestureDetector(
                      onTap: isLaunching.value ? null : launchCamera,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: Center(
                          child: isLaunching.value
                              ? const SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: isRecording.value ? 32 : 64,
                                  height: isRecording.value ? 32 : 64,
                                  decoration: BoxDecoration(
                                    color: ColorTokens.error,
                                    borderRadius: BorderRadius.circular(
                                      isRecording.value ? 6 : 32,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
