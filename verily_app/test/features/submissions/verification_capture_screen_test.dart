import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/actions/providers/active_action_provider.dart';
import 'package:verily_app/src/features/submissions/verification_capture_screen.dart';
import 'package:verily_test_utils/verily_test_utils.dart';
import 'package:verily_ui/verily_ui.dart';

void main() {
  group('VerificationCaptureScreen', () {
    Future<void> pumpScreen(
      WidgetTester tester, {
      ProviderContainer? container,
    }) async {
      await tester.pumpApp(
        const VerificationCaptureScreen(),
        container: container,
      );
    }

    testWidgets('renders capture title and checklist', (tester) async {
      await pumpScreen(tester);

      expect(find.text('Verification Capture'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Evidence checklist'),
        120,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Evidence checklist'), findsOneWidget);
      expect(find.textContaining('Keep your face'), findsOneWidget);
    });

    testWidgets('toggles audio capture state', (tester) async {
      await pumpScreen(tester);

      const toggleAudioButton = Key('verification_toggleAudioButton');
      await tester.scrollUntilVisible(
        find.byKey(toggleAudioButton),
        180,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Mute Audio'), findsOneWidget);
      final toggleButton = tester.widget<VOutlinedButton>(
        find.byKey(toggleAudioButton),
      );
      toggleButton.onPressed?.call();
      await tester.pump();

      expect(find.text('Enable Audio'), findsOneWidget);
    });

    testWidgets('logs location status when requested', (tester) async {
      await pumpScreen(tester);

      expect(find.text('Not logged'), findsOneWidget);
      const logLocationButton = Key('verification_logLocationButton');
      await tester.scrollUntilVisible(
        find.byKey(logLocationButton),
        180,
        scrollable: find.byType(Scrollable).first,
      );
      final locationButton = tester.widget<VOutlinedButton>(
        find.byKey(logLocationButton),
      );
      locationButton.onPressed?.call();
      await tester.pump();

      expect(find.textContaining('Logged at'), findsOneWidget);
    });

    testWidgets('starts and stops recording', (tester) async {
      await pumpScreen(tester);

      const startStopRecordingButton = Key(
        'verification_startStopRecordingButton',
      );
      await tester.scrollUntilVisible(
        find.byKey(startStopRecordingButton),
        120,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -160));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(startStopRecordingButton));
      expect(find.text('Start Recording'), findsOneWidget);
      await tester.tap(find.byKey(startStopRecordingButton));
      await tester.pump();

      expect(find.text('Stop Recording'), findsOneWidget);
      await tester.tap(find.byKey(startStopRecordingButton));
      await tester.pump();

      expect(find.text('Start Recording'), findsOneWidget);
    });

    testWidgets('shows active action distance and checklist when set', (
      tester,
    ) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(activeActionControllerProvider.notifier)
          .activeAction = const ActiveAction(
        actionId: '101',
        title: 'Record 20 push-ups at a local park',
        nextLocationLabel: 'Memorial Park Track',
        distanceFromNextLocation: '0.4 mi',
        verificationChecklist: [
          'Show your full body in frame while doing all reps.',
          'Capture ambient park audio from start to finish.',
          'Pan camera to the track sign before ending recording.',
        ],
      );

      await pumpScreen(tester, container: container);

      await tester.scrollUntilVisible(
        find.text('Active action'),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Active action'), findsOneWidget);
      expect(find.text('Record 20 push-ups at a local park'), findsOneWidget);
      expect(
        find.textContaining('0.4 mi to Memorial Park Track'),
        findsOneWidget,
      );
      await tester.scrollUntilVisible(
        find.text('Evidence checklist for active action'),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Evidence checklist for active action'), findsOneWidget);
      expect(
        find.textContaining(
          'Show your full body in frame while doing all reps.',
        ),
        findsOneWidget,
      );
    });
  });
}
