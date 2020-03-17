import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/board_game_details.dart';
import 'package:hive/hive.dart';

class BoardGamesService {
  static final BoardGamesService _instance =
      new BoardGamesService._createInstance();

  factory BoardGamesService() {
    return _instance;
  }

  BoardGamesService._createInstance();

  Future<List<BoardGameDetails>> retrieveBoardGames() async {
    var boardGamesBox =
        await Hive.openBox<BoardGameDetails>(HiveBoxes.BoardGames);

    return boardGamesBox.toMap()?.values?.toList();
  }

  Future<void> addOrUpdateBoardGame(BoardGameDetails boardGameDetails) async {
    if (boardGameDetails?.id?.isEmpty ?? true) {
      return;
    }

    var boardGamesBox =
        await Hive.openBox<BoardGameDetails>(HiveBoxes.BoardGames);
    await boardGamesBox.put(boardGameDetails.id, boardGameDetails);
  }

  void closeBox(String boxName) {
    if (boxName?.isEmpty ?? true) {
      return;
    }

    Hive.box(boxName).close();
  }
}
