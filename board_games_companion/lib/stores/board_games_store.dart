import 'package:board_games_companion/models/board_game_details.dart';
import 'package:board_games_companion/services/board_games_service.dart';
import 'package:flutter/foundation.dart';

class BoardGamesStore with ChangeNotifier {
  final BoardGamesService _boardGamesService;

  List<BoardGameDetails> _boardGames;

  BoardGamesStore(this._boardGamesService);

  List<BoardGameDetails> get boardGames => _boardGames;

  Future<void> loadBoardGames() async {
    _boardGames = await _boardGamesService.retrieveBoardGames();
    notifyListeners();
  }
}
