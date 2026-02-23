import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:verily_core/verily_core.dart';

/// Initializes logging for the Flutter application.
///
/// The [VLogger.source] is set to a platform-specific identifier, e.g.
/// `flutter:ios`, `flutter:android`, `flutter:web`, etc.
void initAppLogging() {
  final source = _resolveSource();
  VLogger.init(source: source, minLevel: kDebugMode ? Level.ALL : Level.INFO);

  Logger.root.onRecord.listen((record) {
    final entry = LogEntry(
      timestamp: record.time,
      level: record.level.name,
      source: VLogger.source,
      message: record.message,
      loggerName: record.loggerName,
      error: record.error?.toString(),
      stackTrace: record.stackTrace?.toString(),
    );

    final formatted = LogFormatter.format(entry);

    // In debug mode, print to the console.
    if (kDebugMode) {
      // ignore: avoid_print
      print(formatted);
    }
  });
}

String _resolveSource() {
  if (kIsWeb) return 'flutter:web';

  try {
    if (Platform.isIOS) return 'flutter:ios';
    if (Platform.isAndroid) return 'flutter:android';
    if (Platform.isMacOS) return 'flutter:macos';
    if (Platform.isWindows) return 'flutter:windows';
    if (Platform.isLinux) return 'flutter:linux';
  } catch (_) {
    // Platform may throw on some test environments.
  }

  return 'flutter:unknown';
}
