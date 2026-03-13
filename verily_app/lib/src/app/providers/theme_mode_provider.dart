import 'package:flutter/material.dart' as material;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_mode_provider.g.dart';

/// SharedPreferences key used to persist the theme mode.
const _kThemeModeKey = 'verily_theme_mode';

/// Manages the application theme mode (light, dark, or system).
///
/// The chosen mode is persisted to [SharedPreferences] so it survives app
/// restarts. On first launch (or if the stored value is invalid) the notifier
/// falls back to [material.ThemeMode.system].
///
/// Widgets call
/// `ref.read(themeModeNotifierProvider.notifier).setThemeMode(...)` to switch.
@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  material.ThemeMode build() {
    // Start with system default; then hydrate from disk.
    _hydrate();
    return material.ThemeMode.system;
  }

  /// Loads the persisted theme mode from SharedPreferences and updates state.
  Future<void> _hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_kThemeModeKey);
    if (stored != null) {
      final mode = _themeModeFromString(stored);
      if (mode != null) {
        state = mode;
      }
    }
  }

  /// Updates the theme mode preference and persists it.
  // Riverpod notifiers expose methods, not setters.
  // ignore: use_setters_to_change_properties
  void setThemeMode(material.ThemeMode mode) {
    state = mode;
    _persist(mode);
  }

  /// Writes the theme mode to SharedPreferences asynchronously.
  Future<void> _persist(material.ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeModeKey, mode.name);
  }

  /// Converts a stored string back to a [material.ThemeMode], or `null` if
  /// the value is unrecognised.
  static material.ThemeMode? _themeModeFromString(String value) {
    switch (value) {
      case 'system':
        return material.ThemeMode.system;
      case 'light':
        return material.ThemeMode.light;
      case 'dark':
        return material.ThemeMode.dark;
      default:
        return null;
    }
  }
}
