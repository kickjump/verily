import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily_ui/verily_ui.dart';

void main() {
  group('ColorTokens', () {
    test('primary is teal (0xFF00897B)', () {
      expect(ColorTokens.primary, equals(const Color(0xFF00897B)));
    });

    test('secondary is deep orange (0xFFFF6D00)', () {
      expect(ColorTokens.secondary, equals(const Color(0xFFFF6D00)));
    });

    test('tertiary is indigo (0xFF3949AB)', () {
      expect(ColorTokens.tertiary, equals(const Color(0xFF3949AB)));
    });

    test('error is red (0xFFB71C1C)', () {
      expect(ColorTokens.error, equals(const Color(0xFFB71C1C)));
    });

    test('success is green (0xFF2E7D32)', () {
      expect(ColorTokens.success, equals(const Color(0xFF2E7D32)));
    });

    test('warning is amber (0xFFF9A825)', () {
      expect(ColorTokens.warning, equals(const Color(0xFFF9A825)));
    });

    test('surfaceLight is (0xFFFAFAFA)', () {
      expect(ColorTokens.surfaceLight, equals(const Color(0xFFFAFAFA)));
    });

    test('surfaceDark is (0xFF121212)', () {
      expect(ColorTokens.surfaceDark, equals(const Color(0xFF121212)));
    });

    test('backgroundLight is white (0xFFFFFFFF)', () {
      expect(ColorTokens.backgroundLight, equals(const Color(0xFFFFFFFF)));
    });

    test('backgroundDark is (0xFF1E1E1E)', () {
      expect(ColorTokens.backgroundDark, equals(const Color(0xFF1E1E1E)));
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
    test('sm is 8', () {
      expect(RadiusTokens.sm, equals(8.0));
    });

    test('md is 12', () {
      expect(RadiusTokens.md, equals(12.0));
    });

    test('lg is 16', () {
      expect(RadiusTokens.lg, equals(16.0));
    });

    test('xl is 24', () {
      expect(RadiusTokens.xl, equals(24.0));
    });
  });

  group('ElevationTokens', () {
    test('none is 0', () {
      expect(ElevationTokens.none, equals(0.0));
    });

    test('low is 1', () {
      expect(ElevationTokens.low, equals(1.0));
    });

    test('med is 4', () {
      expect(ElevationTokens.med, equals(4.0));
    });
  });
}
