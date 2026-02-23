import 'package:flutter_test/flutter_test.dart';
import 'package:verily_app/src/features/wallet/wallet_setup_screen.dart';
import 'package:verily_test_utils/verily_test_utils.dart';

void main() {
  group('WalletSetupScreen', () {
    testWidgets('renders title and description', (tester) async {
      await tester.pumpApp(const WalletSetupScreen());

      expect(find.text('Your Verily Wallet'), findsOneWidget);
      expect(
        find.textContaining('Create a wallet to receive'),
        findsOneWidget,
      );
    });

    testWidgets('shows create wallet button', (tester) async {
      await tester.pumpApp(const WalletSetupScreen());

      expect(find.text('Create Wallet'), findsOneWidget);
    });

    testWidgets('shows link existing wallet button', (tester) async {
      await tester.pumpApp(const WalletSetupScreen());

      expect(find.text('Link Existing Wallet'), findsOneWidget);
    });

    testWidgets('shows skip button', (tester) async {
      await tester.pumpApp(const WalletSetupScreen());

      expect(find.text('Skip for now'), findsOneWidget);
    });

    testWidgets('renders app bar', (tester) async {
      await tester.pumpApp(const WalletSetupScreen());

      expect(find.text('Set Up Wallet'), findsOneWidget);
    });
  });
}
