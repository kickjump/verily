import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/map/map_screen.dart';
import 'package:verily_app/src/features/map/providers/location_providers.dart';
import 'package:verily_test_utils/verily_test_utils.dart';

void main() {
  group('MapScreen', () {
    Future<void> pumpMapScreen(WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          // Override userLocationProvider to avoid real geolocator calls.
          userLocationProvider.overrideWith(
            (ref) => Stream.value(
              Position(
                latitude: 37.7749,
                longitude: -122.4194,
                timestamp: DateTime.now(),
                accuracy: 10,
                altitude: 0,
                altitudeAccuracy: 0,
                heading: 0,
                headingAccuracy: 0,
                speed: 0,
                speedAccuracy: 0,
              ),
            ),
          ),
        ],
      );
      await tester.pumpApp(const MapScreen(), container: container);
    }

    testWidgets('renders FlutterMap widget', (tester) async {
      await pumpMapScreen(tester);

      expect(find.byType(FlutterMap), findsOneWidget);
    });

    testWidgets('renders search bar in app bar', (tester) async {
      await pumpMapScreen(tester);

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search places...'), findsOneWidget);
    });

    testWidgets('renders re-center FAB', (tester) async {
      await pumpMapScreen(tester);

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.my_location), findsOneWidget);
    });

    testWidgets('renders distance slider', (tester) async {
      await pumpMapScreen(tester);

      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('renders without errors when bbox is null', (tester) async {
      await pumpMapScreen(tester);
      await tester.pump();

      // Map should render cleanly without any actions loaded.
      expect(find.byType(FlutterMap), findsOneWidget);
    });
  });
}
