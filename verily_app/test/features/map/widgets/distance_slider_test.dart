import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily_app/src/features/map/widgets/distance_slider.dart';
import 'package:verily_test_utils/verily_test_utils.dart';

void main() {
  group('DistanceSlider', () {
    testWidgets('renders slider with current value', (tester) async {
      await tester.pumpApp(DistanceSlider(value: 10, onChanged: (_) {}));

      expect(find.byType(Slider), findsOneWidget);
      expect(find.text('10 km'), findsOneWidget);
    });

    testWidgets('renders radar icon', (tester) async {
      await tester.pumpApp(DistanceSlider(value: 5, onChanged: (_) {}));

      expect(find.byIcon(Icons.radar), findsOneWidget);
    });

    testWidgets('displays rounded value', (tester) async {
      await tester.pumpApp(DistanceSlider(value: 7.6, onChanged: (_) {}));

      expect(find.text('8 km'), findsOneWidget);
    });

    testWidgets('displays minimum value (1 km)', (tester) async {
      await tester.pumpApp(DistanceSlider(value: 1, onChanged: (_) {}));

      expect(find.text('1 km'), findsOneWidget);
    });

    testWidgets('displays maximum value (50 km)', (tester) async {
      await tester.pumpApp(DistanceSlider(value: 50, onChanged: (_) {}));

      expect(find.text('50 km'), findsOneWidget);
    });
  });
}
