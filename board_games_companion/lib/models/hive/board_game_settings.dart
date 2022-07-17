import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../common/enums/game_winning_condition.dart';
import '../../common/hive_boxes.dart';

part 'board_game_settings.g.dart';

@HiveType(typeId: HiveBoxes.BoardGameSettingsTypeId)
class BoardGameSettings with ChangeNotifier {
  GameWinningCondition _winningCondition = GameWinningCondition.HighestScore;
  @HiveField(1)
  GameWinningCondition get winningCondition => _winningCondition;
  @HiveField(1)
  set winningCondition(GameWinningCondition value) {
    if (_winningCondition != value) {
      _winningCondition = value;
      notifyListeners();
    }
  }
}
