import 'dart:async';
import 'dart:convert';
import 'dart:io' show ContentType, HttpClient, Platform;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:verily_core/verily_core.dart';

const _appLogSinkEnabled = bool.fromEnvironment('APP_LOG_SINK_ENABLED');
const _appLogSinkUrl = String.fromEnvironment('APP_LOG_SINK_URL');
const _appLogSampleRate = String.fromEnvironment(
  'APP_LOG_SAMPLE_RATE',
  defaultValue: '1.0',
);
const _appLogTimeoutMs = int.fromEnvironment(
  'APP_LOG_TIMEOUT_MS',
  defaultValue: 3000,
);

/// Initializes logging for the Flutter application.
///
/// The [VLogger.source] is set to a platform-specific identifier, e.g.
/// `flutter:ios`, `flutter:android`, `flutter:web`, etc.
void initAppLogging() {
  final source = _resolveSource();
  VLogger.init(source: source);

  final productionSink = _createProductionLogSink();

  Logger.root.onRecord.listen((record) {
    final entry = LogEntry(
      timestamp: record.time,
      level: record.level.name,
      source: VLogger.source,
      message: record.message,
      loggerName: record.loggerName,
      error: record.error?.toString(),
      stackTrace: record.stackTrace?.toString(),
      environment: kDebugMode ? 'debug' : 'release',
    );

    final formatted = LogFormatter.format(entry);

    if (kDebugMode) {
      // ignore: avoid_print, reason: console output is intentional during local development.
      print(formatted);
    } else {
      productionSink?.send(entry);
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
  } on Exception catch (_) {
    // Platform may throw on some test environments.
  }

  return 'flutter:unknown';
}

_ProductionLogSink? _createProductionLogSink() {
  if (!_appLogSinkEnabled || _appLogSinkUrl.trim().isEmpty) {
    return null;
  }

  final parsedSampleRate = double.tryParse(_appLogSampleRate) ?? 1.0;
  final sampledRate = parsedSampleRate.clamp(0.0, 1.0);
  final timeout = Duration(milliseconds: _appLogTimeoutMs.clamp(250, 15000));

  return _ProductionLogSink(
    endpoint: Uri.parse(_appLogSinkUrl),
    sampleRate: sampledRate,
    timeout: timeout,
  );
}

class _ProductionLogSink {
  _ProductionLogSink({
    required this.endpoint,
    required this.sampleRate,
    required this.timeout,
    Random? random,
    HttpClient? client,
  }) : _random = random ?? Random(),
       _client = client ?? HttpClient();

  final Uri endpoint;
  final double sampleRate;
  final Duration timeout;
  final Random _random;
  final HttpClient _client;

  void send(LogEntry entry) {
    if (!_shouldSend()) return;
    unawaited(_post(entry));
  }

  bool _shouldSend() {
    if (sampleRate >= 1.0) return true;
    if (sampleRate <= 0.0) return false;
    return _random.nextDouble() <= sampleRate;
  }

  Future<void> _post(LogEntry entry) async {
    try {
      final request = await _client.postUrl(endpoint).timeout(timeout);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(entry.toJson()));

      final response = await request.close().timeout(timeout);
      await response.drain<void>();
    } on Object {
      // Never throw from the logging pipeline.
    }
  }
}
