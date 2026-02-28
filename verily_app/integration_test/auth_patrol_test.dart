import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import 'common/patrol_helpers.dart';
import 'common/patrol_screenshot.dart';

void main() {
  group('Auth patrol -', () {
    patrolWidgetTest('login screen renders branded auth controls', ($) async {
      await $.pumpWidgetAndSettle(buildAuthApp());

      expect(find.text('Verily'), findsOneWidget);
      expect(find.text('Verify real-world actions with AI'), findsOneWidget);
      expect(find.text('or continue with'), findsOneWidget);
      expect(find.text('Google'), findsOneWidget);
      expect(find.text('Apple'), findsOneWidget);

      await maybeCapturePatrolScreenshot('auth_login', $.tester);
    });

    patrolWidgetTest('register flow transitions to verification step', (
      $,
    ) async {
      await $.pumpWidgetAndSettle(buildAuthApp());

      await $.tap(find.text('Sign Up'));
      await $.pumpAndSettle();
      expect(find.text('Create Account'), findsOneWidget);

      await $.enterText(find.byType(TextFormField).at(0), 'test@example.com');
      await $.enterText(find.byType(TextFormField).at(1), 'password123');
      await $.enterText(find.byType(TextFormField).at(2), 'password123');
      await $.tap(find.text('Continue'));
      await $.pumpAndSettle();

      expect(find.text('Verify Email'), findsOneWidget);
      expect(find.text('Verification Code'), findsOneWidget);

      await maybeCapturePatrolScreenshot(
        'auth_register_verification',
        $.tester,
      );
    });
  });
}
