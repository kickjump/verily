import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verily_ui/verily_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('VerilyTheme', () {
    test('light theme uses Material 3', () {
      final theme = VerilyTheme.light;
      expect(theme.useMaterial3, isTrue);
    });

    test('dark theme uses Material 3', () {
      final theme = VerilyTheme.dark;
      expect(theme.useMaterial3, isTrue);
    });

    test('light theme brightness is light', () {
      final theme = VerilyTheme.light;
      expect(theme.brightness, equals(Brightness.light));
    });

    test('dark theme brightness is dark', () {
      final theme = VerilyTheme.dark;
      expect(theme.brightness, equals(Brightness.dark));
    });

    test('themes use ColorTokens.primary as primary color', () {
      final lightTheme = VerilyTheme.light;
      final darkTheme = VerilyTheme.dark;

      // The theme explicitly sets primary to ColorTokens.primary via copyWith.
      expect(lightTheme.colorScheme.primary, equals(ColorTokens.primary));
      expect(darkTheme.colorScheme.primary, equals(ColorTokens.primary));
    });

    test('light theme has correct scaffold background color', () {
      final theme = VerilyTheme.light;
      expect(
        theme.scaffoldBackgroundColor,
        equals(ColorTokens.backgroundLight),
      );
    });

    test('dark theme has correct scaffold background color', () {
      final theme = VerilyTheme.dark;
      expect(theme.scaffoldBackgroundColor, equals(ColorTokens.backgroundDark));
    });

    test('themes have card theme with correct border radius', () {
      final theme = VerilyTheme.light;
      final cardShape = theme.cardTheme.shape! as RoundedRectangleBorder;
      expect(
        cardShape.borderRadius,
        equals(BorderRadius.circular(RadiusTokens.lg)),
      );
    });

    test('themes have appBar with zero elevation', () {
      final theme = VerilyTheme.light;
      expect(theme.appBarTheme.elevation, equals(ElevationTokens.none));
    });
  });
}
