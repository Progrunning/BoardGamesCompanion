import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../common/enums/game_winning_condition.dart';
import '../../common/hive_boxes.dart';

part 'board_game_settings.freezed.dart';
part 'board_game_settings.g.dart';

/// Settings for a board game
///
/// [averageScorePrecision] represents the number of decimal digits.
@freezed
class BoardGameSettings with _$BoardGameSettings {
  @HiveType(typeId: HiveBoxes.boardGameSettingsTypeId, adapterName: 'BoardGameSettingsAdapter')
  const factory BoardGameSettings({
    @Default(GameWinningCondition.HighestScore) @HiveField(1) GameWinningCondition winningCondition,
    @Default(0) @HiveField(2) int averageScorePrecision,
  }) = _BoardGameSettings;
}
