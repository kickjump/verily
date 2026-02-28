import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verily_ui/src/theme/color_tokens.dart';

/// Provides Material 3 light and dark themes for Verily.
abstract final class VerilyTheme {
  /// Light theme.
  static ThemeData get light => _buildTheme(Brightness.light);

  /// Dark theme.
  static ThemeData get dark => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;

    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: ColorTokens.primary,
          brightness: brightness,
        ).copyWith(
          primary: ColorTokens.primary,
          onPrimary: Colors.white,
          primaryContainer: isLight
              ? const Color(0xFFDCE5FF)
              : const Color(0xFF17377A),
          onPrimaryContainer: isLight
              ? const Color(0xFF0E1B33)
              : const Color(0xFFE9EEFF),
          secondary: ColorTokens.secondary,
          onSecondary: const Color(0xFF141414),
          secondaryContainer: isLight
              ? const Color(0xFFFFF0B8)
              : const Color(0xFF5A4715),
          onSecondaryContainer: isLight
              ? const Color(0xFF2B230C)
              : const Color(0xFFFFF1C8),
          tertiary: ColorTokens.tertiary,
          onTertiary: const Color(0xFF082D2B),
          tertiaryContainer: isLight
              ? const Color(0xFFD9FFF6)
              : const Color(0xFF1A4D47),
          onTertiaryContainer: isLight
              ? const Color(0xFF0D2E2C)
              : const Color(0xFFD9FFF6),
          error: ColorTokens.error,
          onError: Colors.white,
          errorContainer: isLight
              ? const Color(0xFFFFD8DE)
              : const Color(0xFF5F2330),
          onErrorContainer: isLight
              ? const Color(0xFF3A101A)
              : const Color(0xFFFFDCE2),
          surface: isLight ? ColorTokens.surfaceLight : ColorTokens.surfaceDark,
          onSurface: isLight ? ColorTokens.ink : const Color(0xFFEAF0FF),
          surfaceContainerLowest: isLight
              ? const Color(0xFFFFFFFF)
              : const Color(0xFF0A1324),
          surfaceContainerLow: isLight
              ? const Color(0xFFF7FAFF)
              : const Color(0xFF101A2E),
          surfaceContainer: isLight
              ? const Color(0xFFEFF4FF)
              : const Color(0xFF16243F),
          surfaceContainerHigh: isLight
              ? const Color(0xFFE8EEFF)
              : const Color(0xFF1B2D50),
          surfaceContainerHighest: isLight
              ? const Color(0xFFDFE8FF)
              : const Color(0xFF243A66),
          outline: isLight ? const Color(0xFFB7C6E8) : const Color(0xFF325287),
          outlineVariant: isLight
              ? const Color(0xFFD0DAF3)
              : const Color(0xFF223553),
          shadow: Colors.black,
          scrim: Colors.black,
        );

    final defaultTextTheme = isLight
        ? ThemeData.light().textTheme
        : ThemeData.dark().textTheme;
    final headingTextTheme = GoogleFonts.config.allowRuntimeFetching
        ? GoogleFonts.spaceGroteskTextTheme(defaultTextTheme)
        : defaultTextTheme;
    final baseTextTheme = headingTextTheme.copyWith(
      displayLarge: headingTextTheme.displayLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.7,
      ),
      displayMedium: headingTextTheme.displayMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
      ),
      headlineLarge: headingTextTheme.headlineLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      headlineMedium: headingTextTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      headlineSmall: headingTextTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      titleLarge: headingTextTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      titleMedium: headingTextTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      titleSmall: headingTextTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      labelLarge: headingTextTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
      labelMedium: headingTextTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: baseTextTheme,
      scaffoldBackgroundColor: isLight
          ? ColorTokens.backgroundLight
          : ColorTokens.backgroundDark,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        elevation: ElevationTokens.none,
        scrolledUnderElevation: ElevationTokens.low,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: ElevationTokens.low,
        color: isLight
            ? Colors.white.withValues(alpha: 0.9)
            : colorScheme.surfaceContainerLow.withValues(alpha: 0.92),
        shadowColor: Colors.black.withValues(alpha: isLight ? 0.08 : 0.24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.lg),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.85),
          ),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight
            ? Colors.white.withValues(alpha: 0.88)
            : colorScheme.surfaceContainerLow.withValues(alpha: 0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.md),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.md),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.md),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.md),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.md),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.md,
          vertical: SpacingTokens.md,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          foregroundColor: colorScheme.onSecondary,
          padding: const EdgeInsets.symmetric(
            horizontal: SpacingTokens.lg,
            vertical: SpacingTokens.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RadiusTokens.md),
          ),
          textStyle: baseTextTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          backgroundColor: isLight
              ? Colors.white.withValues(alpha: 0.64)
              : colorScheme.surfaceContainer.withValues(alpha: 0.58),
          side: BorderSide(color: colorScheme.outlineVariant),
          padding: const EdgeInsets.symmetric(
            horizontal: SpacingTokens.lg,
            vertical: SpacingTokens.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RadiusTokens.md),
          ),
          textStyle: baseTextTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: SpacingTokens.md,
            vertical: SpacingTokens.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RadiusTokens.sm),
          ),
          textStyle: baseTextTheme.labelLarge,
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.lg),
        ),
        backgroundColor: colorScheme.surfaceContainerLow,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(RadiusTokens.lg),
          ),
        ),
        showDragHandle: true,
        backgroundColor: colorScheme.surfaceContainerLow,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.surfaceContainerHighest,
        contentTextStyle: baseTextTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.sm),
        ),
      ),
      dividerTheme: const DividerThemeData(thickness: 0.5, space: 0),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.lg),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isLight
            ? Colors.white.withValues(alpha: 0.92)
            : const Color(0xFF0A1327),
        indicatorColor: isLight
            ? const Color(0xFFDCE4FF)
            : const Color(0xFF1C3562),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return baseTextTheme.labelSmall?.copyWith(
            color: selected
                ? colorScheme.onSurface
                : colorScheme.onSurfaceVariant,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
            size: 22,
          );
        }),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }
}
