import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_ui/verily_ui.dart';

typedef TestLocalizationsDelegatesBuilder =
    Iterable<LocalizationsDelegate<dynamic>> Function();

TestLocalizationsDelegatesBuilder? _defaultLocalizationsDelegatesBuilder;

/// Registers default localization delegates used by `pumpApp` when a
/// test does not explicitly pass `localizationsDelegates`.
void registerDefaultLocalizationsDelegates(
  TestLocalizationsDelegatesBuilder builder,
) {
  _defaultLocalizationsDelegatesBuilder = builder;
}

/// Clears any delegates previously registered with
/// [registerDefaultLocalizationsDelegates].
void clearDefaultLocalizationsDelegates() {
  _defaultLocalizationsDelegatesBuilder = null;
}

/// Extension on [WidgetTester] to pump a widget wrapped with
/// [ProviderScope] and the Verily theme.
extension PumpApp on WidgetTester {
  /// Pumps [widget] inside a [ProviderScope] and [MaterialApp] using
  /// [VerilyTheme.light].
  ///
  /// Optionally pass a [container] for provider overrides, a [router]
  /// for GoRouter-based navigation, and [localizationsDelegates] /
  /// [supportedLocales] for i18n support.
  Future<void> pumpApp(
    Widget widget, {
    ProviderContainer? container,
    GoRouter? router,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    Iterable<Locale>? supportedLocales,
  }) {
    final Widget app;
    final resolvedLocalizationsDelegates =
        localizationsDelegates ?? _defaultLocalizationsDelegatesBuilder?.call();

    if (router != null) {
      app = MaterialApp.router(
        theme: VerilyTheme.light,
        darkTheme: VerilyTheme.dark,
        localizationsDelegates: resolvedLocalizationsDelegates,
        supportedLocales: supportedLocales ?? const [Locale('en')],
        routerConfig: router,
      );
    } else {
      app = MaterialApp(
        theme: VerilyTheme.light,
        darkTheme: VerilyTheme.dark,
        localizationsDelegates: resolvedLocalizationsDelegates,
        supportedLocales: supportedLocales ?? const [Locale('en')],
        home: widget,
      );
    }

    if (container != null) {
      return pumpWidget(
        UncontrolledProviderScope(container: container, child: app),
      );
    }

    return pumpWidget(ProviderScope(child: app));
  }
}
