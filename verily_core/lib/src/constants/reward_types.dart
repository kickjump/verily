/// Types of rewards that can be distributed via reward pools.
enum RewardType {
  /// Platform points (leaderboard only, no blockchain).
  points('points'),

  /// Achievement badge (database + optional NFT).
  badge('badge'),

  /// SOL transfer from reward pool.
  sol('sol'),

  /// SPL token transfer from reward pool.
  splToken('spl_token'),

  /// NFT mint for action completion.
  nft('nft');

  const RewardType(this.value);
  final String value;

  static RewardType fromValue(String value) {
    return RewardType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown RewardType: $value'),
    );
  }
}
