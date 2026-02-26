import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/actions/providers/active_action_provider.dart';
import 'package:verily_app/src/features/submissions/verification_capture_screen.dart';
import 'package:verily_test_utils/verily_test_utils.dart';

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
      expect(find.text('Evidence checklist'), findsOneWidget);
      expect(find.textContaining('Keep your face'), findsOneWidget);
    });

    testWidgets('toggles audio capture state', (tester) async {
      await pumpScreen(tester);

      await tester.scrollUntilVisible(
        find.text('Mute Audio'),
        120,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Mute Audio'), findsOneWidget);
      await tester.tap(find.text('Mute Audio'));
      await tester.pump();

      expect(find.text('Enable Audio'), findsOneWidget);
    });

    testWidgets('logs location status when requested', (tester) async {
      await pumpScreen(tester);

      expect(find.text('Not logged'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Log Location'),
        120,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Log Location'));
      await tester.pump();

      expect(find.text('Logged'), findsWidgets);
      expect(find.textContaining('Logged at'), findsOneWidget);
    });

    testWidgets('starts and stops recording', (tester) async {
      await pumpScreen(tester);

      await tester.scrollUntilVisible(
        find.text('Start Recording'),
        120,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Start Recording'), findsOneWidget);
      await tester.tap(find.text('Start Recording'));
      await tester.pump();

      expect(find.text('Stop Recording'), findsOneWidget);
      await tester.tap(find.text('Stop Recording'));
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
