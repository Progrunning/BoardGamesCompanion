import 'package:board_games_companion/common/enums/game_winning_condition.dart';
import 'package:board_games_companion/models/hive/board_game_settings.dart';
import 'package:board_games_companion/stores/game_playthroughs_details_store.dart';
import 'package:injectable/injectable.dart';

import '../../stores/board_games_store.dart';

@injectable
class PlaythroughsGameSettingsViewModel {
  PlaythroughsGameSettingsViewModel(this._boardGamesStore, this._gamePlaythroughsStore);

  final BoardGamesStore _boardGamesStore;
  final GamePlaythroughsDetailsStore _gamePlaythroughsStore;

  GameWinningCondition get winningCondition => _gamePlaythroughsStore.gameWinningCondition;

  Future<void> updateWinningCondition(GameWinningCondition winningCondition) async {
    final boardGame = _boardGamesStore.allBoardGames
        .firstWhere((bg) => bg.id == _gamePlaythroughsStore.boardGameId);

    final updatedBoardGame = boardGame.copyWith(
        settings: (boardGame.settings ?? const BoardGameSettings())
            .copyWith(winningCondition: winningCondition));
    await _boardGamesStore.addOrUpdateBoardGame(updatedBoardGame);
    _gamePlaythroughsStore.setBoardGame(updatedBoardGame);
  }
}
