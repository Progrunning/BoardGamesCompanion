// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/models/hive/score_game_results.dart';
import 'package:mobx/mobx.dart';

import '../../models/player_score.dart';

part 'enter_score_view_model.g.dart';

enum EnterScoreOperation {
  add,
  subtract,
}

class EnterScoreViewModel = _EnterScoreViewModel with _$EnterScoreViewModel;

abstract class _EnterScoreViewModel with Store {
  _EnterScoreViewModel(this._playerScore) : _initialScore = _playerScore.score.score ?? 0;

  final double _initialScore;

  @observable
  PlayerScore _playerScore;

  @observable
  EnterScoreOperation operation = EnterScoreOperation.add;

  @observable
  ObservableList<double> partialScores = <double>[].asObservable();

  @computed
  double get score => _playerScore.score.score ?? 0;

  @computed
  String? get playerName => _playerScore.player?.name;

  @computed
  bool get canUndo => partialScores.isNotEmpty;

  @computed
  bool get hasUnsavedChanged => partialScores.isNotEmpty;

  @action
  void updateOperation(EnterScoreOperation operation) => this.operation = operation;

  @action
  void updateScore(double partialScore) {
    final newScore = score + partialScore;
    partialScores = ObservableList.of(partialScores..add(partialScore));

    _updatePlayerScore(newScore);
  }

  @action
  void scoreZero() => _updatePlayerScore(0);

  @action
  void undo() {
    if (!canUndo) {
      return;
    }

    partialScores = ObservableList.of(partialScores..removeLast());

    final newScore = _initialScore + _partialScoresSum;
    _updatePlayerScore(newScore);
  }

  void _updatePlayerScore(double? score) {
    final scoreGameResult = _playerScore.score.scoreGameResult ?? const ScoreGameResult();
    _playerScore = _playerScore.copyWith(
      score: _playerScore.score.copyWith(
        scoreGameResult: scoreGameResult.copyWith(points: score),
      ),
    );
  }

  double get _partialScoresSum {
    if (partialScores.isEmpty) {
      return 0;
    }

    return partialScores.reduce((a, b) => a + b);
  }
}
