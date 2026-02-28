import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/actions/providers/active_action_provider.dart';
import 'package:verily_app/src/features/submissions/verification_capture_utils.dart';
import 'package:verily_app/src/routing/route_names.dart';
import 'package:verily_ui/verily_ui.dart';

/// Fast verification capture flow launched from the center tab button.
class VerificationCaptureScreen extends HookConsumerWidget {
  const VerificationCaptureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRecording = useState(false);
    final captureAudio = useState(true);
    final elapsedSeconds = useState(0);
    final locationLog = useState<String?>(null);
    final activeAction = ref.watch(activeActionControllerProvider);
    final checklistItems =
        activeAction?.verificationChecklist ??
        const [
          'Keep your face and action in frame.',
          'Record ambient audio while performing.',
          'Log on-site location before submitting.',
        ];
    final checklistCompletion = useState<List<bool>>(
      List<bool>.filled(checklistItems.length, false),
    );

    useEffect(() {
      checklistCompletion.value = List<bool>.filled(
        checklistItems.length,
        false,
      );
      return null;
    }, [activeAction?.actionId, checklistItems.length]);

    final completedChecklistCount = checklistCompletion.value
        .where((isComplete) => isComplete)
        .length;
    final allChecklistDone =
        checklistItems.isNotEmpty &&
        completedChecklistCount == checklistItems.length;
    final readinessProgress = calculateReadinessProgress(
      completedChecklistCount: completedChecklistCount,
      checklistLength: checklistItems.length,
      hasLocationLog: locationLog.value != null,
      captureAudioEnabled: captureAudio.value,
    );

    useEffect(() {
      if (!isRecording.value) return null;

      final timer = Timer.periodic(const Duration(seconds: 1), (_) {
        elapsedSeconds.value += 1;
      });
      return timer.cancel;
    }, [isRecording.value]);

    void toggleRecording() {
      if (isRecording.value) {
        isRecording.value = false;
      } else {
        elapsedSeconds.value = 0;
        isRecording.value = true;
      }
    }

    void logLocation() {
      final now = DateTime.now().toIso8601String();
      locationLog.value = 'Logged at $now';
    }

    void toggleChecklistItem(int index, {required bool? checked}) {
      final nextState = [...checklistCompletion.value];
      nextState[index] = checked ?? false;
      checklistCompletion.value = nextState;
    }

    void submitVerification() {
      final messenger = ScaffoldMessenger.of(context);
      if (isRecording.value) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Stop recording before submitting for review.'),
          ),
        );
        return;
      }
      if (locationLog.value == null || !allChecklistDone) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              'Complete checklist items and location logging before submitting.',
            ),
          ),
        );
        return;
      }

      final actionId = activeAction?.actionId ?? 'draft';
      context.push(
        RouteNames.submissionStatusPath.replaceFirst(':actionId', actionId),
      );
    }

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Verification Capture'),
        actions: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
      body: Stack(
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(gradient: GradientTokens.shellBackground),
            child: SizedBox.expand(),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(SpacingTokens.lg),
              children: [
                Text(
                  activeAction == null
                      ? 'Record proof and submit for AI review'
                      : 'Capture proof for your active action',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: SpacingTokens.sm),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(RadiusTokens.xl),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF0E2246),
                        Color(0xFF174D8E),
                        Color(0xFF145FA7),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x55223E6C),
                        blurRadius: 28,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: SpacingTokens.md,
                        bottom: SpacingTokens.md,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: SpacingTokens.sm,
                            vertical: SpacingTokens.xs,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.34),
                            borderRadius: BorderRadius.circular(
                              RadiusTokens.xl,
                            ),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.18),
                            ),
                          ),
                          child: const Text(
                            'CHALLENGE ID 31A7',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: SpacingTokens.md,
                        top: SpacingTokens.md,
                        child: _SignalBadge(
                          icon: Icons.mic_none,
                          label: captureAudio.value
                              ? 'Audio on'
                              : 'Audio muted',
                        ),
                      ),
                      Positioned(
                        right: SpacingTokens.md,
                        top: SpacingTokens.md,
                        child: _SignalBadge(
                          icon: Icons.location_on_outlined,
                          label: locationLog.value == null
                              ? 'Location idle'
                              : 'Location logged',
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 78,
                              height: 78,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  RadiusTokens.md,
                                ),
                                color: Colors.white.withValues(alpha: 0.12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.26),
                                ),
                              ),
                              child: const Icon(
                                Icons.videocam_outlined,
                                color: Colors.white,
                                size: 46,
                              ),
                            ),
                            const SizedBox(height: SpacingTokens.md),
                            const Text(
                              'Camera Preview',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(height: SpacingTokens.sm),
                            Text(
                              isRecording.value
                                  ? 'Recording ${formatCaptureDuration(elapsedSeconds.value)}'
                                  : 'Ready to record proof',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      if (isRecording.value)
                        Positioned(
                          right: SpacingTokens.md,
                          bottom: SpacingTokens.md,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFF5F7A),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: SpacingTokens.xs),
                              const Text(
                                'LIVE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: SpacingTokens.lg),
                Row(
                  children: [
                    Expanded(
                      child: _CapabilityCard(
                        icon: Icons.mic,
                        label: 'Audio',
                        status: captureAudio.value ? 'Enabled' : 'Muted',
                      ),
                    ),
                    const SizedBox(width: SpacingTokens.sm),
                    Expanded(
                      child: _CapabilityCard(
                        icon: Icons.location_on_outlined,
                        label: 'Location',
                        status: locationLog.value == null
                            ? 'Not logged'
                            : 'Logged',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SpacingTokens.md),
                VCard(
                  padding: const EdgeInsets.all(SpacingTokens.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Capture readiness',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.xs),
                      Text(
                        '$completedChecklistCount/${checklistItems.length} checklist items complete',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: SpacingTokens.sm),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(RadiusTokens.sm),
                        child: LinearProgressIndicator(
                          minHeight: 8,
                          value: readinessProgress.clamp(0.0, 1.0),
                          color: theme.colorScheme.primary,
                          backgroundColor: const Color(0xFFDCE7FF),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: SpacingTokens.md),
                if (activeAction != null)
                  VCard(
                    padding: const EdgeInsets.all(SpacingTokens.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Active action',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: SpacingTokens.xs),
                        Text(
                          activeAction.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: SpacingTokens.xs),
                        Text(
                          '${activeAction.distanceFromNextLocation} to ${activeAction.nextLocationLabel}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                if (activeAction != null)
                  const SizedBox(height: SpacingTokens.md),
                VCard(
                  padding: const EdgeInsets.all(SpacingTokens.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activeAction != null
                            ? 'Evidence checklist for active action'
                            : 'Evidence checklist',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.sm),
                      for (
                        var index = 0;
                        index < checklistItems.length;
                        index++
                      )
                        CheckboxListTile(
                          key: Key('verification_checklistItem_$index'),
                          contentPadding: EdgeInsets.zero,
                          value: checklistCompletion.value[index],
                          checkColor: theme.colorScheme.onSecondary,
                          activeColor: theme.colorScheme.secondary,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (checked) =>
                              toggleChecklistItem(index, checked: checked),
                          title: Text(
                            '${index + 1}. ${checklistItems[index]}',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: SpacingTokens.md),
                if (locationLog.value != null)
                  Container(
                    key: const Key('verification_locationLogText'),
                    padding: const EdgeInsets.symmetric(
                      horizontal: SpacingTokens.md,
                      vertical: SpacingTokens.sm,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(RadiusTokens.md),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          color: ColorTokens.success,
                          size: 18,
                        ),
                        const SizedBox(width: SpacingTokens.xs),
                        Expanded(
                          child: Text(
                            locationLog.value!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: SpacingTokens.md),
                VCard(
                  padding: const EdgeInsets.all(SpacingTokens.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Control deck',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.sm),
                      Row(
                        children: [
                          Expanded(
                            child: VOutlinedButton(
                              key: const Key('verification_toggleAudioButton'),
                              onPressed: () =>
                                  captureAudio.value = !captureAudio.value,
                              child: Text(
                                captureAudio.value
                                    ? 'Mute Audio'
                                    : 'Enable Audio',
                              ),
                            ),
                          ),
                          const SizedBox(width: SpacingTokens.md),
                          Expanded(
                            child: VOutlinedButton(
                              key: const Key('verification_logLocationButton'),
                              onPressed: logLocation,
                              child: const Text('Log Location'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: SpacingTokens.md),
                      VFilledButton(
                        key: const Key('verification_startStopRecordingButton'),
                        onPressed: toggleRecording,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isRecording.value
                                  ? Icons.stop
                                  : Icons.fiber_manual_record,
                            ),
                            const SizedBox(width: SpacingTokens.xs),
                            Text(
                              isRecording.value
                                  ? 'Stop Recording'
                                  : 'Start Recording',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.sm),
                      VFilledButton(
                        key: const Key('verification_submitButton'),
                        onPressed: submitVerification,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload_outlined),
                            SizedBox(width: SpacingTokens.xs),
                            Text('Submit for AI Review'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: SpacingTokens.xxl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SignalBadge extends HookWidget {
  const _SignalBadge({required this.icon, required this.label});

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
        color: Colors.black.withValues(alpha: 0.26),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(RadiusTokens.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: SpacingTokens.xs),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CapabilityCard extends HookWidget {
  const _CapabilityCard({
    required this.icon,
    required this.label,
    required this.status,
  });

  final IconData icon;
  final String label;
  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return VCard(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.md,
        vertical: SpacingTokens.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 18),
          const SizedBox(height: SpacingTokens.sm),
          Text(label, style: theme.textTheme.labelMedium),
          const SizedBox(height: SpacingTokens.xs),
          Text(
            status,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
