import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily_app/src/features/submissions/video_review_screen.dart';
import 'package:verily_test_utils/verily_test_utils.dart';

void main() {
  group('VideoReviewScreen', () {
    Future<void> pumpVideoReviewScreen(WidgetTester tester) async {
      await tester.pumpApp(const VideoReviewScreen(actionId: 'test_action_1'));
    }

    testWidgets('renders Review Video app bar title', (tester) async {
      await pumpVideoReviewScreen(tester);

      expect(find.text('Review Video'), findsOneWidget);
    });

    testWidgets('renders video metadata items', (tester) async {
      await pumpVideoReviewScreen(tester);

      expect(find.text('File Size'), findsOneWidget);
      expect(find.text('Unknown'), findsOneWidget);
      expect(find.text('Location'), findsOneWidget);
      expect(find.text('GPS coordinates captured'), findsOneWidget);
      expect(find.text('Video'), findsOneWidget);
      expect(find.text('No video'), findsOneWidget);
    });

    testWidgets('renders Retake button', (tester) async {
      await pumpVideoReviewScreen(tester);

      expect(find.text('Retake'), findsOneWidget);
      expect(find.byIcon(Icons.replay), findsOneWidget);
    });

    testWidgets('renders Submit button', (tester) async {
      await pumpVideoReviewScreen(tester);

      expect(find.text('Submit'), findsOneWidget);
      expect(find.byIcon(Icons.send), findsOneWidget);
    });

    testWidgets('renders metadata icons', (tester) async {
      await pumpVideoReviewScreen(tester);

      expect(find.byIcon(Icons.storage_outlined), findsOneWidget);
      expect(find.byIcon(Icons.gps_fixed), findsOneWidget);
      expect(find.byIcon(Icons.videocam_outlined), findsOneWidget);
    });

    testWidgets('shows ready state when video path is provided', (
      tester,
    ) async {
      await tester.pumpApp(
        const VideoReviewScreen(
          actionId: 'test_action_1',
          videoPath: '/tmp/test_video.mp4',
        ),
      );

      expect(find.text('Ready'), findsOneWidget);
    });
  });
}
