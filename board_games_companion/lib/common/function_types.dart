import '../models/hive/board_game_details.dart';
import '../pages/collections/collections_page.dart';

typedef SearchCallback = Future<List<BoardGameDetails>> Function(String query);

typedef BoardGameResultAction = void Function(
  BoardGameDetails boardGame,
  BoardGameResultActionType actionType,
);
