import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/actions/providers/active_action_provider.dart';
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

    useEffect(() {
      if (!isRecording.value) return null;

      final timer = Timer.periodic(const Duration(seconds: 1), (_) {
        elapsedSeconds.value += 1;
      });
      return timer.cancel;
    }, [isRecording.value]);

    String formatTime(int totalSeconds) {
      final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
      final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    }

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

    return Scaffold(
      backgroundColor: const Color(0xFF081321),
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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(SpacingTokens.lg),
          children: [
            Container(
              height: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(RadiusTokens.lg),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF103455), Color(0xFF0F2338)],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.videocam_outlined,
                    color: Colors.white,
                    size: 54,
                  ),
                  const SizedBox(height: SpacingTokens.md),
                  const Text(
                    'Camera Preview',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.sm),
                  Text(
                    isRecording.value
                        ? 'Recording ${formatTime(elapsedSeconds.value)}'
                        : 'Ready to record proof',
                    style: const TextStyle(color: Colors.white70),
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
                    status: locationLog.value == null ? 'Not logged' : 'Logged',
                  ),
                ),
              ],
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
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: SpacingTokens.xs),
                    Text(
                      activeAction.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: SpacingTokens.xs),
                    Text(
                      '${activeAction.distanceFromNextLocation} to ${activeAction.nextLocationLabel}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            if (activeAction != null) const SizedBox(height: SpacingTokens.md),
            VCard(
              padding: const EdgeInsets.all(SpacingTokens.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activeAction != null
                        ? 'Evidence checklist for active action'
                        : 'Evidence checklist',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.sm),
                  for (var index = 0; index < checklistItems.length; index++)
                    Text('${index + 1}. ${checklistItems[index]}'),
                ],
              ),
            ),
            const SizedBox(height: SpacingTokens.md),
            if (locationLog.value != null)
              Text(
                locationLog.value!,
                style: const TextStyle(color: Colors.white70),
              ),
            const SizedBox(height: SpacingTokens.xl),
            Row(
              children: [
                Expanded(
                  child: VOutlinedButton(
                    onPressed: () => captureAudio.value = !captureAudio.value,
                    child: Text(
                      captureAudio.value ? 'Mute Audio' : 'Enable Audio',
                    ),
                  ),
                ),
                const SizedBox(width: SpacingTokens.md),
                Expanded(
                  child: VOutlinedButton(
                    onPressed: logLocation,
                    child: const Text('Log Location'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: SpacingTokens.md),
            VFilledButton(
              onPressed: toggleRecording,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isRecording.value ? Icons.stop : Icons.fiber_manual_record,
                  ),
                  const SizedBox(width: SpacingTokens.xs),
                  Text(
                    isRecording.value ? 'Stop Recording' : 'Start Recording',
                  ),
                ],
              ),
            ),
          ],
        ),
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
    return VCard(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.md,
        vertical: SpacingTokens.sm,
      ),
      child: Column(
        children: [
          Icon(icon),
          const SizedBox(height: SpacingTokens.xs),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: SpacingTokens.xs),
          Text(status, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
