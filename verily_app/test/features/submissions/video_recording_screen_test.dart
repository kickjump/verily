import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily_app/src/features/submissions/video_recording_screen.dart';
import 'package:verily_test_utils/verily_test_utils.dart';

void main() {
  group('VideoRecordingScreen', () {
    Future<void> pumpVideoRecordingScreen(WidgetTester tester) async {
      await tester.pumpApp(
        const VideoRecordingScreen(actionId: 'test_action_1'),
      );
    }

    testWidgets('renders camera preview placeholder', (tester) async {
      await pumpVideoRecordingScreen(tester);

      expect(find.text('Camera Preview'), findsOneWidget);
      expect(find.text('Camera integration pending'), findsOneWidget);
      // Default is rear camera
      expect(find.byIcon(Icons.camera_rear), findsOneWidget);
    });

    testWidgets('renders record button', (tester) async {
      await pumpVideoRecordingScreen(tester);

      // The record button is a GestureDetector wrapping a Container with
      // a circular shape. We look for the AnimatedContainer inside it.
      expect(find.byType(AnimatedContainer), findsOneWidget);
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('renders GPS status indicator showing GPS Ready',
        (tester) async {
      await pumpVideoRecordingScreen(tester);

      // Default state has GPS signal.
      expect(find.text('GPS Ready'), findsOneWidget);
      expect(find.byIcon(Icons.gps_fixed), findsOneWidget);
    });

    testWidgets('renders close button', (tester) async {
      await pumpVideoRecordingScreen(tester);

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('renders camera flip button', (tester) async {
      await pumpVideoRecordingScreen(tester);

      expect(find.byIcon(Icons.flip_camera_ios_outlined), findsOneWidget);
    });

    testWidgets('renders info hint about recording', (tester) async {
      await pumpVideoRecordingScreen(tester);

      // The info box is visible before recording starts.
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
      expect(
        find.textContaining('Record a clear video'),
        findsOneWidget,
      );
    });

    testWidgets('has black background', (tester) async {
      await pumpVideoRecordingScreen(tester);

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.black);
    });
  });
}
