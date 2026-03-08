import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily_app/l10n/generated/app_localizations.dart';
import 'package:verily_app/src/features/map/widgets/distance_slider.dart';
import 'package:verily_test_utils/verily_test_utils.dart';

void main() {
  group('DistanceSlider', () {
    Future<void> pumpDistanceSlider(WidgetTester tester, double value) {
      return tester.pumpApp(
        DistanceSlider(value: value, onChanged: (_) {}),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      );
    }

    testWidgets('renders slider with current value', (tester) async {
      await pumpDistanceSlider(tester, 10);

      expect(find.byType(Slider), findsOneWidget);
      expect(find.text('10 km'), findsOneWidget);
    });

    testWidgets('renders radar icon', (tester) async {
      await pumpDistanceSlider(tester, 5);

      expect(find.byIcon(Icons.radar), findsOneWidget);
    });

    testWidgets('displays rounded value', (tester) async {
      await pumpDistanceSlider(tester, 7.6);

      expect(find.text('8 km'), findsOneWidget);
    });

    testWidgets('displays minimum value (1 km)', (tester) async {
      await pumpDistanceSlider(tester, 1);

      expect(find.text('1 km'), findsOneWidget);
    });

    testWidgets('displays maximum value (50 km)', (tester) async {
      await pumpDistanceSlider(tester, 50);

      expect(find.text('50 km'), findsOneWidget);
    });
  });
}
