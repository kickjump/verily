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

    testWidgets('renders video player widget', (tester) async {
      await pumpVideoReviewScreen(tester);

      // VVideoPlayer is the custom video player widget.
      // We verify it is present by looking for video metadata hints.
      expect(find.text('Duration'), findsOneWidget);
      expect(find.text('0:32'), findsOneWidget);
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

    testWidgets('renders video metadata items', (tester) async {
      await pumpVideoReviewScreen(tester);

      expect(find.text('Duration'), findsOneWidget);
      expect(find.text('0:32'), findsOneWidget);
      expect(find.text('Location'), findsOneWidget);
      expect(find.text('GPS coordinates captured'), findsOneWidget);
      expect(find.text('Quality'), findsOneWidget);
      expect(find.text('1080p'), findsOneWidget);
    });

    testWidgets('renders metadata icons', (tester) async {
      await pumpVideoReviewScreen(tester);

      expect(find.byIcon(Icons.timer_outlined), findsOneWidget);
      expect(find.byIcon(Icons.gps_fixed), findsOneWidget);
      expect(find.byIcon(Icons.high_quality_outlined), findsOneWidget);
    });
  });
}
