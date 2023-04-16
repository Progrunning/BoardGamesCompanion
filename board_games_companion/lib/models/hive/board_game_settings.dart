import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../common/enums/game_classification.dart';
import '../../common/enums/game_family.dart';
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
    @Default(GameFamily.HighestScore) @HiveField(1) GameFamily gameFamily,
    @Default(0) @HiveField(2, defaultValue: 0) int averageScorePrecision,
    @Default(GameClassification.Score)
    @HiveField(3, defaultValue: GameClassification.Score)
        GameClassification gameClassification,
  }) = _BoardGameSettings;
}
