import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/base_board_game.dart';
import 'package:board_games_companion/models/board_game_category.dart';
import 'package:hive/hive.dart';

part 'board_game_details.g.dart';

@HiveType(typeId: HiveBoxes.BoardGamesDetailsTypeId)
class BoardGameDetails extends BaseBoardGame {
  BoardGameDetails([String name]) : super(name);

  @HiveField(5)
  String imageUrl;
  @HiveField(6)
  String description;

  @HiveField(7)
  List<BoardGameCategory> categories = List<BoardGameCategory>();
  @HiveField(8)
  double rating;
  @HiveField(9)
  int votes;
}
