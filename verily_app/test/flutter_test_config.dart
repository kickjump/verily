import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:verily_app/l10n/generated/app_localizations.dart';
import 'package:verily_test_utils/verily_test_utils.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  registerDefaultLocalizationsDelegates(
    () => AppLocalizations.localizationsDelegates,
  );
  tearDownAll(clearDefaultLocalizationsDelegates);

  await testMain();
}
