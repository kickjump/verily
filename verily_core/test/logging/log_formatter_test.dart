import 'package:test/test.dart';
import 'package:verily_core/verily_core.dart';

void main() {
  group('LogFormatter', () {
    late DateTime timestamp;

    setUp(() {
      timestamp = DateTime.utc(2026, 2, 17, 10, 30);
    });

    group('format()', () {
      test('includes timestamp in ISO 8601 format', () {
        final entry = LogEntry(
          timestamp: timestamp,
          level: 'INFO',
          source: 'server',
          message: 'test message',
          loggerName: 'TestLogger',
        );

        final result = LogFormatter.format(entry);
        expect(result, contains('[2026-02-17T10:30:00.000Z]'));
      });

      test('includes level', () {
        final entry = LogEntry(
          timestamp: timestamp,
          level: 'WARNING',
          source: 'server',
          message: 'test message',
          loggerName: 'TestLogger',
        );

        final result = LogFormatter.format(entry);
        expect(result, contains('[WARNING]'));
      });

      test('includes source', () {
        final entry = LogEntry(
          timestamp: timestamp,
          level: 'INFO',
          source: 'flutter:web',
          message: 'test message',
          loggerName: 'TestLogger',
        );

        final result = LogFormatter.format(entry);
        expect(result, contains('[flutter:web]'));
      });

      test('includes loggerName', () {
        final entry = LogEntry(
          timestamp: timestamp,
          level: 'INFO',
          source: 'server',
          message: 'test message',
          loggerName: 'ActionService',
        );

        final result = LogFormatter.format(entry);
        expect(result, contains('[ActionService]'));
      });

      test('includes message', () {
        final entry = LogEntry(
          timestamp: timestamp,
          level: 'INFO',
          source: 'server',
          message: 'User logged in successfully',
          loggerName: 'TestLogger',
        );

        final result = LogFormatter.format(entry);
        expect(result, contains('User logged in successfully'));
      });

      test('pads level to 7 characters', () {
        final infoEntry = LogEntry(
          timestamp: timestamp,
          level: 'INFO',
          source: 'server',
          message: 'test',
          loggerName: 'TestLogger',
        );

        final result = LogFormatter.format(infoEntry);
        // INFO padded to 7 chars: "INFO   "
        expect(result, contains('[INFO   ]'));
      });

      test('does not over-pad long level names', () {
        final warningEntry = LogEntry(
          timestamp: timestamp,
          level: 'WARNING',
          source: 'server',
          message: 'test',
          loggerName: 'TestLogger',
        );

        final result = LogFormatter.format(warningEntry);
        // WARNING is exactly 7 chars, no padding needed
        expect(result, contains('[WARNING]'));
      });

      test('produces correct full format without error', () {
        final entry = LogEntry(
          timestamp: timestamp,
          level: 'INFO',
          source: 'server',
          message: 'hello world',
          loggerName: 'MyLogger',
        );

        final result = LogFormatter.format(entry);
        expect(
          result,
          equals(
            '[2026-02-17T10:30:00.000Z] [INFO   ] [server] [MyLogger] '
            'hello world',
          ),
        );
      });

      test('does not contain error line when error is null', () {
        final entry = LogEntry(
          timestamp: timestamp,
          level: 'INFO',
          source: 'server',
          message: 'test',
          loggerName: 'TestLogger',
        );

        final result = LogFormatter.format(entry);
        expect(result, isNot(contains('error:')));
      });

      test('does not contain stackTrace line when stackTrace is null', () {
        final entry = LogEntry(
          timestamp: timestamp,
          level: 'INFO',
          source: 'server',
          message: 'test',
          loggerName: 'TestLogger',
        );

        final result = LogFormatter.format(entry);
        expect(result, isNot(contains('stackTrace:')));
      });
    });

    group('format() with error', () {
      test('appends error on indented line', () {
        final entry = LogEntry(
          timestamp: timestamp,
          level: 'SEVERE',
          source: 'server',
          message: 'something broke',
          loggerName: 'ErrorLogger',
          error: 'NullPointerException',
        );

        final result = LogFormatter.format(entry);
        expect(result, contains('\n  error: NullPointerException'));
      });

      test('error appears after the main log line', () {
        final entry = LogEntry(
          timestamp: timestamp,
          level: 'SEVERE',
          source: 'server',
          message: 'failure',
          loggerName: 'TestLogger',
          error: 'SomeError',
        );

        final result = LogFormatter.format(entry);
        final lines = result.split('\n');
        expect(lines, hasLength(2));
        expect(lines[0], contains('failure'));
        expect(lines[1], equals('  error: SomeError'));
      });
    });

    group('format() with stackTrace', () {
      test('appends stackTrace on indented line', () {
        final entry = LogEntry(
          timestamp: timestamp,
          level: 'SEVERE',
          source: 'server',
          message: 'crash',
          loggerName: 'TestLogger',
          stackTrace: '#0 main (file:///app.dart:10)',
        );

        final result = LogFormatter.format(entry);
        expect(
          result,
          contains('\n  stackTrace: #0 main (file:///app.dart:10)'),
        );
      });
    });

    group('format() with error and stackTrace', () {
      test('appends both error and stackTrace on separate indented lines', () {
        final entry = LogEntry(
          timestamp: timestamp,
          level: 'SEVERE',
          source: 'server',
          message: 'fatal error',
          loggerName: 'CrashLogger',
          error: 'OutOfMemoryError',
          stackTrace: '#0 main (file:///app.dart:42)',
        );

        final result = LogFormatter.format(entry);
        final lines = result.split('\n');
        expect(lines, hasLength(3));
        expect(lines[0], contains('fatal error'));
        expect(lines[1], equals('  error: OutOfMemoryError'));
        expect(lines[2], equals('  stackTrace: #0 main (file:///app.dart:42)'));
      });
    });
  });
}
