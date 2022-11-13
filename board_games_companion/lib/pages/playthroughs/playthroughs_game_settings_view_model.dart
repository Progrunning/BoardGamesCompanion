import 'package:board_games_companion/common/enums/game_winning_condition.dart';
import 'package:board_games_companion/models/hive/board_game_settings.dart';
import 'package:board_games_companion/stores/playthroughs_store.dart';
import 'package:injectable/injectable.dart';

import '../../stores/board_games_store.dart';

@injectable
class PlaythroughsGameSettingsViewModel {
  PlaythroughsGameSettingsViewModel(this._boardGamesStore, this._playthroughsStore);

  final BoardGamesStore _boardGamesStore;
  final PlaythroughsStore _playthroughsStore;

  GameWinningCondition get winningCondition => _playthroughsStore.gameWinningCondition;

  Future<void> updateWinningCondition(GameWinningCondition winningCondition) async {
    final boardGame =
        _boardGamesStore.allBoardGames.firstWhere((bg) => bg.id == _playthroughsStore.boardGameId);

    final updatedBoardGame = boardGame.copyWith(
        settings: (boardGame.settings ?? const BoardGameSettings())
            .copyWith(winningCondition: winningCondition));
    await _boardGamesStore.addOrUpdateBoardGame(updatedBoardGame);
    _playthroughsStore.setBoardGame(updatedBoardGame);
  }
}
