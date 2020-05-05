import 'dart:math';

import 'package:board_games_companion/common/enums/playthrough_status.dart';
import 'package:board_games_companion/models/board_game_statistics.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/extensions/scores_extensions.dart';
import 'package:board_games_companion/models/player_score.dart';
import 'package:board_games_companion/services/player_service.dart';
import 'package:board_games_companion/services/playthroughs_service.dart';
import 'package:board_games_companion/services/score_service.dart';
import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

class PlaythroughStatisticsStore extends ChangeNotifier {
  final PlayerService _playerService;
  final ScoreService _scoreService;
  final PlaythroughService _playthroughService;

  Map<String, BoardGameStatistics> _boardGamesStatistics =
      Map<String, BoardGameStatistics>();
  Map<String, BoardGameStatistics> get boardGamesStatistics =>
      _boardGamesStatistics;

  PlaythroughStatisticsStore(
    this._playerService,
    this._scoreService,
    this._playthroughService,
  );

  Future<void> loadBoardGamesStatistics(
    List<BoardGameDetails> allBoardGames,
  ) async {
    if (allBoardGames?.isEmpty ?? true) {
      return;
    }

    // MK Retrieve players
    final players =
        (await _playerService.retrievePlayers()) ?? Iterable<Player>.empty();
    final Map<String, Player> playersById = Map.fromIterable(players,
        key: (p) => (p as Player).id, value: (p) => p as Player);

    // MK Retrieve playthroughs
    final Map<String, BoardGameDetails> boardGameDetailsMapById =
        Map.fromIterable(allBoardGames,
            key: (bg) => (bg as BoardGameDetails).id,
            value: (bg) => bg as BoardGameDetails);
    final boardGamePlaythroughs = (await _playthroughService
            .retrievePlaythroughs(boardGameDetailsMapById.keys)) ??
        Iterable<Playthrough>.empty();

    final Map<String, List<Playthrough>>
        boardGamePlaythroughsGroupedByBoardGameId =
        groupBy(boardGamePlaythroughs, (key) => key.boardGameId);
    for (var boardGameId in boardGameDetailsMapById.keys) {
      var boardGameStatistics = _boardGamesStatistics[boardGameId];
      if (boardGameStatistics == null) {
        boardGameStatistics = _boardGamesStatistics[boardGameId] = BoardGameStatistics();
      }

      if (!boardGamePlaythroughsGroupedByBoardGameId.containsKey(boardGameId)) {
        boardGameStatistics.lastPlayed = null;
        boardGameStatistics.lastWinner = null;
        boardGameStatistics.numberOfGamesPlayed = null;
        boardGameStatistics.highscore = null;
        boardGameStatistics.averagePlaytimeInSeconds = null;
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
        boardGameStatistics,
        playthroughScoresByPlaythroughId,
        playersById,
      );

      if (finishedPlaythroughs?.isNotEmpty ?? false) {
        boardGameStatistics.numberOfGamesPlayed = finishedPlaythroughs?.length;
        if (playthroughScoresByBoardGameId?.containsKey(boardGameId) ?? false) {
          final playerScoresWithValue =
              playthroughScoresByBoardGameId[boardGameId]
                  .onlyScoresWithValue()
                  .map((s) => num.tryParse(s.value));
          if (playerScoresWithValue?.isNotEmpty ?? false) {
            boardGameStatistics.highscore =
                playerScoresWithValue.reduce(max).toString();
          }
        }

        boardGameStatistics.averagePlaytimeInSeconds = ((finishedPlaythroughs
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
      BoardGameStatistics boardGameStatistics,
      Map<String, List<Score>> playthroughScoresByPlaythroughId,
      Map<String, Player> playersById) {
    if (finishedPlaythroughs?.isNotEmpty ?? false) {
      final lastPlaythrough = finishedPlaythroughs.first;
      boardGameStatistics.lastPlayed = lastPlaythrough.startDate;

      if (!playthroughScoresByPlaythroughId.containsKey(lastPlaythrough.id)) {
        return;
      }

      final lastPlaythroughScores =
          playthroughScoresByPlaythroughId[lastPlaythrough.id]
              .onlyScoresWithValue();
      lastPlaythroughScores?.sort(
          (a, b) => num.tryParse(b.value).compareTo(num.tryParse(a.value)));
      if (lastPlaythroughScores?.isEmpty ?? true) {
        if (boardGameStatistics.lastWinner != null) {
          boardGameStatistics.lastWinner = null;
        }
        return;
      }

      final lastPlaythroughBestScore = lastPlaythroughScores.first;
      if (!playersById.containsKey(lastPlaythroughBestScore.playerId)) {
        return;
      }

      boardGameStatistics.lastWinner = PlayerScore(
        playersById[lastPlaythroughBestScore.playerId],
        lastPlaythroughBestScore,
        _scoreService,
      );
    }
  }
}