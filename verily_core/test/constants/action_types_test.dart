import 'package:test/test.dart';
import 'package:verily_core/verily_core.dart';

void main() {
  group('ActionType', () {
    group('enum values', () {
      test('has exactly 2 values', () {
        expect(ActionType.values, hasLength(2));
      });

      test('oneOff has correct value and displayName', () {
        expect(ActionType.oneOff.value, equals('one_off'));
        expect(ActionType.oneOff.displayName, equals('One-Off'));
      });

      test('sequential has correct value and displayName', () {
        expect(ActionType.sequential.value, equals('sequential'));
        expect(ActionType.sequential.displayName, equals('Sequential'));
      });
    });

    group('fromValue()', () {
      test('returns oneOff for "one_off"', () {
        expect(ActionType.fromValue('one_off'), equals(ActionType.oneOff));
      });

      test('returns sequential for "sequential"', () {
        expect(
          ActionType.fromValue('sequential'),
          equals(ActionType.sequential),
        );
      });

      test('throws ArgumentError for unknown value', () {
        expect(
          () => ActionType.fromValue('unknown'),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              contains('Unknown ActionType: unknown'),
            ),
          ),
        );
      });

      test('throws ArgumentError for empty string', () {
        expect(
          () => ActionType.fromValue(''),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('is case-sensitive', () {
        expect(
          () => ActionType.fromValue('One_Off'),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('round-trip', () {
      test('all enum values survive fromValue round-trip', () {
        for (final type in ActionType.values) {
          expect(ActionType.fromValue(type.value), equals(type));
        }
      });
    });
  });
}
