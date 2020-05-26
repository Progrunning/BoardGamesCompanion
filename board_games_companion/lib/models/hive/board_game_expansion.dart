import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:hive/hive.dart';

part 'board_game_expansion.g.dart';

@HiveType(typeId: HiveBoxes.BoardGamesExpansionId)
class BoardGamesExpansion {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
}
