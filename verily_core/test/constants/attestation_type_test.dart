import 'package:test/test.dart';
import 'package:verily_core/verily_core.dart';

void main() {
  group('AttestationType', () {
    test('has correct string values', () {
      expect(AttestationType.playIntegrity.value, 'play_integrity');
      expect(AttestationType.appAttest.value, 'app_attest');
      expect(AttestationType.none.value, 'none');
    });

    test('fromValue returns correct enum', () {
      expect(
        AttestationType.fromValue('play_integrity'),
        AttestationType.playIntegrity,
      );
      expect(
        AttestationType.fromValue('app_attest'),
        AttestationType.appAttest,
      );
      expect(AttestationType.fromValue('none'), AttestationType.none);
    });

    test('fromValue throws on unknown value', () {
      expect(
        () => AttestationType.fromValue('unknown'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('values list contains all types', () {
      expect(AttestationType.values.length, 3);
    });
  });
}
