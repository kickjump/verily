import 'package:test/test.dart';
import 'package:verily_core/verily_core.dart';

void main() {
  group('VerificationStatus', () {
    group('enum values', () {
      test('has exactly 5 values', () {
        expect(VerificationStatus.values, hasLength(5));
      });

      test('pending has correct value and displayName', () {
        expect(VerificationStatus.pending.value, equals('pending'));
        expect(VerificationStatus.pending.displayName, equals('Pending'));
      });

      test('processing has correct value and displayName', () {
        expect(VerificationStatus.processing.value, equals('processing'));
        expect(VerificationStatus.processing.displayName, equals('Processing'));
      });

      test('passed has correct value and displayName', () {
        expect(VerificationStatus.passed.value, equals('passed'));
        expect(VerificationStatus.passed.displayName, equals('Passed'));
      });

      test('failed has correct value and displayName', () {
        expect(VerificationStatus.failed.value, equals('failed'));
        expect(VerificationStatus.failed.displayName, equals('Failed'));
      });

      test('error has correct value and displayName', () {
        expect(VerificationStatus.error.value, equals('error'));
        expect(VerificationStatus.error.displayName, equals('Error'));
      });
    });

    group('fromValue()', () {
      test('returns pending for "pending"', () {
        expect(
          VerificationStatus.fromValue('pending'),
          equals(VerificationStatus.pending),
        );
      });

      test('returns processing for "processing"', () {
        expect(
          VerificationStatus.fromValue('processing'),
          equals(VerificationStatus.processing),
        );
      });

      test('returns passed for "passed"', () {
        expect(
          VerificationStatus.fromValue('passed'),
          equals(VerificationStatus.passed),
        );
      });

      test('returns failed for "failed"', () {
        expect(
          VerificationStatus.fromValue('failed'),
          equals(VerificationStatus.failed),
        );
      });

      test('returns error for "error"', () {
        expect(
          VerificationStatus.fromValue('error'),
          equals(VerificationStatus.error),
        );
      });

      test('throws ArgumentError for unknown value', () {
        expect(
          () => VerificationStatus.fromValue('unknown'),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              contains('Unknown VerificationStatus: unknown'),
            ),
          ),
        );
      });

      test('throws ArgumentError for empty string', () {
        expect(
          () => VerificationStatus.fromValue(''),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('is case-sensitive', () {
        expect(
          () => VerificationStatus.fromValue('Pending'),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('round-trip', () {
      test('all enum values survive fromValue round-trip', () {
        for (final status in VerificationStatus.values) {
          expect(VerificationStatus.fromValue(status.value), equals(status));
        }
      });
    });
  });
}
