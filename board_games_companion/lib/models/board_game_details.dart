import 'package:board_games_companion/models/base_board_game.dart';
import 'package:board_games_companion/models/board_game_category.dart';

class BoardGameDetails extends BaseBoardGame {
  BoardGameDetails(String name) : super(name);

  String imageUrl;
  String description;
  List<BoardGameCategory> categories = List<BoardGameCategory>();
}
