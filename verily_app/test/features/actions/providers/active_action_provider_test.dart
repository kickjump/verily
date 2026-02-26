import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/actions/providers/active_action_provider.dart';

void main() {
  group('activeActionControllerProvider', () {
    const firstAction = ActiveAction(
      actionId: '101',
      title: 'Record 20 push-ups at a local park',
      nextLocationLabel: 'Memorial Park Track',
      distanceFromNextLocation: '0.4 mi',
      verificationChecklist: ['Show full body', 'Capture ambient audio'],
    );

    const secondAction = ActiveAction(
      actionId: '102',
      title: 'Capture a 30s cleanup clip on your street',
      nextLocationLabel: 'Oak Street Corner',
      distanceFromNextLocation: '0.8 mi',
      verificationChecklist: ['Before and after clip'],
    );

    test('set active action and clear update state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(activeActionControllerProvider.notifier);

      expect(container.read(activeActionControllerProvider), isNull);

      notifier.activeAction = firstAction;

      final activeAction = container.read(activeActionControllerProvider);
      expect(activeAction, isNotNull);
      expect(activeAction?.actionId, firstAction.actionId);
      expect(notifier.isActive(firstAction.actionId), isTrue);

      notifier.clear();

      expect(container.read(activeActionControllerProvider), isNull);
      expect(notifier.isActive(firstAction.actionId), isFalse);
    });

    test('toggle clears same action and sets different action', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(activeActionControllerProvider.notifier)
          .toggle(firstAction);
      expect(container.read(activeActionControllerProvider)?.actionId, '101');

      container
          .read(activeActionControllerProvider.notifier)
          .toggle(firstAction);
      expect(container.read(activeActionControllerProvider), isNull);

      container
          .read(activeActionControllerProvider.notifier)
          .toggle(secondAction);
      expect(container.read(activeActionControllerProvider)?.actionId, '102');
    });
  });
}
