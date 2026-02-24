import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily_ui/verily_ui.dart';

void main() {
  group('VVideoPlayer', () {
    testWidgets('renders play button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: VVideoPlayer())),
      );

      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('onPlay callback fires', (tester) async {
      var played = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: VVideoPlayer(onPlay: () => played = true)),
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(played, isTrue);
    });

    testWidgets('renders with custom aspect ratio', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: VVideoPlayer(aspectRatio: 4 / 3)),
        ),
      );

      final aspectRatio = tester.widget<AspectRatio>(find.byType(AspectRatio));
      expect(aspectRatio.aspectRatio, closeTo(4 / 3, 0.01));
    });

    testWidgets('uses default 16:9 aspect ratio', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: VVideoPlayer())),
      );

      final aspectRatio = tester.widget<AspectRatio>(find.byType(AspectRatio));
      expect(aspectRatio.aspectRatio, closeTo(16 / 9, 0.01));
    });

    testWidgets('renders AspectRatio and Container', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: VVideoPlayer())),
      );

      expect(find.byType(AspectRatio), findsOneWidget);
      // The VVideoPlayer uses a Container with decoration
      expect(find.byType(Container), findsWidgets);
    });
  });
}
