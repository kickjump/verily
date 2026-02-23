/// Types of actions available in Verily.
enum ActionType {
  /// A single action that is completed in one step.
  oneOff('one_off', 'One-Off'),

  /// A multi-step action completed sequentially over time.
  sequential('sequential', 'Sequential');

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
