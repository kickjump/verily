import 'package:test/test.dart';
import 'package:verily_core/verily_core.dart';

void main() {
  group('DistributionStatus', () {
    test('has correct string values', () {
      expect(DistributionStatus.pending.value, 'pending');
      expect(DistributionStatus.sent.value, 'sent');
      expect(DistributionStatus.confirmed.value, 'confirmed');
      expect(DistributionStatus.failed.value, 'failed');
    });

    test('fromValue returns correct enum', () {
      expect(DistributionStatus.fromValue('pending'), DistributionStatus.pending);
      expect(DistributionStatus.fromValue('sent'), DistributionStatus.sent);
      expect(DistributionStatus.fromValue('confirmed'), DistributionStatus.confirmed);
      expect(DistributionStatus.fromValue('failed'), DistributionStatus.failed);
    });

    test('fromValue throws on unknown value', () {
      expect(
        () => DistributionStatus.fromValue('unknown'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('values list contains all statuses', () {
      expect(DistributionStatus.values.length, 4);
    });
  });
}
