import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_action_provider.g.dart';

@immutable
class ActiveAction {
  const ActiveAction({
    required this.actionId,
    required this.title,
    required this.nextLocationLabel,
    required this.distanceFromNextLocation,
    required this.verificationChecklist,
  });

  final String actionId;
  final String title;
  final String nextLocationLabel;
  final String distanceFromNextLocation;
  final List<String> verificationChecklist;
}

/// Stores the user-selected active action context for verification flow.
@riverpod
class ActiveActionController extends _$ActiveActionController {
  @override
  ActiveAction? build() => null;

  ActiveAction? get activeAction => state;

  set activeAction(ActiveAction action) {
    state = action;
  }

  void toggle(ActiveAction action) {
    if (state?.actionId == action.actionId) {
      clear();
      return;
    }
    activeAction = action;
  }

  void clear() {
    state = null;
  }

  bool isActive(String actionId) {
    return state?.actionId == actionId;
  }
}
