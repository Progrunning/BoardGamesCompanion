import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/hive/no_score_game_result.dart';
import '../../models/playthroughs/playthrough_details.dart';

part 'playthrough_migration.freezed.dart';

@freezed
class PlaythroughMigration with _$PlaythroughMigration {
  const factory PlaythroughMigration.init() = _init;
  const factory PlaythroughMigration.fromScoreToCooperative({
    required PlaythroughDetails playthroughDetails,
    CooperativeGameResult? cooperativeGameResult,
  }) = _fromScoreToCooperative;
}
