/// Status of a reward pool.
enum PoolStatus {
  /// Pool is active and distributing rewards.
  active('active'),

  /// Pool funds have been fully distributed.
  depleted('depleted'),

  /// Pool has expired (past expiresAt).
  expired('expired'),

  /// Pool was cancelled by creator, remaining funds refunded.
  cancelled('cancelled');

  const PoolStatus(this.value);
  final String value;

  static PoolStatus fromValue(String value) {
    return PoolStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown PoolStatus: $value'),
    );
  }
}
