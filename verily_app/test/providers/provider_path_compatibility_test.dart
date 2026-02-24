import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/app/providers/theme_mode_provider.dart'
    as app_theme_provider;
import 'package:verily_app/src/features/map/providers/geocoding_providers.dart'
    as map_geocoding_provider;
import 'package:verily_app/src/features/map/providers/location_providers.dart'
    as map_location_provider;
import 'package:verily_app/src/providers/geocoding_providers.dart'
    as legacy_geocoding_provider;
import 'package:verily_app/src/providers/location_providers.dart'
    as legacy_location_provider;
import 'package:verily_app/src/providers/theme_mode_provider.dart'
    as legacy_theme_provider;

void main() {
  group('provider path compatibility', () {
    test('legacy exports point to the same provider instances', () {
      expect(
        identical(
          legacy_theme_provider.themeModeProvider,
          app_theme_provider.themeModeProvider,
        ),
        isTrue,
      );

      expect(
        identical(
          legacy_geocoding_provider.placeSearchProvider,
          map_geocoding_provider.placeSearchProvider,
        ),
        isTrue,
      );

      expect(
        identical(
          legacy_location_provider.userLocationProvider,
          map_location_provider.userLocationProvider,
        ),
        isTrue,
      );

      expect(
        identical(
          legacy_location_provider.actionsInBoundingBoxProvider,
          map_location_provider.actionsInBoundingBoxProvider,
        ),
        isTrue,
      );

      expect(
        identical(
          legacy_location_provider.nearbyActionsProvider,
          map_location_provider.nearbyActionsProvider,
        ),
        isTrue,
      );
    });

    test('theme mode updates are visible across both import paths', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        container.read(app_theme_provider.themeModeProvider),
        ThemeMode.system,
      );

      container
          .read(legacy_theme_provider.themeModeProvider.notifier)
          .setThemeMode(ThemeMode.dark);

      expect(
        container.read(app_theme_provider.themeModeProvider),
        ThemeMode.dark,
      );
    });
  });
}
