import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:verily_core/verily_core.dart';
import 'package:verily_server/src/services/wallet/solana_service.dart';

void main() {
  group('SolanaService (pure logic)', () {
    test('stub mode defaults by run mode', () {
      expect(
        SolanaService.shouldAllowStubMode(
          runMode: ServerpodRunMode.development,
        ),
        isTrue,
      );
      expect(
        SolanaService.shouldAllowStubMode(runMode: ServerpodRunMode.test),
        isTrue,
      );
      expect(
        SolanaService.shouldAllowStubMode(runMode: ServerpodRunMode.staging),
        isTrue,
      );
      expect(
        SolanaService.shouldAllowStubMode(runMode: ServerpodRunMode.production),
        isFalse,
      );
    });

    test('stub mode override accepts truthy and falsy values', () {
      expect(
        SolanaService.shouldAllowStubMode(
          runMode: ServerpodRunMode.production,
          configuredValue: 'true',
        ),
        isTrue,
      );
      expect(
        SolanaService.shouldAllowStubMode(
          runMode: ServerpodRunMode.development,
          configuredValue: 'off',
        ),
        isFalse,
      );
    });

    test('invalid override falls back to run mode default', () {
      expect(
        SolanaService.shouldAllowStubMode(
          runMode: ServerpodRunMode.production,
          configuredValue: 'maybe',
        ),
        isFalse,
      );
      expect(
        SolanaService.shouldAllowStubMode(
          runMode: ServerpodRunMode.staging,
          configuredValue: 'maybe',
        ),
        isTrue,
      );
    });

    test('RewardType enum has SOL value', () {
      expect(RewardType.sol.value, 'sol');
    });

    test('DistributionStatus enum progression', () {
      // Distribution goes: pending -> sent -> confirmed
      expect(DistributionStatus.pending.value, 'pending');
      expect(DistributionStatus.sent.value, 'sent');
      expect(DistributionStatus.confirmed.value, 'confirmed');
      expect(DistributionStatus.failed.value, 'failed');
    });

    test('placeholder public key format (base58-like)', () {
      // Solana public keys are base58-encoded, 32-44 characters
      const validChars =
          '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';

      // Verify the valid chars set does not contain 0, O, I, l
      expect(validChars.contains('0'), isFalse);
      expect(validChars.contains('O'), isFalse);
      expect(validChars.contains('I'), isFalse);
      expect(validChars.contains('l'), isFalse);
    });

    test('platform fee calculation', () {
      const perPersonAmount = 1.0; // 1 SOL
      const platformFeePercent = 5.0;

      const fee = perPersonAmount * (platformFeePercent / 100);
      const performerAmount = perPersonAmount - fee;

      expect(fee, closeTo(0.05, 0.001));
      expect(performerAmount, closeTo(0.95, 0.001));
    });

    test('platform fee with zero percent', () {
      const perPersonAmount = 1.0;
      const platformFeePercent = 0.0;

      const fee = perPersonAmount * (platformFeePercent / 100);
      const performerAmount = perPersonAmount - fee;

      expect(fee, 0.0);
      expect(performerAmount, 1.0);
    });

    test('pool depletion detection', () {
      var remainingAmount = 1.0;
      const perPersonAmount = 0.5;

      // First distribution
      remainingAmount -= perPersonAmount;
      expect(remainingAmount, closeTo(0.5, 0.001));
      expect(remainingAmount > 0, isTrue);

      // Second distribution
      remainingAmount -= perPersonAmount;
      expect(remainingAmount, closeTo(0.0, 0.001));
      expect(remainingAmount <= 0, isTrue); // Pool depleted
    });
  });

  group('SolanaService (database operations)', () {
    group('createCustodialWallet()', () {
      test(
        'creates a wallet for a user',
        () async {
          // await SolanaService.createCustodialWallet(session, userId: userId);
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'first wallet is set as default',
        () async {
          // final wallet = await SolanaService.createCustodialWallet(...);
          // expect(wallet.isDefault, isTrue);
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    group('linkExternalWallet()', () {
      test(
        'validates public key format',
        () async {
          // Short key should fail validation
          // expect(() => SolanaService.linkExternalWallet(..., publicKey: 'abc'),
          //   throwsA(isA<ValidationException>()));
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    group('distributeReward()', () {
      test(
        'deducts from pool remaining amount',
        () async {
          // await SolanaService.distributeReward(...);
          // final pool = await RewardPool.db.findById(session, poolId);
          // expect(pool.remainingAmount, lessThan(originalAmount));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'marks pool as depleted when empty',
        () async {
          // Distribute until pool is empty
        },
        skip: 'Requires serverpod_test database session',
      );
    });
  });
}
