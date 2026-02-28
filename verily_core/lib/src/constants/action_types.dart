/// Types of actions available in Verily.
enum ActionType {
  /// A single action that is completed in one step.
  oneOff('one_off', 'One-Off'),

  /// A multi-step action completed sequentially over time.
  sequential('sequential', 'Sequential'),

  /// A habit-forming action repeated over a set number of days/weeks.
  ///
  /// Example: "Do 20 push-ups every day for 30 days" or "Meditate 5 times
  /// a week for 4 weeks."
  habit('habit', 'Habit');

  const ActionType(this.value, this.displayName);

  /// The serialized value stored in the database.
  final String value;

  /// Human-readable display name.
  final String displayName;

  /// Parses an [ActionType] from its string [value].
  static ActionType fromValue(String value) {
    return ActionType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => throw ArgumentError('Unknown ActionType: $value'),
    );
  }
}

/// Ordering mode for multi-step actions.
enum StepOrdering {
  /// Steps must be completed in order (step 1 → step 2 → step 3).
  ordered('ordered', 'In Order'),

  /// Steps can be completed in any order.
  unordered('unordered', 'Any Order');

  const StepOrdering(this.value, this.displayName);

  final String value;
  final String displayName;

  static StepOrdering fromValue(String value) {
    return StepOrdering.values.firstWhere(
      (s) => s.value == value,
      orElse: () => throw ArgumentError('Unknown StepOrdering: $value'),
    );
  }
}

/// Status of an action in its lifecycle.
enum ActionStatus {
  /// Draft — not yet published.
  draft('draft', 'Draft'),

  /// Published and accepting performers.
  active('active', 'Active'),

  /// Paused by the creator.
  paused('paused', 'Paused'),

  /// Completed — all slots filled or manually closed.
  completed('completed', 'Completed'),

  /// Expired past its deadline.
  expired('expired', 'Expired');

  const ActionStatus(this.value, this.displayName);

  final String value;
  final String displayName;

  static ActionStatus fromValue(String value) {
    return ActionStatus.values.firstWhere(
      (s) => s.value == value,
      orElse: () => throw ArgumentError('Unknown ActionStatus: $value'),
    );
  }
}
