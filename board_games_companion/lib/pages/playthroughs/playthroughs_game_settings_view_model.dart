// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/common/enums/game_mode.dart';
import 'package:board_games_companion/common/enums/game_win_condition.dart';
import 'package:board_games_companion/models/board_game_settings/board_game_mode_settings.dart';
import 'package:board_games_companion/models/hive/board_game_settings.dart';
import 'package:board_games_companion/pages/playthroughs/average_score_precision.dart';
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
  AverageScorePrecision get _averageScorePrecision {
    if (_gamePlaythroughsStore.averageScorePrecision == 0) {
      return const AverageScorePrecision.none();
    }
    return AverageScorePrecision.value(precision: _gamePlaythroughsStore.averageScorePrecision);
  }

  @computed
  BoardGameModeSettings get gameModeSettings {
    switch (_gamePlaythroughsStore.gameMode) {
      case GameMode.Score:
        return BoardGameModeSettings.score(
          gameWinCondition: _gamePlaythroughsStore.gameWinCondition,
          averageScorePrecision: _averageScorePrecision,
        );
      case GameMode.NoScore:
        return BoardGameModeSettings.noScore(
          gameWinCondition: _gamePlaythroughsStore.gameWinCondition,
        );
    }
  }

  @computed
  GameMode get gameMode => _gamePlaythroughsStore.gameMode;

  @action
  Future<void> updateWinCondition(GameWinCondition winCondition) async {
    final boardGame = _boardGamesStore.allBoardGames
        .firstWhere((bg) => bg.id == _gamePlaythroughsStore.boardGameId);

    final updatedBoardGame = boardGame.copyWith(
        settings:
            (boardGame.settings ?? const BoardGameSettings()).copyWith(winCondition: winCondition));
    await _boardGamesStore.addOrUpdateBoardGame(updatedBoardGame);
  }

  @action
  Future<void> updateGameMode(GameMode gameMode) async {
    final boardGame = _boardGamesStore.allBoardGames
        .firstWhere((bg) => bg.id == _gamePlaythroughsStore.boardGameId);

    final updatedBoardGame = boardGame.copyWith(
        settings: (boardGame.settings ?? const BoardGameSettings()).copyWith(
      gameMode: gameMode,
      winCondition: gameMode.toDefaultWinCondition(),
    ));
    await _boardGamesStore.addOrUpdateBoardGame(updatedBoardGame);
  }

  @action
  Future<void> updateAverageScorePrecision(AverageScorePrecision averageScorePrecision) async {
    final boardGame = _boardGamesStore.allBoardGames
        .firstWhere((bg) => bg.id == _gamePlaythroughsStore.boardGameId);

    final updatedBoardGame = boardGame.copyWith(
      settings: (boardGame.settings ?? const BoardGameSettings()).copyWith(
        averageScorePrecision: averageScorePrecision.when(
          none: () => 0,
          value: (precision) => precision,
        ),
      ),
    );
    await _boardGamesStore.addOrUpdateBoardGame(updatedBoardGame);
  }
}
