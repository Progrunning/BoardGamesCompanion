import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import '../common/enums/playthrough_status.dart';
import '../extensions/scores_extensions.dart';
import '../models/board_game_statistics.dart';
import '../models/hive/board_game_details.dart';
import '../models/hive/player.dart';
import '../models/hive/playthrough.dart';
import '../models/hive/score.dart';
import '../models/player_score.dart';
import '../services/player_service.dart';
import '../services/playthroughs_service.dart';
import '../services/score_service.dart';

class PlaythroughStatisticsStore extends ChangeNotifier {
  PlaythroughStatisticsStore(
    this._playerService,
    this._scoreService,
    this._playthroughService,
  );

  final PlayerService _playerService;
  final ScoreService _scoreService;
  final PlaythroughService _playthroughService;

  final Map<String, BoardGameStatistics> _boardGamesStatistics = {};
  Map<String, BoardGameStatistics> get boardGamesStatistics => _boardGamesStatistics;

  Future<void> loadBoardGamesStatistics(List<BoardGameDetails>? allBoardGames) async {
    if (allBoardGames?.isEmpty ?? true) {
      return;
    }

    final players = await _playerService.retrievePlayers(includeDeleted: true);
    final playersById = <String, Player>{for (Player player in players) player.id: player};

    final boardGameDetailsMapById = <String, BoardGameDetails>{
      for (BoardGameDetails boardGameDetails in allBoardGames!)
        boardGameDetails.id: boardGameDetails
    };

    final boardGamePlaythroughs =
        await _playthroughService.retrievePlaythroughs(boardGameDetailsMapById.keys.toList());

    final Map<String, List<Playthrough>> boardGamePlaythroughsGroupedByBoardGameId =
        groupBy(boardGamePlaythroughs, (key) => key.boardGameId);
    for (final boardGameId in boardGameDetailsMapById.keys) {
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
      final playthroughsScores = await _scoreService.retrieveScores(playthroughIds);
      final Map<String, List<Score>> playthroughScoresByPlaythroughId =
          groupBy(playthroughsScores, (s) => s.playthroughId!);
      final Map<String, List<Score>> playthroughScoresByBoardGameId =
          groupBy(playthroughsScores, (s) => s.boardGameId);

      final playthroughs = boardGamePlaythroughsGroupedByBoardGameId[boardGameId];

      final finishedPlaythroughs = playthroughs
          ?.where((p) => p.status == PlaythroughStatus.Finished && p.endDate != null)
          .toList();
      finishedPlaythroughs?.sort((a, b) => b.startDate.compareTo(a.startDate));

      _updateLastPlayedAndWinner(
        finishedPlaythroughs,
        boardGameStatistics,
        playthroughScoresByPlaythroughId,
        playersById,
      );

      if (finishedPlaythroughs?.isNotEmpty ?? false) {
        boardGameStatistics.numberOfGamesPlayed = finishedPlaythroughs?.length;
        if (playthroughScoresByBoardGameId.containsKey(boardGameId)) {
          final playerScoresWithValue = playthroughScoresByBoardGameId[boardGameId]
              .onlyScoresWithValue()
              .map((s) => num.tryParse(s.value!)!);
          if (playerScoresWithValue.isNotEmpty) {
            boardGameStatistics.highscore = playerScoresWithValue.reduce(max).toString();
          }
        }

        final int? allPlaythroughsDurationSumInSeconds = finishedPlaythroughs
            ?.map((p) => p.endDate!.difference(p.startDate).inSeconds)
            .reduce((a, b) => a + b);
        if (allPlaythroughsDurationSumInSeconds != null) {
          boardGameStatistics.averagePlaytimeInSeconds =
              (allPlaythroughsDurationSumInSeconds / finishedPlaythroughs!.length).floor();
        }
      }
    }

    notifyListeners();
  }

  void _updateLastPlayedAndWinner(
      List<Playthrough>? finishedPlaythroughs,
      BoardGameStatistics boardGameStatistics,
      Map<String, List<Score>> playthroughScoresByPlaythroughId,
      Map<String, Player> playersById) {
    if (finishedPlaythroughs?.isNotEmpty ?? false) {
      final lastPlaythrough = finishedPlaythroughs!.first;
      boardGameStatistics.lastPlayed = lastPlaythrough.startDate;

      if (!playthroughScoresByPlaythroughId.containsKey(lastPlaythrough.id)) {
        return;
      }

      final lastPlaythroughScores =
          playthroughScoresByPlaythroughId[lastPlaythrough.id].onlyScoresWithValue();
      lastPlaythroughScores
          .sort((a, b) => num.tryParse(b.value!)!.compareTo(num.tryParse(a.value!)!));
      if (lastPlaythroughScores.isEmpty) {
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
      );
    }
  }
}
