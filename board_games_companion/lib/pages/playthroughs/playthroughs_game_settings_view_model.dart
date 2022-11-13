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

  GameWinningCondition get winningCondition =>
      _playthroughsStore.boardGame.settings?.winningCondition ?? GameWinningCondition.HighestScore;

  Future<void> updateWinningCondition(GameWinningCondition winningCondition) async {
    if (_playthroughsStore.boardGame == null) {
      return;
    }

    final boardGameSettings = _playthroughsStore.boardGame.settings ?? BoardGameSettings();
    boardGameSettings.winningCondition = winningCondition;

    // TODO Test if this updates setting correctly
    await _boardGamesStore
        .addOrUpdateBoardGame(_playthroughsStore.boardGame.copyWith(settings: boardGameSettings));
  }
}
