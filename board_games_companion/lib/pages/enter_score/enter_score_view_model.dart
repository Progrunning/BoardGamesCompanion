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

  static const int maxKeypadDigits = 6;

  final double _initialScore;

  @observable
  PlayerScore _playerScore;

  @observable
  EnterScoreOperation operation = EnterScoreOperation.add;

  @observable
  ObservableList<double> partialScores = <double>[].asObservable();

  @observable
  bool isKeypadOpen = false;

  @observable
  String keypadDigits = '';

  @computed
  double get score => _playerScore.score.score ?? 0;

  @computed
  String? get playerName => _playerScore.player?.name;

  @computed
  bool get canUndo => partialScores.isNotEmpty;

  @computed
  bool get hasUnsavedChanged => partialScores.isNotEmpty;

  @computed
  bool get canCommitKeypad => keypadDigits.isNotEmpty && keypadDigits != '0';

  @action
  void updateOperation(EnterScoreOperation operation) => this.operation = operation;

  @action
  void updateScore(double partialScore) {
    final newScore = score + partialScore;
    partialScores = ObservableList.of(partialScores..add(partialScore));

    _updatePlayerScore(newScore);
  }

  /// Adds or subtracts [value] depending on the selected [operation].
  @action
  void addInstantScore(double value) =>
      updateScore(operation == EnterScoreOperation.subtract ? -value : value);

  @action
  void scoreZero() => _updatePlayerScore(0);

  @action
  void done() {
    keypadCancel();

    // MK In case score was not entered assume 0 was the score
    if (score == 0) {
      scoreZero();
    }
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

  @action
  void openKeypad() {
    if (isKeypadOpen) {
      return;
    }
    keypadDigits = '';
    isKeypadOpen = true;
  }

  @action
  void keypadAppendDigit(String digit) {
    if (keypadDigits.length >= maxKeypadDigits) {
      return;
    }
    if (keypadDigits == '0') {
      keypadDigits = digit;
      return;
    }
    keypadDigits = keypadDigits + digit;
  }

  @action
  void keypadBackspace() {
    if (keypadDigits.isEmpty) {
      return;
    }
    keypadDigits = keypadDigits.substring(0, keypadDigits.length - 1);
  }

  @action
  void keypadCancel() {
    keypadDigits = '';
    isKeypadOpen = false;
  }

  @action
  void keypadCommit() {
    if (!canCommitKeypad) {
      return;
    }

    addInstantScore(double.parse(keypadDigits));

    keypadDigits = '';
    isKeypadOpen = false;
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
