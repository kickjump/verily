import 'package:flutter/material.dart';

/// Brand color tokens for Verily.
abstract final class ColorTokens {
  /// Primary brand color — electric blue for navigation and identity.
  static const Color primary = Color(0xFF2B59FF);

  /// Secondary accent — energetic yellow for main actions.
  static const Color secondary = Color(0xFFFFD447);

  /// Tertiary accent — aqua for status and highlights.
  static const Color tertiary = Color(0xFF3EE0C2);

  /// Accent tint for gradients and soft overlays.
  static const Color accent = Color(0xFF8CA7FF);

  /// Error color.
  static const Color error = Color(0xFFFF5F7A);

  /// Success color — green for passed verification states.
  static const Color success = Color(0xFF3ED598);

  /// Warning color — orange for pending/processing states.
  static const Color warning = Color(0xFFFFB547);

  /// Surface color for light theme.
  static const Color surfaceLight = Color(0xFFF6F9FF);

  /// Surface color for dark theme.
  static const Color surfaceDark = Color(0xFF0D172A);

  /// Background color for light theme.
  static const Color backgroundLight = Color(0xFFEFF4FF);

  /// Background color for dark theme.
  static const Color backgroundDark = Color(0xFF050B17);

  /// Primary text color used on light surfaces.
  static const Color ink = Color(0xFF0C1426);

  /// Muted text color used for supporting information.
  static const Color mist = Color(0xFF92A4CC);

  /// Border tint used for glassy cards and chips.
  static const Color glassBorder = Color(0x335D7EC2);
}

/// Reusable gradient tokens for app chrome and hero cards.
abstract final class GradientTokens {
  static const LinearGradient shellBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF071024), Color(0xFF0C1D3C), Color(0xFF12366C)],
  );

  static const LinearGradient shellBackgroundLight = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE8EEFF), Color(0xFFD6E4FF), Color(0xFFC2D6FF)],
  );

  static const LinearGradient heroCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D1B37), Color(0xFF17407B), Color(0xFF1E68B3)],
  );

  static const LinearGradient heroCardLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFDCE7FF), Color(0xFFBFD4FF), Color(0xFFA3C1FF)],
  );

  static const LinearGradient accentPill = LinearGradient(
    colors: [Color(0xFFFFE37A), Color(0xFFFFC93A)],
  );
}

/// Spacing tokens for consistent layout.
abstract final class SpacingTokens {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

/// Border radius tokens for consistent rounding.
abstract final class RadiusTokens {
  static const double sm = 12;
  static const double md = 18;
  static const double lg = 24;
  static const double xl = 32;
}

/// Elevation tokens for consistent depth.
abstract final class ElevationTokens {
  static const double none = 0;
  static const double low = 2;
  static const double med = 8;
}
