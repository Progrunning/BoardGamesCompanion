import 'dart:math';

import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/services/player_service.dart';
import 'package:board_games_companion/services/score_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';

class PlaythroughStore with ChangeNotifier {
  static const String unknownHighscoreValue = '-';

  final PlayerService _playerService;
  final ScoreService _scoreService;

  LoadDataState _loadDataState;
  LoadDataState get loadDataState => _loadDataState;

  Playthrough _playthrough;
  Playthrough get playthrough => _playthrough;

  int _daysSinceStart;
  int get daysSinceStart => _daysSinceStart;

  int _durationInSeconds;
  int get durationInSeconds => _durationInSeconds;

  List<Score> _scores;
  List<Score> get scores => _scores;

  String _highScore = unknownHighscoreValue;
  String get highScore => _highScore;

  List<Player> _players;
  List<Player> get players => _players;

  PlaythroughStore(this._playerService, this._scoreService);

  Future<void> loadPlaythrough(Playthrough playthrough) async {
    _loadDataState = LoadDataState.Loading;

    if (playthrough?.id?.isEmpty ?? true) {
      _loadDataState = LoadDataState.Error;
      return;
    }

    final nowUtc = DateTime.now().toUtc();
    _playthrough = playthrough;
    _daysSinceStart = nowUtc.difference(_playthrough.startDate).inDays;
    final playthroughEndDate = _playthrough.endDate ?? nowUtc;
    _durationInSeconds =
        playthroughEndDate.difference(_playthrough.startDate).inSeconds;

    try {
      _scores = await _scoreService.retrieveScores(_playthrough.id);
      if (_scores?.isNotEmpty ?? false) {
        _highScore = _scores
                ?.where((s) =>
                    (s?.value?.isNotEmpty ?? false) &&
                    num.tryParse(s.value) != null)
                ?.map((s) => num.tryParse(s.value))
                ?.reduce(max)
                ?.toString() ??
            unknownHighscoreValue;
      }

      _players = await _playerService.retrievePlayers(_playthrough.playerIds);

      _loadDataState = LoadDataState.Loaded;
    } catch (e, stack) {
      _loadDataState = LoadDataState.Error;
      Crashlytics.instance.recordError(e, stack);
    }

    notifyListeners();
  }
}
