import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/services/board_games_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class BoardGamesStore with ChangeNotifier {
  final BoardGamesService _boardGamesService;

  List<BoardGameDetails> _boardGames;
  LoadDataState _loadDataState = LoadDataState.None;

  BoardGamesStore(this._boardGamesService);

  LoadDataState get loadDataState => _loadDataState;
  List<BoardGameDetails> get boardGames => _boardGames;

  Future<void> loadBoardGames() async {
    _loadDataState = LoadDataState.Loading;
    notifyListeners();

    try {
      _boardGames = await _boardGamesService.retrieveBoardGames();
    } catch (e, stack) {
      Crashlytics.instance.recordError(e, stack);
      _loadDataState = LoadDataState.Error;
    }

    _loadDataState = LoadDataState.Loaded;
    notifyListeners();
  }

  Future<void> addOrUpdateBoardGame(BoardGameDetails boardGameDetails) async {
    try {
      await _boardGamesService.addOrUpdateBoardGame(boardGameDetails);
    } catch (e, stack) {
      Crashlytics.instance.recordError(e, stack);
      return;
    }

    final existingBoardGameDetails = _boardGames.firstWhere(
        (boardGame) => boardGame.id == boardGameDetails.id,
        orElse: () => null);

    if (existingBoardGameDetails == null) {
      _boardGames.add(boardGameDetails);
    } else {
      existingBoardGameDetails.imageUrl = boardGameDetails.imageUrl;
      existingBoardGameDetails.name = boardGameDetails.name;
      existingBoardGameDetails.rank = boardGameDetails.rank;
      existingBoardGameDetails.rating = boardGameDetails.rating;
      existingBoardGameDetails.votes = boardGameDetails.votes;
      existingBoardGameDetails.yearPublished = boardGameDetails.yearPublished;
      existingBoardGameDetails.categories = boardGameDetails.categories;
      existingBoardGameDetails.description = boardGameDetails.description;
    }

    notifyListeners();
  }

  Future<void> removeBoardGame(String boardGameDetailsId) async {
    try {
      await _boardGamesService.removeBoardGame(boardGameDetailsId);
    } catch (e, stack) {
      Crashlytics.instance.recordError(e, stack);
      return;
    }

    _boardGames.removeWhere((boardGame) => boardGame.id == boardGameDetailsId);

    notifyListeners();
  }

  @override
  void dispose() {
    _boardGamesService.closeBox(HiveBoxes.BoardGames);

    super.dispose();
  }
}
