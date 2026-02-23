/// Status of a reward distribution to a performer.
enum DistributionStatus {
  /// Distribution created, not yet sent.
  pending('pending'),

  /// Transaction sent to blockchain.
  sent('sent'),

  /// Transaction confirmed on-chain.
  confirmed('confirmed'),

  /// Distribution failed (will retry).
  failed('failed');

  const DistributionStatus(this.value);
  final String value;

  static DistributionStatus fromValue(String value) {
    return DistributionStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown DistributionStatus: $value'),
    );
  }
}
