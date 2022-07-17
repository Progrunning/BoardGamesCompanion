import 'package:hive/hive.dart';

import '../hive_boxes.dart';

part 'game_winning_condition.g.dart';

@HiveType(typeId: HiveBoxes.WinningConditionTypeId)
enum GameWinningCondition {
  @HiveField(0)
  HighestScore,
  @HiveField(1)
  LowestScore,
}
