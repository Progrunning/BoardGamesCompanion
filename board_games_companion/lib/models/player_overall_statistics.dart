import 'package:freezed_annotation/freezed_annotation.dart';

import 'hive/player.dart';

part 'player_overall_statistics.freezed.dart';

@freezed
class PlayerOverallStatistics with _$PlayerOverallStatistics {
  const factory PlayerOverallStatistics({
    required Player player,
    required int totalPlays,
    required int totalWins,
    double? competitiveWinRate,
    double? coopWinRate,
    @Default(<GamePlaysCount>[]) List<GamePlaysCount> gamesByPlays,
    HeadToHeadRecord? rival,
    HeadToHeadRecord? nemesis,
    @Default(<BuddyRecord>[]) List<BuddyRecord> buddies,
  }) = _PlayerOverallStatistics;

  const PlayerOverallStatistics._();

  bool get hasNoPlays => totalPlays == 0;
}

@freezed
class GamePlaysCount with _$GamePlaysCount {
  const factory GamePlaysCount({
    required String boardGameId,
    required String boardGameName,
    String? boardGameImageUrl,
    required int playCount,
  }) = _GamePlaysCount;
}

@freezed
class HeadToHeadRecord with _$HeadToHeadRecord {
  const factory HeadToHeadRecord({
    required Player opponent,
    required int wins,
    required int losses,
  }) = _HeadToHeadRecord;
}

@freezed
class BuddyRecord with _$BuddyRecord {
  const factory BuddyRecord({
    required Player buddy,
    required int sharedPlaysCount,
  }) = _BuddyRecord;
}
