import 'package:board_games_companion/common/enums/game_family.dart';

class BggImportPlays {
  BggImportPlays(this.username, this.boardGameId, this.gameFamily, {this.pageNumber = 1});

  late String username;
  late String boardGameId;
  late GameFamily gameFamily;
  late int pageNumber;
}
