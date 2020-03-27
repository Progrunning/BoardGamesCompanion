import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/hive/base_board_game.dart';
import 'package:board_games_companion/models/hive/board_game_category.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'board_game_details.g.dart';

@HiveType(typeId: HiveBoxes.BoardGamesDetailsTypeId)
class BoardGameDetails extends BaseBoardGame with ChangeNotifier {
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
