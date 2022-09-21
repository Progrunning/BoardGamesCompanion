// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';

import '../../models/player_score.dart';

part 'enter_score_view_model.g.dart';

enum EnterScoreOperation {
  add,
  subtract,
}

class EnterScoreViewModel = _EnterScoreViewModel with _$EnterScoreViewModel;

abstract class _EnterScoreViewModel with Store {
  _EnterScoreViewModel(this._playerScore) : _initialScore = _playerScore.score.valueInt;

  final int _initialScore;

  @observable
  PlayerScore _playerScore;

  @observable
  EnterScoreOperation operation = EnterScoreOperation.add;

  @observable
  ObservableList<int> partialScores = <int>[].asObservable();

  @computed
  int get score => _playerScore.score.valueInt;

  @computed
  String? get playerName => _playerScore.player?.name;

  @computed
  bool get canUndo => partialScores.isNotEmpty;

  @computed
  bool get hasUnsavedChanged => partialScores.isNotEmpty;

  @action
  void updateOperation(EnterScoreOperation operation) => this.operation = operation;

  @action
  void updateScore(int partialScore) {
    final newScore = score + partialScore;
    partialScores = ObservableList.of(partialScores..add(partialScore));

    _updatePlayerScore(newScore);
  }

  @action
  void scoreZero() {
    _updatePlayerScore(0);
  }

  @action
  void undo() {
    if (!canUndo) {
      return;
    }

    partialScores = ObservableList.of(partialScores..removeLast());

    final newScore = _initialScore + _partialScoresSum;
    _updatePlayerScore(newScore);
  }

  void _updatePlayerScore(int? score) {
    _playerScore =
        _playerScore.copyWith(score: _playerScore.score.copyWith(value: score.toString()));
  }

  int get _partialScoresSum {
    if (partialScores.isEmpty) {
      return 0;
    }

    return partialScores.reduce((a, b) => a + b);
  }
}
