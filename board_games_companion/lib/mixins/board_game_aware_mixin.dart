import 'package:board_games_companion/models/hive/board_game_details.dart';

mixin BoardGameAware {
  BoardGameDetails? _boardGame;
  BoardGameDetails? get boardGame => _boardGame;

  void setBoardGame(BoardGameDetails boardGame) {
    _boardGame = boardGame;
  }
}
