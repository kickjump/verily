import 'package:flutter/material.dart' as material;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode_provider.g.dart';

/// Manages the application theme mode (light, dark, or system).
///
/// Defaults to [material.ThemeMode.system]. Widgets call
/// `ref.read(themeModeNotifierProvider.notifier).setThemeMode(...)` to switch.
@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  material.ThemeMode build() => material.ThemeMode.system;

  /// Updates the theme mode preference.
  void setThemeMode(material.ThemeMode mode) {
    state = mode;
  }
}
