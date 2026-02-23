import 'package:test/test.dart';
import 'package:verily_core/verily_core.dart';

void main() {
  group('RewardType', () {
    test('has correct string values', () {
      expect(RewardType.points.value, 'points');
      expect(RewardType.badge.value, 'badge');
      expect(RewardType.sol.value, 'sol');
      expect(RewardType.splToken.value, 'spl_token');
      expect(RewardType.nft.value, 'nft');
    });

    test('fromValue returns correct enum', () {
      expect(RewardType.fromValue('points'), RewardType.points);
      expect(RewardType.fromValue('badge'), RewardType.badge);
      expect(RewardType.fromValue('sol'), RewardType.sol);
      expect(RewardType.fromValue('spl_token'), RewardType.splToken);
      expect(RewardType.fromValue('nft'), RewardType.nft);
    });

    test('fromValue throws on unknown value', () {
      expect(
        () => RewardType.fromValue('unknown'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('values list contains all types', () {
      expect(RewardType.values.length, 5);
    });
  });
}
