// UuidValue construction uses experimental API.
// ignore_for_file: experimental_member_use

import 'package:uuid/uuid.dart';

/// A single entry on the leaderboard.
///
/// Mirrors the server-side `LeaderboardEntry` class in
/// `verily_server/lib/src/services/reward_service.dart`.
class LeaderboardEntry {
  LeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.totalPoints,
    required this.rewardCount,
  });

  final int rank;
  final UuidValue userId;
  final int totalPoints;
  final int rewardCount;
}
