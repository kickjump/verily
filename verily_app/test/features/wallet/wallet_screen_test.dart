import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily_app/src/features/wallet/wallet_screen.dart';
import 'package:verily_test_utils/verily_test_utils.dart';

void main() {
  group('WalletScreen', () {
    testWidgets('renders app bar with title', (tester) async {
      await tester.pumpApp(const WalletScreen());

      expect(find.text('Wallet'), findsOneWidget);
    });

    testWidgets('shows balance card', (tester) async {
      await tester.pumpApp(const WalletScreen());

      expect(find.text('Total Balance'), findsOneWidget);
      expect(find.text('0.00 SOL'), findsOneWidget);
    });

    testWidgets('shows segmented tab bar', (tester) async {
      await tester.pumpApp(const WalletScreen());

      expect(find.text('Tokens'), findsOneWidget);
      expect(find.text('NFTs'), findsOneWidget);
      expect(find.text('Activity'), findsOneWidget);
    });

    testWidgets('shows empty state for tokens tab', (tester) async {
      await tester.pumpApp(const WalletScreen());

      expect(find.text('No tokens yet'), findsOneWidget);
    });

    testWidgets('has add wallet button in app bar', (tester) async {
      await tester.pumpApp(const WalletScreen());

      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });
}
