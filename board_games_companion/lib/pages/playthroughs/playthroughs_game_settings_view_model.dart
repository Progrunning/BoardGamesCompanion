// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/common/enums/game_winning_condition.dart';
import 'package:board_games_companion/models/hive/board_game_settings.dart';
import 'package:board_games_companion/stores/game_playthroughs_details_store.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../stores/board_games_store.dart';

part 'playthroughs_game_settings_view_model.g.dart';

@injectable
class PlaythroughsGameSettingsViewModel = _PlaythroughsGameSettingsViewModel
    with _$PlaythroughsGameSettingsViewModel;

abstract class _PlaythroughsGameSettingsViewModel with Store {
  _PlaythroughsGameSettingsViewModel(this._boardGamesStore, this._gamePlaythroughsStore);

  final BoardGamesStore _boardGamesStore;
  final GamePlaythroughsDetailsStore _gamePlaythroughsStore;

  @computed
  GameWinningCondition get winningCondition => _gamePlaythroughsStore.gameWinningCondition;

  @computed
  int get averageScorePrecision => _gamePlaythroughsStore.averageScorePrecision;

  @action
  Future<void> updateWinningCondition(GameWinningCondition winningCondition) async {
    final boardGame = _boardGamesStore.allBoardGames
        .firstWhere((bg) => bg.id == _gamePlaythroughsStore.boardGameId);

    final updatedBoardGame = boardGame.copyWith(
        settings: (boardGame.settings ?? const BoardGameSettings())
            .copyWith(winningCondition: winningCondition));
    await _boardGamesStore.addOrUpdateBoardGame(updatedBoardGame);
  }

  @action
  Future<void> updateAverageScorePrecision(int averageScorePrecision) async {
    final boardGame = _boardGamesStore.allBoardGames
        .firstWhere((bg) => bg.id == _gamePlaythroughsStore.boardGameId);

    final updatedBoardGame = boardGame.copyWith(
        settings: (boardGame.settings ?? const BoardGameSettings())
            .copyWith(averageScorePrecision: averageScorePrecision));
    await _boardGamesStore.addOrUpdateBoardGame(updatedBoardGame);
  }
}
