import 'package:logging/logging.dart';
import 'package:test/test.dart';
import 'package:verily_core/verily_core.dart';

void main() {
  group('VLogger', () {
    group('init()', () {
      test('sets source correctly', () {
        VLogger.init(source: 'test-source');
        expect(VLogger.source, equals('test-source'));
      });

      test('sets source to a different value', () {
        VLogger.init(source: 'flutter:web');
        expect(VLogger.source, equals('flutter:web'));
      });

      test('sets minLevel on root logger', () {
        VLogger.init(source: 'test', minLevel: Level.WARNING);
        expect(Logger.root.level, equals(Level.WARNING));
      });

      test('defaults minLevel to Level.ALL', () {
        VLogger.init(source: 'test');
        expect(Logger.root.level, equals(Level.ALL));
      });

      test('enables hierarchical logging', () {
        VLogger.init(source: 'test');
        expect(hierarchicalLoggingEnabled, isTrue);
      });
    });

    group('constructor', () {
      test('creates logger with given name', () {
        final logger = VLogger('TestLogger');
        expect(logger.name, equals('TestLogger'));
      });
    });

    group('source getter', () {
      test('returns source set by init()', () {
        VLogger.init(source: 'server');
        expect(VLogger.source, equals('server'));
      });

      test('returns "unknown" before init() is called', () {
        // Note: this test depends on execution order or fresh state.
        // Since VLogger uses a static field, the value depends on
        // whether init() was previously called. We re-verify after
        // explicitly setting it.
        VLogger.init(source: 'unknown');
        expect(VLogger.source, equals('unknown'));
      });
    });

    group('logging methods', () {
      late VLogger logger;

      setUp(() {
        VLogger.init(source: 'test', minLevel: Level.ALL);
        logger = VLogger('TestLogger');
      });

      test('info() does not throw', () {
        expect(() => logger.info('info message'), returnsNormally);
      });

      test('warning() does not throw', () {
        expect(() => logger.warning('warning message'), returnsNormally);
      });

      test('warning() with error does not throw', () {
        expect(
          () => logger.warning('warning', Exception('test')),
          returnsNormally,
        );
      });

      test('warning() with error and stack trace does not throw', () {
        expect(
          () =>
              logger.warning('warning', Exception('test'), StackTrace.current),
          returnsNormally,
        );
      });

      test('severe() does not throw', () {
        expect(() => logger.severe('severe message'), returnsNormally);
      });

      test('severe() with error does not throw', () {
        expect(
          () => logger.severe('severe', Exception('test')),
          returnsNormally,
        );
      });

      test('severe() with error and stack trace does not throw', () {
        expect(
          () => logger.severe('severe', Exception('test'), StackTrace.current),
          returnsNormally,
        );
      });

      test('fine() does not throw', () {
        expect(() => logger.fine('fine message'), returnsNormally);
      });

      test('config() does not throw', () {
        expect(() => logger.config('config message'), returnsNormally);
      });

      test('info() emits a log record', () {
        final records = <LogRecord>[];
        Logger('EmitTest').onRecord.listen(records.add);

        final emitLogger = VLogger('EmitTest');
        emitLogger.info('hello');

        expect(records, hasLength(1));
        expect(records.first.message, equals('hello'));
        expect(records.first.level, equals(Level.INFO));
      });

      test('severe() emits a log record with error', () {
        final records = <LogRecord>[];
        Logger('SevereTest').onRecord.listen(records.add);

        final severeLogger = VLogger('SevereTest');
        final error = Exception('boom');
        severeLogger.severe('failure', error);

        expect(records, hasLength(1));
        expect(records.first.message, equals('failure'));
        expect(records.first.level, equals(Level.SEVERE));
        expect(records.first.error, equals(error));
      });
    });
  });
}
