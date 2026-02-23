import 'package:test/test.dart';
import 'package:verily_core/verily_core.dart';

void main() {
  group('PoolStatus', () {
    test('has correct string values', () {
      expect(PoolStatus.active.value, 'active');
      expect(PoolStatus.depleted.value, 'depleted');
      expect(PoolStatus.expired.value, 'expired');
      expect(PoolStatus.cancelled.value, 'cancelled');
    });

    test('fromValue returns correct enum', () {
      expect(PoolStatus.fromValue('active'), PoolStatus.active);
      expect(PoolStatus.fromValue('depleted'), PoolStatus.depleted);
      expect(PoolStatus.fromValue('expired'), PoolStatus.expired);
      expect(PoolStatus.fromValue('cancelled'), PoolStatus.cancelled);
    });

    test('fromValue throws on unknown value', () {
      expect(
        () => PoolStatus.fromValue('unknown'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('values list contains all statuses', () {
      expect(PoolStatus.values.length, 4);
    });
  });
}
