import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/l10n/generated/app_localizations.dart';

import 'package:verily_test_utils/verily_test_utils.dart';

/// Extension on [WidgetTester] that wraps [PumpApp.pumpApp] with
/// [AppLocalizations] delegates included by default.
///
/// Use this instead of `pumpApp` in all widget tests that render
/// screens which use `AppLocalizations.of(context)`.
extension PumpAppL10n on WidgetTester {
  /// Pumps [widget] with [AppLocalizations] delegates pre-configured.
  Future<void> pumpAppL10n(
    Widget widget, {
    ProviderContainer? container,
    GoRouter? router,
    Iterable<Locale>? supportedLocales,
  }) {
    return pumpApp(
      widget,
      container: container,
      router: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: supportedLocales ?? AppLocalizations.supportedLocales,
    );
  }
}
