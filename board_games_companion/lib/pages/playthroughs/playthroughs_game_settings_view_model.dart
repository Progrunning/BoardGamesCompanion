import 'package:board_games_companion/common/enums/game_winning_condition.dart';
import 'package:board_games_companion/models/hive/board_game_settings.dart';

import '../../mixins/board_game_aware_mixin.dart';
import '../../stores/board_games_store.dart';

class PlaythroughsGameSettingsViewModel with BoardGameAware {
  PlaythroughsGameSettingsViewModel(this._boardGamesStore);

  final BoardGamesStore _boardGamesStore;

  GameWinningCondition get winningCondition =>
      boardGame?.settings?.winningCondition ?? GameWinningCondition.HighestScore;

  Future<void> updateWinningCondition(GameWinningCondition winningCondition) async {
    if (boardGame == null) {
      return;
    }

    final boardGameSettings = boardGame!.settings ?? BoardGameSettings();
    boardGameSettings.winningCondition = winningCondition;

    boardGame!.settings = boardGameSettings;
    await _boardGamesStore.updateDetails(boardGame!);
  }
}
