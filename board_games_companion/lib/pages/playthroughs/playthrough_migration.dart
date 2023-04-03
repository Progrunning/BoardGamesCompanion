import 'package:board_games_companion/models/hive/no_score_game_result.dart';
import 'package:board_games_companion/models/playthroughs/playthrough_details.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'playthrough_migration.freezed.dart';

@freezed
class PlaythroughMigration with _$PlaythroughMigration {
  const factory PlaythroughMigration.init() = _init;
  const factory PlaythroughMigration.fromScoreToCooperative({
    required PlaythroughDetails playthroughDetails,
    CooperativeGameResult? cooperativeGameResult,
  }) = _fromScoreToCooperative;
}
