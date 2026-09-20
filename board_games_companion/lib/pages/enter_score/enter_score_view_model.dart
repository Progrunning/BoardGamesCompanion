// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/models/hive/score_game_results.dart';
import 'package:mobx/mobx.dart';

import '../../models/player_score.dart';

part 'enter_score_view_model.g.dart';

class EnterScoreViewModel = _EnterScoreViewModel with _$EnterScoreViewModel;

abstract class _EnterScoreViewModel with Store {
  _EnterScoreViewModel(this._playerScore) : _initialScore = _playerScore.score.score ?? 0;

  /// A layout guard against a stuck key rather than a validation rule - it bounds a single
  /// score entry, not the total, which stays unbounded and may go negative.
  static const int maxScoreEntryDigits = 6;

  final double _initialScore;

  @observable
  PlayerScore _playerScore;

  @observable
  ObservableList<double> partialScores = <double>[].asObservable();

  @observable
  String scoreEntry = '';

  @computed
  double get score => _playerScore.score.score ?? 0;

  @computed
  String? get playerName => _playerScore.player?.name;

  @computed
  bool get canUndo => partialScores.isNotEmpty;

  @computed
  bool get canCommitScoreEntry => _scoreEntryValue != 0;

  @action
  void updateScore(double partialScore) {
    final newScore = score + partialScore;
    partialScores = ObservableList.of(partialScores..add(partialScore));

    _updatePlayerScore(newScore);
  }

  @action
  void addInstantScore(double value) => updateScore(value);

  @action
  void appendDigit(String digit) {
    if (scoreEntry.length >= maxScoreEntryDigits) {
      return;
    }

    scoreEntry = scoreEntry == '0' ? digit : scoreEntry + digit;
  }

  @action
  void backspace() {
    if (scoreEntry.isEmpty) {
      return;
    }

    scoreEntry = scoreEntry.substring(0, scoreEntry.length - 1);
  }

  @action
  void commitAdd() => _commitScoreEntry(1);

  @action
  void commitSubtract() => _commitScoreEntry(-1);

  @action
  void undo() {
    if (!canUndo) {
      return;
    }

    partialScores = ObservableList.of(partialScores..removeLast());

    _updatePlayerScore(_initialScore + _partialScoresSum);
  }

  /// Commits whatever is pending and settles the score, whether the sheet was dismissed with
  /// Done or swiped away. Both call sites read [score] once the sheet closes, so skipping this
  /// on either route would lose the entry or leave the score unset.
  @action
  void close() {
    commitAdd();

    // MK In case score was not entered assume 0 was the score
    if (score == 0) {
      _updatePlayerScore(0);
    }
  }

  void _commitScoreEntry(int sign) {
    if (!canCommitScoreEntry) {
      scoreEntry = '';
      return;
    }

    updateScore(sign * _scoreEntryValue);
    scoreEntry = '';
  }

  double get _scoreEntryValue => scoreEntry.isEmpty ? 0 : double.parse(scoreEntry);

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
