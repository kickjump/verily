import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/wallet/wallet_provider.dart';
import 'package:verily_app/src/features/wallet/wallet_screen.dart';
import 'package:verily_test_utils/verily_test_utils.dart';

void main() {
  group('WalletScreen', () {
    Future<void> pumpWalletScreen(WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          walletBalanceProvider.overrideWith((ref) async => 0.0),
          userWalletsProvider.overrideWith((ref) async => []),
        ],
      );
      await tester.pumpApp(const WalletScreen(), container: container);
      // Allow async providers to resolve.
      await tester.pumpAndSettle();
    }

    testWidgets('renders app bar with title', (tester) async {
      await pumpWalletScreen(tester);

      expect(find.text('Wallet'), findsOneWidget);
    });

    testWidgets('shows balance card', (tester) async {
      await pumpWalletScreen(tester);

      expect(find.text('Total Balance'), findsOneWidget);
      expect(find.text('0.0000 SOL'), findsOneWidget);
    });

    testWidgets('shows segmented tab bar', (tester) async {
      await pumpWalletScreen(tester);

      // Scroll down to make the segmented tab bar visible.
      await tester.scrollUntilVisible(
        find.text('Tokens'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('Tokens'), findsOneWidget);
      expect(find.text('NFTs'), findsOneWidget);
      expect(find.text('Activity'), findsOneWidget);
    });

    testWidgets('shows empty state for tokens tab', (tester) async {
      await pumpWalletScreen(tester);

      // Scroll down to make the tab content visible.
      await tester.scrollUntilVisible(
        find.text('No tokens yet'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('No tokens yet'), findsOneWidget);
    });

    testWidgets('has add wallet button in app bar', (tester) async {
      await pumpWalletScreen(tester);

      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });
}
