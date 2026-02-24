import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/l10n/app_localizations.dart';
import 'package:verily_app/src/app/providers/theme_mode_provider.dart';
import 'package:verily_app/src/logging/app_logging.dart';
import 'package:verily_app/src/routing/app_router.dart';
import 'package:verily_ui/verily_ui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initAppLogging();

  final container = ProviderContainer();

  runApp(
    UncontrolledProviderScope(container: container, child: const VerilyApp()),
  );
}

/// Root application widget.
///
/// Uses [HookConsumerWidget] per project convention — no [StatelessWidget] or
/// [StatefulWidget] allowed.
class VerilyApp extends HookConsumerWidget {
  const VerilyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Verily',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: VerilyTheme.light,
      darkTheme: VerilyTheme.dark,
      themeMode: themeMode,

      // Routing
      routerConfig: router,

      // Localization
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
