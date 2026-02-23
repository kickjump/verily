import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily_app/src/features/submissions/submission_status_screen.dart';
import 'package:verily_test_utils/verily_test_utils.dart';

void main() {
  group('SubmissionStatusScreen', () {
    Future<void> pumpSubmissionStatusScreen(WidgetTester tester) async {
      await tester.pumpApp(
        const SubmissionStatusScreen(actionId: 'test_action_1'),
      );
    }

    testWidgets('renders Submission Status app bar title', (tester) async {
      await pumpSubmissionStatusScreen(tester);

      expect(find.text('Submission Status'), findsOneWidget);
    });

    testWidgets('shows pending state initially', (tester) async {
      await pumpSubmissionStatusScreen(tester);

      // The initial state is VerificationStatus.pending.
      expect(find.text('Submission Received'), findsOneWidget);
      expect(
        find.text(
          'Your video has been uploaded and is queued for verification.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders upload icon for pending state', (tester) async {
      await pumpSubmissionStatusScreen(tester);

      expect(find.byIcon(Icons.cloud_upload_outlined), findsOneWidget);
    });

    testWidgets('renders progress steps', (tester) async {
      await pumpSubmissionStatusScreen(tester);

      // The three progress step labels.
      expect(find.text('Uploaded'), findsOneWidget);
      expect(find.text('Analyzing'), findsOneWidget);
      expect(find.text('Result'), findsOneWidget);
    });

    testWidgets('renders circular progress indicator for pending state',
        (tester) async {
      await pumpSubmissionStatusScreen(tester);

      // In pending and processing states, a CircularProgressIndicator shows.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('does not show action buttons in pending state',
        (tester) async {
      await pumpSubmissionStatusScreen(tester);

      // "Back to Feed" and "Try Again" buttons only show after verification.
      expect(find.text('Back to Feed'), findsNothing);
      expect(find.text('Try Again'), findsNothing);
    });

    testWidgets('does not render confidence score in pending state',
        (tester) async {
      await pumpSubmissionStatusScreen(tester);

      // Confidence score and AI analysis only show after verification completes.
      expect(find.text('Confidence Score'), findsNothing);
      expect(find.text('AI Analysis'), findsNothing);
    });
  });
}
