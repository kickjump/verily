import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily_ui/verily_ui.dart';

void main() {
  group('ColorTokens', () {
    test('primary is electric blue (0xFF2B59FF)', () {
      expect(ColorTokens.primary, equals(const Color(0xFF2B59FF)));
    });

    test('secondary is energetic yellow (0xFFFFD447)', () {
      expect(ColorTokens.secondary, equals(const Color(0xFFFFD447)));
    });

    test('tertiary is aqua (0xFF3EE0C2)', () {
      expect(ColorTokens.tertiary, equals(const Color(0xFF3EE0C2)));
    });

    test('error is coral red (0xFFFF5F7A)', () {
      expect(ColorTokens.error, equals(const Color(0xFFFF5F7A)));
    });

    test('success is green (0xFF3ED598)', () {
      expect(ColorTokens.success, equals(const Color(0xFF3ED598)));
    });

    test('warning is orange (0xFFFFB547)', () {
      expect(ColorTokens.warning, equals(const Color(0xFFFFB547)));
    });

    test('surfaceLight is (0xFFF6F9FF)', () {
      expect(ColorTokens.surfaceLight, equals(const Color(0xFFF6F9FF)));
    });

    test('surfaceDark is (0xFF0D172A)', () {
      expect(ColorTokens.surfaceDark, equals(const Color(0xFF0D172A)));
    });

    test('backgroundLight is (0xFFEFF4FF)', () {
      expect(ColorTokens.backgroundLight, equals(const Color(0xFFEFF4FF)));
    });

    test('backgroundDark is (0xFF050B17)', () {
      expect(ColorTokens.backgroundDark, equals(const Color(0xFF050B17)));
    });
  });

  group('SpacingTokens', () {
    test('xs is 4', () {
      expect(SpacingTokens.xs, equals(4.0));
    });

    test('sm is 8', () {
      expect(SpacingTokens.sm, equals(8.0));
    });

    test('md is 16', () {
      expect(SpacingTokens.md, equals(16.0));
    });

    test('lg is 24', () {
      expect(SpacingTokens.lg, equals(24.0));
    });

    test('xl is 32', () {
      expect(SpacingTokens.xl, equals(32.0));
    });

    test('xxl is 48', () {
      expect(SpacingTokens.xxl, equals(48.0));
    });
  });

  group('RadiusTokens', () {
    test('sm is 12', () {
      expect(RadiusTokens.sm, equals(12.0));
    });

    test('md is 18', () {
      expect(RadiusTokens.md, equals(18.0));
    });

    test('lg is 24', () {
      expect(RadiusTokens.lg, equals(24.0));
    });

    test('xl is 32', () {
      expect(RadiusTokens.xl, equals(32.0));
    });
  });

  group('ElevationTokens', () {
    test('none is 0', () {
      expect(ElevationTokens.none, equals(0.0));
    });

    test('low is 2', () {
      expect(ElevationTokens.low, equals(2.0));
    });

    test('med is 8', () {
      expect(ElevationTokens.med, equals(8.0));
    });
  });
}
