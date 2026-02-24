import 'dart:io';

import 'package:logging/logging.dart';
import 'package:verily_core/verily_core.dart';

/// Initializes server-side logging with file output for development.
void initServerLogging() {
  VLogger.init(source: 'server');

  final logDir = Directory('.temp/logs');
  if (!logDir.existsSync()) {
    logDir.createSync(recursive: true);
  }

  final logFile = File('${logDir.path}/verily-dev.log');
  final sink = logFile.openWrite(mode: FileMode.append);

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

    // Write to console and file.
    // ignore: avoid_print
    print(formatted);
    sink.writeln(formatted);
  });
}
