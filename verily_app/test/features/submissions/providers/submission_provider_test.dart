import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/submissions/providers/submission_provider.dart';

void main() {
  group('SubmissionNotifier', () {
    test('initial state is AsyncData(null)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(submissionProvider);
      expect(state, isA<AsyncData<void>>());
      expect(state.value, isNull);
    });

    test('reset returns state to AsyncData(null)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(submissionProvider.notifier).reset();
      final state = container.read(submissionProvider);
      expect(state, isA<AsyncData<void>>());
      expect(state.value, isNull);
    });
  });
}
