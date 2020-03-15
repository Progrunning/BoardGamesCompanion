import 'package:board_games_companion/models/base_board_game.dart';

class BoardGameDetails extends BaseBoardGame {
  BoardGameDetails(String name) : super(name);

  String imageUrl;
  String description;
}
