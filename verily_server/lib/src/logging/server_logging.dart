import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:verily_core/verily_core.dart';

/// Manages server log sinks and lifecycle.
class ServerLoggingController {
  ServerLoggingController._(this._subscription, {_FileLogger? fileLogger})
    : _fileLogger = fileLogger;

  final StreamSubscription<LogRecord> _subscription;
  final _FileLogger? _fileLogger;

  Future<void> dispose() async {
    await _subscription.cancel();
    await _fileLogger?.dispose();
  }
}

/// Initializes server logging with environment-aware output and retention.
///
/// Environment variables:
/// - `VERILY_LOG_FORMAT`: `json` (default) or `text`
/// - `VERILY_LOG_STDOUT`: `true` (default) / `false`
/// - `VERILY_LOG_TO_FILE`: `true` / `false` (default)
/// - `VERILY_LOG_DIR`: log directory (default `.temp/logs`)
/// - `VERILY_LOG_FILE_PREFIX`: filename prefix (default `verily-server`)
/// - `VERILY_LOG_MAX_FILES`: number of rotated files to retain (default `7`)
/// - `VERILY_LOG_FILE_MAX_BYTES`: max file size before rotate (default `10485760`)
ServerLoggingController initServerLogging() {
  VLogger.init(source: 'server');

  final env = Platform.environment;
  final jsonFormat =
      (env['VERILY_LOG_FORMAT'] ?? 'json').toLowerCase() != 'text';
  final stdoutEnabled = _boolFromEnv(env['VERILY_LOG_STDOUT'], fallback: true);
  final fileEnabled = _boolFromEnv(env['VERILY_LOG_TO_FILE']);

  final fileLogger = fileEnabled ? _createFileLogger(env) : null;

  // ignore: cancel_subscriptions, reason: canceled by ServerLoggingController.dispose.
  final subscription = Logger.root.onRecord.listen((record) {
    final entry = LogEntry(
      timestamp: record.time,
      level: record.level.name,
      source: VLogger.source,
      message: record.message,
      loggerName: record.loggerName,
      error: record.error?.toString(),
      stackTrace: record.stackTrace?.toString(),
    );

    final formatted = jsonFormat
        ? jsonEncode(entry.toJson())
        : LogFormatter.format(entry);

    if (stdoutEnabled) {
      stdout.writeln(formatted);
    }

    fileLogger?.write(formatted);
  });

  return ServerLoggingController._(subscription, fileLogger: fileLogger);
}

bool _boolFromEnv(String? value, {bool fallback = false}) {
  if (value == null) return fallback;
  switch (value.trim().toLowerCase()) {
    case '1':
    case 'true':
    case 'yes':
    case 'on':
      return true;
    case '0':
    case 'false':
    case 'no':
    case 'off':
      return false;
    default:
      return fallback;
  }
}

class _FileLogger {
  _FileLogger({
    required this.baseFile,
    required this.maxBytes,
    required this.maxFiles,
  }) : _sink = baseFile.openWrite(mode: FileMode.writeOnlyAppend);

  final File baseFile;
  final int maxBytes;
  final int maxFiles;

  IOSink _sink;

  void write(String line) {
    _sink
      ..writeln(line)
      ..flush();
    _maybeRotate();
  }

  void _maybeRotate() {
    final currentSize = _existingFileSize(baseFile);
    if (currentSize < maxBytes) return;

    _sink
      ..flush()
      ..close();

    for (var i = maxFiles - 1; i >= 1; i--) {
      final older = File('${baseFile.path}.$i');
      if (!older.existsSync()) continue;

      // ignore: cascade_invocations, reason: branch-specific file operations are explicit here.
      if (i == maxFiles - 1) {
        older.deleteSync();
      } else {
        older.renameSync('${baseFile.path}.${i + 1}');
      }
    }

    final basePath = baseFile.path;
    _renameIfExists(baseFile, '$basePath.1');

    _sink = baseFile.openWrite(mode: FileMode.writeOnlyAppend);
  }

  static int _existingFileSize(File file) {
    if (!file.existsSync()) return 0;
    return file.lengthSync();
  }

  static void _renameIfExists(File file, String destinationPath) {
    if (!file.existsSync()) return;
    file.renameSync(destinationPath);
  }

  Future<void> dispose() async {
    final sink = _sink;
    await sink.flush();
    await sink.close();
  }
}

_FileLogger _createFileLogger(Map<String, String> env) {
  final dirPath = env['VERILY_LOG_DIR'] ?? '.temp/logs';
  final filePrefix = env['VERILY_LOG_FILE_PREFIX'] ?? 'verily-server';
  final maxFiles = int.tryParse(env['VERILY_LOG_MAX_FILES'] ?? '') ?? 7;
  final maxBytes =
      int.tryParse(env['VERILY_LOG_FILE_MAX_BYTES'] ?? '') ?? 10 * 1024 * 1024;

  final logDir = Directory(dirPath);
  if (!logDir.existsSync()) {
    logDir.createSync(recursive: true);
  }

  final logFile = File('${logDir.path}/$filePrefix.log');

  return _FileLogger(
    baseFile: logFile,
    maxBytes: maxBytes,
    maxFiles: maxFiles.clamp(1, 100),
  );
}
