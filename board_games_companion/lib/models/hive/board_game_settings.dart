import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../common/enums/game_winning_condition.dart';
import '../../common/hive_boxes.dart';

part 'board_game_settings.freezed.dart';
part 'board_game_settings.g.dart';

@freezed
class BoardGameSettings with _$BoardGameSettings {
  @HiveType(typeId: HiveBoxes.boardGameSettingsTypeId, adapterName: 'BoardGameSettingsAdapter')
  const factory BoardGameSettings({
    @Default(GameWinningCondition.HighestScore) @HiveField(1) GameWinningCondition winningCondition,
  }) = _BoardGameSettings;
}
