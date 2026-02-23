// NOTE: This test file requires freezed code generation to have been run.
// Run `dart run build_runner build` in the verily_core package before
// executing these tests.

import 'package:test/test.dart';
import 'package:verily_core/verily_core.dart';

void main() {
  group('LogEntry', () {
    late DateTime timestamp;

    setUp(() {
      timestamp = DateTime.utc(2026, 2, 17, 10, 30);
    });

    group('construction with required fields', () {
      test('creates instance with all required fields', () {
        final entry = LogEntry(
          timestamp: timestamp,
          level: 'INFO',
          source: 'server',
          message: 'test message',
          loggerName: 'TestLogger',
        );

        expect(entry.timestamp, equals(timestamp));
        expect(entry.level, equals('INFO'));
        expect(entry.source, equals('server'));
        expect(entry.message, equals('test message'));
        expect(entry.loggerName, equals('TestLogger'));
      });

      test('optional fields default to null', () {
        final entry = LogEntry(
          timestamp: timestamp,
          level: 'INFO',
          source: 'server',
          message: 'test',
          loggerName: 'TestLogger',
        );

        expect(entry.error, isNull);
        expect(entry.stackTrace, isNull);
      });
    });

    group('construction with optional fields', () {
      test('creates instance with error', () {
        final entry = LogEntry(
          timestamp: timestamp,
          level: 'SEVERE',
          source: 'server',
          message: 'failure',
          loggerName: 'ErrorLogger',
          error: 'NullPointerException',
        );

        expect(entry.error, equals('NullPointerException'));
        expect(entry.stackTrace, isNull);
      });

      test('creates instance with stackTrace', () {
        final entry = LogEntry(
          timestamp: timestamp,
          level: 'SEVERE',
          source: 'server',
          message: 'crash',
          loggerName: 'CrashLogger',
          stackTrace: '#0 main (file:///app.dart:10)',
        );

        expect(entry.stackTrace, equals('#0 main (file:///app.dart:10)'));
      });

      test('creates instance with both error and stackTrace', () {
        final entry = LogEntry(
          timestamp: timestamp,
          level: 'SEVERE',
          source: 'server',
          message: 'fatal',
          loggerName: 'FatalLogger',
          error: 'OutOfMemoryError',
          stackTrace: '#0 main (file:///app.dart:42)',
        );

        expect(entry.error, equals('OutOfMemoryError'));
        expect(entry.stackTrace, equals('#0 main (file:///app.dart:42)'));
      });
    });

    group('equality', () {
      test('two entries with same fields are equal', () {
        final entry1 = LogEntry(
          timestamp: timestamp,
          level: 'INFO',
          source: 'server',
          message: 'hello',
          loggerName: 'TestLogger',
        );

        final entry2 = LogEntry(
          timestamp: timestamp,
          level: 'INFO',
          source: 'server',
          message: 'hello',
          loggerName: 'TestLogger',
        );

        expect(entry1, equals(entry2));
      });

      test('two entries with same fields have same hashCode', () {
        final entry1 = LogEntry(
          timestamp: timestamp,
          level: 'INFO',
          source: 'server',
          message: 'hello',
          loggerName: 'TestLogger',
        );

        final entry2 = LogEntry(
          timestamp: timestamp,
          level: 'INFO',
          source: 'server',
          message: 'hello',
          loggerName: 'TestLogger',
        );

        expect(entry1.hashCode, equals(entry2.hashCode));
      });

      test('entries with different messages are not equal', () {
        final entry1 = LogEntry(
          timestamp: timestamp,
          level: 'INFO',
          source: 'server',
          message: 'hello',
          loggerName: 'TestLogger',
        );

        final entry2 = LogEntry(
          timestamp: timestamp,
          level: 'INFO',
          source: 'server',
          message: 'world',
          loggerName: 'TestLogger',
        );

        expect(entry1, isNot(equals(entry2)));
      });

      test('entries with different levels are not equal', () {
        final entry1 = LogEntry(
          timestamp: timestamp,
          level: 'INFO',
          source: 'server',
          message: 'test',
          loggerName: 'TestLogger',
        );

        final entry2 = LogEntry(
          timestamp: timestamp,
          level: 'SEVERE',
          source: 'server',
          message: 'test',
          loggerName: 'TestLogger',
        );

        expect(entry1, isNot(equals(entry2)));
      });

      test('entries with different optional fields are not equal', () {
        final entry1 = LogEntry(
          timestamp: timestamp,
          level: 'SEVERE',
          source: 'server',
          message: 'error',
          loggerName: 'TestLogger',
          error: 'SomeError',
        );

        final entry2 = LogEntry(
          timestamp: timestamp,
          level: 'SEVERE',
          source: 'server',
          message: 'error',
          loggerName: 'TestLogger',
        );

        expect(entry1, isNot(equals(entry2)));
      });
    });

    group('copyWith', () {
      test('creates a copy with updated message', () {
        final original = LogEntry(
          timestamp: timestamp,
          level: 'INFO',
          source: 'server',
          message: 'original',
          loggerName: 'TestLogger',
        );

        final copy = original.copyWith(message: 'updated');

        expect(copy.message, equals('updated'));
        expect(copy.timestamp, equals(original.timestamp));
        expect(copy.level, equals(original.level));
        expect(copy.source, equals(original.source));
        expect(copy.loggerName, equals(original.loggerName));
      });
    });

    group('serialization', () {
      test('toJson() produces a map with all fields', () {
        final entry = LogEntry(
          timestamp: timestamp,
          level: 'INFO',
          source: 'server',
          message: 'test',
          loggerName: 'TestLogger',
        );

        final json = entry.toJson();
        expect(json, isA<Map<String, dynamic>>());
        expect(json['level'], equals('INFO'));
        expect(json['source'], equals('server'));
        expect(json['message'], equals('test'));
        expect(json['loggerName'], equals('TestLogger'));
      });

      test('fromJson() round-trips correctly', () {
        final original = LogEntry(
          timestamp: timestamp,
          level: 'SEVERE',
          source: 'flutter:ios',
          message: 'crash',
          loggerName: 'CrashLogger',
          error: 'Exception',
          stackTrace: '#0 main',
        );

        final json = original.toJson();
        final restored = LogEntry.fromJson(json);

        expect(restored, equals(original));
      });
    });
  });
}
