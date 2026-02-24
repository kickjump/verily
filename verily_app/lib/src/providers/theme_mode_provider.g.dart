// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_mode_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages the application theme mode (light, dark, or system).
///
/// Defaults to [material.ThemeMode.system]. Widgets call
/// `ref.read(themeModeNotifierProvider.notifier).setThemeMode(...)` to switch.

@ProviderFor(ThemeModeNotifier)
final themeModeProvider = ThemeModeNotifierProvider._();

/// Manages the application theme mode (light, dark, or system).
///
/// Defaults to [material.ThemeMode.system]. Widgets call
/// `ref.read(themeModeNotifierProvider.notifier).setThemeMode(...)` to switch.
final class ThemeModeNotifierProvider
    extends $NotifierProvider<ThemeModeNotifier, material.ThemeMode> {
  /// Manages the application theme mode (light, dark, or system).
  ///
  /// Defaults to [material.ThemeMode.system]. Widgets call
  /// `ref.read(themeModeNotifierProvider.notifier).setThemeMode(...)` to switch.
  ThemeModeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeNotifierHash();

  @$internal
  @override
  ThemeModeNotifier create() => ThemeModeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(material.ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<material.ThemeMode>(value),
    );
  }
}

String _$themeModeNotifierHash() => r'138a22ec68485e21e46372652ac41f6e6dfec53a';

/// Manages the application theme mode (light, dark, or system).
///
/// Defaults to [material.ThemeMode.system]. Widgets call
/// `ref.read(themeModeNotifierProvider.notifier).setThemeMode(...)` to switch.

abstract class _$ThemeModeNotifier extends $Notifier<material.ThemeMode> {
  material.ThemeMode build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<material.ThemeMode, material.ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<material.ThemeMode, material.ThemeMode>,
              material.ThemeMode,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
