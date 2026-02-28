import 'package:flutter_test/flutter_test.dart';
import 'package:verily_app/src/features/submissions/verification_capture_utils.dart';

void main() {
  group('verification_capture_utils', () {
    test(
      'calculateReadinessProgress includes checklist, location, and audio',
      () {
        final progress = calculateReadinessProgress(
          completedChecklistCount: 2,
          checklistLength: 3,
          hasLocationLog: true,
          captureAudioEnabled: true,
        );

        expect(progress, closeTo(0.8, 0.0001));
      },
    );

    test('calculateReadinessProgress handles empty checklist', () {
      final progress = calculateReadinessProgress(
        completedChecklistCount: 0,
        checklistLength: 0,
        hasLocationLog: false,
        captureAudioEnabled: false,
      );

      expect(progress, 0);
    });

    test('formatCaptureDuration normalizes and pads values', () {
      expect(formatCaptureDuration(0), '00:00');
      expect(formatCaptureDuration(9), '00:09');
      expect(formatCaptureDuration(61), '01:01');
      expect(formatCaptureDuration(-2), '00:00');
    });
  });
}
