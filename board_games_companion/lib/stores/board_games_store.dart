import 'dart:math';

import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/models/player_score.dart';
import 'package:board_games_companion/services/board_games_service.dart';
import 'package:board_games_companion/services/player_service.dart';
import 'package:board_games_companion/services/playthroughs_service.dart';
import 'package:board_games_companion/services/score_service.dart';
import 'package:board_games_companion/extensions/scores_extensions.dart';
import 'package:collection/collection.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class BoardGamesStore with ChangeNotifier {
  final BoardGamesService _boardGamesService;
  final PlaythroughService _playthroughService;
  final ScoreService _scoreService;
  final PlayerService _playerService;

  List<BoardGameDetails> _boardGames;
  LoadDataState _loadDataState = LoadDataState.None;

  BoardGamesStore(this._boardGamesService, this._playthroughService,
      this._scoreService, this._playerService);

  LoadDataState get loadDataState => _loadDataState;
  List<BoardGameDetails> get boardGames => _boardGames;

  Future<void> loadBoardGames() async {
    _loadDataState = LoadDataState.Loading;
    notifyListeners();

    try {
      _boardGames = await _boardGamesService.retrieveBoardGames();
      await loadBoardGamesLatestData();
    } catch (e, stack) {
      Crashlytics.instance.recordError(e, stack);
      _loadDataState = LoadDataState.Error;
    }

    _loadDataState = LoadDataState.Loaded;
    notifyListeners();
  }

  Future<void> addOrUpdateBoardGame(BoardGameDetails boardGameDetails) async {
    try {
      await _boardGamesService.addOrUpdateBoardGame(boardGameDetails);
    } catch (e, stack) {
      Crashlytics.instance.recordError(e, stack);
      return;
    }

    final existingBoardGameDetails = _boardGames.firstWhere(
        (boardGame) => boardGame.id == boardGameDetails.id,
        orElse: () => null);

    if (existingBoardGameDetails == null) {
      _boardGames.add(boardGameDetails);
    } else {
      existingBoardGameDetails.imageUrl = boardGameDetails.imageUrl;
      existingBoardGameDetails.name = boardGameDetails.name;
      existingBoardGameDetails.rank = boardGameDetails.rank;
      existingBoardGameDetails.rating = boardGameDetails.rating;
      existingBoardGameDetails.votes = boardGameDetails.votes;
      existingBoardGameDetails.yearPublished = boardGameDetails.yearPublished;
      existingBoardGameDetails.categories = boardGameDetails.categories;
      existingBoardGameDetails.description = boardGameDetails.description;
    }

    notifyListeners();
  }

  Future<void> removeBoardGame(String boardGameDetailsId) async {
    try {
      await _boardGamesService.removeBoardGame(boardGameDetailsId);
    } catch (e, stack) {
      Crashlytics.instance.recordError(e, stack);
      return;
    }

    _boardGames.removeWhere((boardGame) => boardGame.id == boardGameDetailsId);

    notifyListeners();
  }

  Future<void> loadBoardGamesLatestData() async {
    if (_boardGames?.isEmpty ?? true) {
      return;
    }

    // MK Retrieve players
    final players =
        (await _playerService.retrievePlayers()) ?? Iterable<Player>.empty();
    final Map<String, Player> playersById = Map.fromIterable(players,
        key: (p) => (p as Player).id, value: (p) => p as Player);

    // MK Retrieve playthroughs
    final Map<String, BoardGameDetails> boardGameDetailsMapById =
        Map.fromIterable(_boardGames,
            key: (bg) => (bg as BoardGameDetails).id,
            value: (bg) => bg as BoardGameDetails);
    final boardGamePlaythroughs = (await _playthroughService
            .retrievePlaythroughs(boardGameDetailsMapById.keys)) ??
        Iterable<Playthrough>.empty();

    final Map<String, List<Playthrough>>
        boardGamePlaythroughsGroupedByBoardGameId =
        groupBy(boardGamePlaythroughs, (key) => key.boardGameId);
    for (var boardGameId in boardGameDetailsMapById.keys) {
      final details = boardGameDetailsMapById[boardGameId];

      if (!boardGamePlaythroughsGroupedByBoardGameId.containsKey(boardGameId)) {
        details.lastPlayed = null;
        details.lastWinner = null;
        details.numberOfGamesPlayed = null;
        details.highscore = null;
        details.averagePlaytimeInSeconds = null;
        continue;
      }

      // MK Retrieve scores
      final playthroughIds = boardGamePlaythroughs.map((p) => p.id);
      final playthroughsScores =
          (await _scoreService.retrieveScores(playthroughIds)) ??
              Iterable<Score>.empty();
      final Map<String, List<Score>> playthroughScoresByPlaythroughId =
          groupBy(playthroughsScores, (s) => s.playthroughId);
      final Map<String, List<Score>> playthroughScoresByBoardGameId =
          groupBy(playthroughsScores, (s) => s.boardGameId);

      final playthroughs =
          boardGamePlaythroughsGroupedByBoardGameId[boardGameId];

      final finishedPlaythroughs = playthroughs
          ?.where((p) =>
              p.status == PlaythroughStatus.Finished && p.endDate != null)
          ?.toList();
      finishedPlaythroughs?.sort((a, b) => b.endDate?.compareTo(a.endDate));

      _updateLastPlayedAndWinner(
        finishedPlaythroughs,
        details,
        playthroughScoresByPlaythroughId,
        playersById,
      );

      if (finishedPlaythroughs?.isNotEmpty ?? false) {
        details.numberOfGamesPlayed = finishedPlaythroughs?.length;
        if (playthroughScoresByBoardGameId?.containsKey(details.id) ?? false) {
          final playerScoresWithValue =
              playthroughScoresByBoardGameId[details.id]
                  .onlyScoresWithValue()
                  .map((s) => num.tryParse(s.value));
          if (playerScoresWithValue?.isNotEmpty ?? false) {
            details.highscore = playerScoresWithValue.reduce(max).toString();
          }
        }

        details.averagePlaytimeInSeconds = ((finishedPlaythroughs
                            ?.map((p) => p.endDate.difference(p.startDate))
                            ?.reduce((a, b) => a + b)
                            ?.inSeconds ??
                        0) /
                    finishedPlaythroughs?.length ??
                1)
            .floor();
      }
    }

    notifyListeners();
  }

  void _updateLastPlayedAndWinner(
      List<Playthrough> finishedPlaythroughs,
      BoardGameDetails details,
      Map<String, List<Score>> playthroughScoresByPlaythroughId,
      Map<String, Player> playersById) {
    if (finishedPlaythroughs?.isNotEmpty ?? false) {
      final lastPlaythrough = finishedPlaythroughs.first;
      details.lastPlayed = lastPlaythrough.startDate;

      if (!playthroughScoresByPlaythroughId.containsKey(lastPlaythrough.id)) {
        return;
      }

      final lastPlaythroughScores =
          playthroughScoresByPlaythroughId[lastPlaythrough.id]
              .onlyScoresWithValue();
      lastPlaythroughScores?.sort(
          (a, b) => num.tryParse(b.value).compareTo(num.tryParse(a.value)));
      if (lastPlaythroughScores?.isEmpty ?? true) {
        return;
      }

      final lastPlaythroughBestScore = lastPlaythroughScores.first;
      if (!playersById.containsKey(lastPlaythroughBestScore.playerId)) {
        return;
      }

      details.lastWinner = PlayerScore(
        playersById[lastPlaythroughBestScore.playerId],
        lastPlaythroughBestScore,
        _scoreService,
      );
    }
  }

  @override
  void dispose() {
    _boardGamesService.closeBox(HiveBoxes.BoardGames);
    _playthroughService.closeBox(HiveBoxes.Playthroughs);
    _scoreService.closeBox(HiveBoxes.Scores);
    _playerService.closeBox(HiveBoxes.Players);

    super.dispose();
  }
}
