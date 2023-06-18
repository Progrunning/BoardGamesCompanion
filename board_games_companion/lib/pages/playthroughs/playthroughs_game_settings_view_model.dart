// ignore_for_file: library_private_types_in_public_api

import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../common/enums/game_classification.dart';
import '../../common/enums/game_family.dart';
import '../../models/board_game_settings/board_game_mode_classification.dart';
import '../../models/hive/board_game_settings.dart';
import '../../stores/board_games_store.dart';
import '../../stores/game_playthroughs_details_store.dart';
import 'average_score_precision.dart';

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
    return AverageScorePrecision.precision(value: _gamePlaythroughsStore.averageScorePrecision);
  }

  @computed
  BoardGameClassificationSettings get gameClassificationSettings {
    switch (_gamePlaythroughsStore.gameClassification) {
      case GameClassification.Score:
        return BoardGameClassificationSettings.score(
          gameFamily: _gamePlaythroughsStore.gameGameFamily,
          averageScorePrecision: _averageScorePrecision,
        );
      case GameClassification.NoScore:
        return BoardGameClassificationSettings.noScore(
          gameFamily: _gamePlaythroughsStore.gameGameFamily,
        );
    }
  }

  @computed
  GameClassification get gameClassification => _gamePlaythroughsStore.gameClassification;

  @action
  Future<void> updateGameFamily(GameFamily gameFamily) async {
    final boardGame = _boardGamesStore.allBoardGames
        .firstWhere((bg) => bg.id == _gamePlaythroughsStore.boardGameId);

    final updatedBoardGame = boardGame.copyWith(
        settings:
            (boardGame.settings ?? const BoardGameSettings()).copyWith(gameFamily: gameFamily));
    await _boardGamesStore.addOrUpdateBoardGame(updatedBoardGame);
  }

  @action
  Future<void> updateGameClassification(GameClassification gameClassification) async {
    final boardGame = _boardGamesStore.allBoardGames
        .firstWhere((bg) => bg.id == _gamePlaythroughsStore.boardGameId);

    final updatedBoardGame = boardGame.copyWith(
        settings: (boardGame.settings ?? const BoardGameSettings()).copyWith(
      gameClassification: gameClassification,
      gameFamily: gameClassification.toDefaultGameFamily(),
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
          precision: (value) => value,
        ),
      ),
    );
    await _boardGamesStore.addOrUpdateBoardGame(updatedBoardGame);
  }
}
