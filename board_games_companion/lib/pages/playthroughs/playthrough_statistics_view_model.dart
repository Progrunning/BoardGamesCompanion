// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/common/enums/game_winning_condition.dart';
import 'package:board_games_companion/stores/playthroughs_store.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:tuple/tuple.dart';

import '../../common/enums/playthrough_status.dart';
import '../../extensions/scores_extensions.dart';
import '../../models/board_game_statistics.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/hive/player.dart';
import '../../models/hive/playthrough.dart';
import '../../models/hive/score.dart';
import '../../models/player_score.dart';
import '../../models/player_statistics.dart';
import '../../services/player_service.dart';
import '../../services/playthroughs_service.dart';
import '../../services/score_service.dart';

part 'playthrough_statistics_view_model.g.dart';

@singleton
class PlaythroughStatisticsViewModel = _PlaythroughStatisticsViewModel
    with _$PlaythroughStatisticsViewModel;

abstract class _PlaythroughStatisticsViewModel with Store {
  _PlaythroughStatisticsViewModel(
    this._playerService,
    this._scoreService,
    this._playthroughService,
    this._playthroughsStore,
  );

  final PlayerService _playerService;
  final ScoreService _scoreService;
  final PlaythroughService _playthroughService;
  final PlaythroughsStore _playthroughsStore;

  static const int _maxNumberOfTopScoresToDisplay = 5;

  BoardGameStatistics boardGameStatistics = BoardGameStatistics();

  @observable
  ObservableFuture<void>? futureLoadBoardGamesStatistics;

  @computed
  BoardGameDetails get boardGame => _playthroughsStore.boardGame;

  @action
  void loadBoardGamesStatistics() =>
      futureLoadBoardGamesStatistics = ObservableFuture<void>(_loadBoardGamesStatistics());

  Future<void> _loadBoardGamesStatistics() async {
    final boardGameId = _playthroughsStore.boardGame.id;
    final gameWinningCondition = _playthroughsStore.boardGame.settings?.winningCondition ??
        GameWinningCondition.HighestScore;
    final players = await _playerService.retrievePlayers(includeDeleted: true);
    final playersById = <String, Player>{for (Player player in players) player.id: player};

    final boardGamePlaythroughs = await _playthroughService.retrievePlaythroughs([boardGameId]);
    if (boardGamePlaythroughs.isEmpty) {
      boardGameStatistics = BoardGameStatistics();
      return;
    }

    // MK Retrieve scores
    final Iterable<String> playthroughIds = boardGamePlaythroughs.map((p) => p.id);
    final List<Score> playthroughsScores = await _scoreService.retrieveScores(playthroughIds);
    final Map<String, List<Score>> playthroughScoresByPlaythroughId =
        groupBy(playthroughsScores, (s) => s.playthroughId!);
    final Map<String, List<Score>> playthroughScoresByBoardGameId =
        groupBy(playthroughsScores, (s) => s.boardGameId);

    final List<Playthrough> finishedPlaythroughs = boardGamePlaythroughs
        .where((p) => p.status == PlaythroughStatus.Finished && p.endDate != null)
        .toList();
    finishedPlaythroughs.sort((a, b) => b.startDate.compareTo(a.startDate));

    _updateLastPlayedAndWinner(
      finishedPlaythroughs,
      boardGameStatistics,
      playthroughScoresByPlaythroughId,
      playersById,
      gameWinningCondition,
    );

    if (finishedPlaythroughs.isEmpty) {
      return;
    }

    boardGameStatistics.numberOfGamesPlayed = finishedPlaythroughs.length;
    boardGameStatistics.averageNumberOfPlayers = finishedPlaythroughs
            .map((Playthrough playthrough) => playthrough.playerIds.length)
            .reduce((a, b) => a + b) /
        boardGameStatistics.numberOfGamesPlayed!;

    if (!playthroughScoresByBoardGameId.containsKey(boardGameId)) {
      return;
    }

    final List<Score> playerScoresCollection = playthroughScoresByBoardGameId[boardGameId]
        .onlyScoresWithValue()
      ..sortByScore(gameWinningCondition);
    if (playerScoresCollection.isNotEmpty) {
      final Map<String, List<Score>> playerScoresGrouped =
          groupBy(playerScoresCollection, (Score score) => score.playerId);
      boardGameStatistics.bestScore = playerScoresCollection.toBestScore(gameWinningCondition);
      boardGameStatistics.averageScore = playerScoresCollection.toAverageScore();

      boardGameStatistics.topScoreres = [];
      boardGameStatistics.playersStatistics = [];
      for (final Score score in playerScoresCollection) {
        final Player player = playersById[score.playerId]!;
        if (boardGameStatistics.topScoreres!.length < _maxNumberOfTopScoresToDisplay) {
          boardGameStatistics.topScoreres!.add(Tuple2<Player, String>(player, score.value!));
        }

        if (boardGameStatistics.playersStatistics!
            .any((PlayerStatistics playerStats) => playerStats.player == player)) {
          continue;
        }

        final PlayerStatistics playerStatistics = PlayerStatistics(player);
        playerStatistics.personalBestScore = num.tryParse(score.value!);
        playerStatistics.numberOfGamesPlayed = playerScoresGrouped[player.id]?.length ?? 0;
        playerStatistics.averageScore = playerScoresGrouped[player.id]!.toAverageScore();
        boardGameStatistics.playersStatistics!.add(playerStatistics);
      }
    }

    _updatePlayerCountPercentage(finishedPlaythroughs, boardGameStatistics);
    _updatePlayerWinsPercentage(
      finishedPlaythroughs,
      boardGameStatistics,
      playthroughScoresByPlaythroughId,
      playersById,
      gameWinningCondition,
    );

    boardGameStatistics.totalPlaytimeInSeconds = finishedPlaythroughs
        .map((Playthrough p) => p.endDate!.difference(p.startDate).inSeconds)
        .reduce((a, b) => a + b);
  }

  void _updateLastPlayedAndWinner(
    List<Playthrough>? finishedPlaythroughs,
    BoardGameStatistics boardGameStatistics,
    Map<String, List<Score>> playthroughScoresByPlaythroughId,
    Map<String, Player> playersById,
    GameWinningCondition winningCondition,
  ) {
    if (finishedPlaythroughs?.isEmpty ?? true) {
      return;
    }

    final lastPlaythrough = finishedPlaythroughs!.first;
    boardGameStatistics.lastPlayed = lastPlaythrough.startDate;

    if (!playthroughScoresByPlaythroughId.containsKey(lastPlaythrough.id)) {
      return;
    }

    final lastPlaythroughScores = playthroughScoresByPlaythroughId[lastPlaythrough.id]
        .onlyScoresWithValue()
      ..sortByScore(winningCondition);

    if (lastPlaythroughScores.isEmpty) {
      boardGameStatistics.lastWinner = null;
      return;
    }

    final lastPlaythroughBestScore = lastPlaythroughScores.first;
    if (!playersById.containsKey(lastPlaythroughBestScore.playerId)) {
      return;
    }

    boardGameStatistics.lastWinner = PlayerScore(
      player: playersById[lastPlaythroughBestScore.playerId],
      score: lastPlaythroughBestScore,
    );
  }

  void _updatePlayerCountPercentage(
    List<Playthrough> finishedPlaythroughs,
    BoardGameStatistics boardGameStatistics,
  ) {
    boardGameStatistics.playerCountPercentage = groupBy(
            finishedPlaythroughs
                .map((Playthrough playthrough) => playthrough.playerIds.length)
                .toList()
              ..sort((int numberOfPlayers, int otherNumberOfPlayers) =>
                  numberOfPlayers.compareTo(otherNumberOfPlayers)),
            (int numberOfPlayers) => numberOfPlayers)
        .map((key, value) => MapEntry(key, value.length / finishedPlaythroughs.length));
  }

  void _updatePlayerWinsPercentage(
    List<Playthrough> finishedPlaythroughs,
    BoardGameStatistics boardGameStatistics,
    Map<String, List<Score>> playthroughScoresByPlaythroughId,
    Map<String, Player> playersById,
    GameWinningCondition gameWinningCondition,
  ) {
    final Map<Player, int> playerWins = {};
    for (final Playthrough finishedPlaythrough in finishedPlaythroughs) {
      final List<Score> playthroughScores = playthroughScoresByPlaythroughId[finishedPlaythrough.id]
          .sortByScore(gameWinningCondition)!;
      if (playthroughScores.isEmpty) {
        continue;
      }

      final Player? winner = playersById[playthroughScores.first.playerId];
      if (winner == null) {
        continue;
      }

      if (!playerWins.containsKey(winner)) {
        playerWins[winner] = 1;
      } else {
        playerWins[winner] = playerWins[winner]! + 1;
      }
    }

    boardGameStatistics.playerWinsPercentage = {};
    for (final MapEntry<Player, int> playerWin in playerWins.entries) {
      boardGameStatistics.playerWinsPercentage![playerWin.key] =
          playerWin.value / finishedPlaythroughs.length;
    }
  }
}
