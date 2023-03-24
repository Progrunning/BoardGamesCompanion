// ignore_for_file: constant_identifier_names
import 'package:hive/hive.dart';

import '../hive_boxes.dart';

export '../../extensions/game_mode_extensions.dart';

part 'game_mode.g.dart';

@HiveType(typeId: HiveBoxes.gameModeTypeId)
enum GameMode {
  @HiveField(0)
  Score,
  @HiveField(1)
  NoScore,
}
