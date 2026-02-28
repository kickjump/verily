import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import 'common/patrol_helpers.dart';
import 'common/patrol_screenshot.dart';

void main() {
  group('Home and verification patrol -', () {
    patrolWidgetTest('center verify button opens verification capture', (
      $,
    ) async {
      await $.pumpWidgetAndSettle(buildHomeShellApp());
      await maybeCapturePatrolScreenshot('home_shell', $.tester);

      await $.tap(find.byKey(const Key('homeShell_verifyFab')));

      expect(find.text('Verification Capture'), findsOneWidget);
      expect(find.text('Camera Preview'), findsOneWidget);
      await maybeCapturePatrolScreenshot(
        'verification_capture_initial',
        $.tester,
      );
    });

    patrolWidgetTest('active action carries into verification context', (
      $,
    ) async {
      await $.pumpWidgetAndSettle(buildHomeShellApp());

      await $.tap(find.byKey(const Key('home_featured_setActive_101')));
      expect(find.byKey(const Key('home_activeActionCard')), findsOneWidget);

      await $.tap(find.byKey(const Key('homeShell_verifyFab')));

      await $.tester.scrollUntilVisible(
        find.text('Evidence checklist for active action'),
        140,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Evidence checklist for active action'), findsOneWidget);
      expect(find.text('Record 20 push-ups at a local park'), findsOneWidget);
      await maybeCapturePatrolScreenshot(
        'verification_capture_active_action',
        $.tester,
      );
    });

    patrolWidgetTest('capture flow logs evidence and submits', ($) async {
      await $.pumpWidgetAndSettle(buildHomeShellApp());

      await $.tap(find.byKey(const Key('home_featured_setActive_101')));
      await $.tap(find.byKey(const Key('homeShell_verifyFab')));

      final scrollable = find.byType(Scrollable).first;

      await $.tester.scrollUntilVisible(
        find.byKey(const Key('verification_logLocationButton')),
        160,
        scrollable: scrollable,
      );
      await $.tap(find.byKey(const Key('verification_logLocationButton')));
      expect(find.textContaining('Logged at'), findsOneWidget);

      for (var index = 0; index < 3; index++) {
        await $.tester.scrollUntilVisible(
          find.byKey(Key('verification_checklistItem_$index')),
          120,
          scrollable: scrollable,
        );
        await $.tap(find.byKey(Key('verification_checklistItem_$index')));
      }

      await $.tester.scrollUntilVisible(
        find.byKey(const Key('verification_startStopRecordingButton')),
        120,
        scrollable: scrollable,
      );
      await $.tap(
        find.byKey(const Key('verification_startStopRecordingButton')),
      );
      expect(find.text('Stop Recording'), findsOneWidget);
      await $.tap(
        find.byKey(const Key('verification_startStopRecordingButton')),
      );
      expect(find.text('Start Recording'), findsOneWidget);

      await $.tester.scrollUntilVisible(
        find.byKey(const Key('verification_submitButton')),
        120,
        scrollable: scrollable,
      );
      await $.tap(find.byKey(const Key('verification_submitButton')));
      expect(
        find.textContaining('Submission status for action 101'),
        findsOneWidget,
      );
      await maybeCapturePatrolScreenshot('submission_status', $.tester);
    });
  });
}
