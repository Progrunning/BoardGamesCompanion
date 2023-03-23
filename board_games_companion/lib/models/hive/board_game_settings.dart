import 'package:board_games_companion/common/enums/game_mode.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../common/enums/game_win_condition.dart';
import '../../common/hive_boxes.dart';

part 'board_game_settings.freezed.dart';
part 'board_game_settings.g.dart';

/// Settings for a board game
///
/// [averageScorePrecision] represents the number of decimal digits of the average scores when shown on screen.
@freezed
class BoardGameSettings with _$BoardGameSettings {
  @HiveType(typeId: HiveBoxes.boardGameSettingsTypeId, adapterName: 'BoardGameSettingsAdapter')
  const factory BoardGameSettings({
    @Default(GameWinCondition.HighestScore) @HiveField(1) GameWinCondition winCondition,
    @Default(0) @HiveField(2, defaultValue: 0) int averageScorePrecision,
    @Default(GameMode.Score) @HiveField(3, defaultValue: GameMode.Score) GameMode gameMode,
  }) = _BoardGameSettings;
}
