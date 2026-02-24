import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_core/verily_core.dart';
import 'package:verily_ui/verily_ui.dart';

/// Screen showing the verification status and result of a submission.
class SubmissionStatusScreen extends HookConsumerWidget {
  const SubmissionStatusScreen({
    required this.actionId,
    this.simulateVerification = true,
    super.key,
  });

  /// The action this submission belongs to.
  final String actionId;

  /// Whether to run the built-in delayed status simulation.
  ///
  /// Tests disable this to avoid pending timer leaks.
  final bool simulateVerification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Simulated verification progress.
    final status = useState(VerificationStatus.pending);
    final confidenceScore = useState<double>(0);
    final analysisText = useState('');

    // Simulate verification flow.
    useEffect(() {
      if (!simulateVerification) return null;

      var cancelled = false;

      Future<void> runSimulation() async {
        // Pending -> Processing
        await Future<void>.delayed(const Duration(seconds: 2));
        if (cancelled) return;
        status.value = VerificationStatus.processing;

        // Processing -> Result
        await Future<void>.delayed(const Duration(seconds: 3));
        if (cancelled) return;
        status.value = VerificationStatus.passed;
        confidenceScore.value = 0.94;
        analysisText.value =
            'The video clearly shows the performer completing 20 push-ups '
            'in a park environment. Proper form was maintained throughout. '
            'GPS location matches the required area. '
            'No spoofing or manipulation detected.';
      }

      runSimulation();
      return () => cancelled = true;
    }, [simulateVerification]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Submission Status'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(SpacingTokens.md),
          child: Column(
            children: [
              const Spacer(),

              // Status animation / icon
              _StatusIcon(status: status.value),
              const SizedBox(height: SpacingTokens.lg),

              // Status title
              Text(
                _statusTitle(status.value),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: SpacingTokens.sm),

              // Status subtitle
              Text(
                _statusSubtitle(status.value),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: SpacingTokens.xl),

              // Progress steps
              _ProgressSteps(currentStatus: status.value),
              const SizedBox(height: SpacingTokens.xl),

              // Result details (shown when verification completes)
              if (status.value == VerificationStatus.passed ||
                  status.value == VerificationStatus.failed) ...[
                VCard(
                  padding: const EdgeInsets.all(SpacingTokens.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Confidence score
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Confidence Score',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          VBadgeChip(
                            label:
                                '${(confidenceScore.value * 100).toStringAsFixed(0)}%',
                            backgroundColor: _confidenceColor(
                              confidenceScore.value,
                            ).withAlpha(30),
                            foregroundColor: _confidenceColor(
                              confidenceScore.value,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: SpacingTokens.sm),

                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(RadiusTokens.sm),
                        child: LinearProgressIndicator(
                          value: confidenceScore.value,
                          backgroundColor: colorScheme.surfaceContainerHighest,
                          color: _confidenceColor(confidenceScore.value),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.md),

                      // Analysis text
                      Text(
                        'AI Analysis',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.xs),
                      Text(
                        analysisText.value,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const Spacer(),

              // Action buttons
              if (status.value == VerificationStatus.passed)
                VFilledButton(
                  onPressed: () => context.go('/feed'),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.celebration_outlined),
                      SizedBox(width: SpacingTokens.sm),
                      Text('Back to Feed'),
                    ],
                  ),
                ),
              if (status.value == VerificationStatus.failed) ...[
                VFilledButton(
                  onPressed: () => context.pop(),
                  child: const Text('Try Again'),
                ),
                const SizedBox(height: SpacingTokens.sm),
                VTextButton(
                  onPressed: () => context.go('/feed'),
                  child: const Text('Back to Feed'),
                ),
              ],
              const SizedBox(height: SpacingTokens.md),
            ],
          ),
        ),
      ),
    );
  }

  String _statusTitle(VerificationStatus status) {
    return switch (status) {
      VerificationStatus.pending => 'Submission Received',
      VerificationStatus.processing => 'Verifying...',
      VerificationStatus.passed => 'Verification Passed!',
      VerificationStatus.failed => 'Verification Failed',
      VerificationStatus.error => 'Verification Error',
    };
  }

  String _statusSubtitle(VerificationStatus status) {
    return switch (status) {
      VerificationStatus.pending =>
        'Your video has been uploaded and is queued for verification.',
      VerificationStatus.processing =>
        'Our AI is analyzing your video submission.',
      VerificationStatus.passed =>
        'Congratulations! Your submission has been verified.',
      VerificationStatus.failed =>
        'Your submission did not meet the verification criteria.',
      VerificationStatus.error => 'Something went wrong. Please try again.',
    };
  }

  Color _confidenceColor(double score) {
    if (score >= 0.8) return ColorTokens.success;
    if (score >= 0.5) return ColorTokens.warning;
    return ColorTokens.error;
  }
}

/// Animated icon for the current verification status.
class _StatusIcon extends HookWidget {
  const _StatusIcon({required this.status});

  final VerificationStatus status;

  @override
  Widget build(BuildContext context) {
    final iconData = switch (status) {
      VerificationStatus.pending => Icons.cloud_upload_outlined,
      VerificationStatus.processing => Icons.psychology_outlined,
      VerificationStatus.passed => Icons.check_circle_outline,
      VerificationStatus.failed => Icons.cancel_outlined,
      VerificationStatus.error => Icons.error_outline,
    };

    final iconColor = switch (status) {
      VerificationStatus.pending => ColorTokens.warning,
      VerificationStatus.processing => ColorTokens.tertiary,
      VerificationStatus.passed => ColorTokens.success,
      VerificationStatus.failed => ColorTokens.error,
      VerificationStatus.error => ColorTokens.error,
    };

    final showSpinner =
        status == VerificationStatus.pending ||
        status == VerificationStatus.processing;

    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (showSpinner)
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: iconColor.withAlpha(100),
              ),
            ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withAlpha(30),
            ),
            child: Icon(iconData, size: 48, color: iconColor),
          ),
        ],
      ),
    );
  }
}

/// Step indicators showing the verification progress.
class _ProgressSteps extends HookWidget {
  const _ProgressSteps({required this.currentStatus});

  final VerificationStatus currentStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final steps = [
      (VerificationStatus.pending, 'Uploaded', Icons.cloud_done_outlined),
      (VerificationStatus.processing, 'Analyzing', Icons.psychology_outlined),
      (VerificationStatus.passed, 'Result', Icons.verified_outlined),
    ];

    int currentIndex() {
      return switch (currentStatus) {
        VerificationStatus.pending => 0,
        VerificationStatus.processing => 1,
        VerificationStatus.passed => 2,
        VerificationStatus.failed => 2,
        VerificationStatus.error => 2,
      };
    }

    final active = currentIndex();

    return Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          if (i > 0)
            Expanded(
              child: Container(
                height: 2,
                color: i <= active
                    ? ColorTokens.primary
                    : colorScheme.outlineVariant,
              ),
            ),
          _ProgressStep(
            icon: steps[i].$3,
            label: steps[i].$2,
            isCompleted: i < active,
            isActive: i == active,
          ),
        ],
      ],
    );
  }
}

/// A single progress step indicator.
class _ProgressStep extends HookWidget {
  const _ProgressStep({
    required this.icon,
    required this.label,
    required this.isCompleted,
    required this.isActive,
  });

  final IconData icon;
  final String label;
  final bool isCompleted;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final color = isCompleted
        ? ColorTokens.success
        : isActive
        ? ColorTokens.primary
        : colorScheme.outlineVariant;

    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (isCompleted || isActive)
                ? color.withAlpha(30)
                : Colors.transparent,
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(isCompleted ? Icons.check : icon, size: 18, color: color),
        ),
        const SizedBox(height: SpacingTokens.xs),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: (isCompleted || isActive)
                ? colorScheme.onSurface
                : colorScheme.onSurfaceVariant,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
