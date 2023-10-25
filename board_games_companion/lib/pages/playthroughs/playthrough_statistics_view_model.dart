// ignore_for_file: library_private_types_in_public_api

import 'package:collection/collection.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:tuple/tuple.dart';

import '../../common/enums/game_classification.dart';
import '../../common/enums/game_family.dart';
import '../../extensions/playthroughs_extensions.dart';
import '../../models/board_game_statistics.dart';
import '../../models/hive/no_score_game_result.dart';
import '../../models/hive/player.dart';
import '../../models/hive/playthrough.dart';
import '../../models/hive/score.dart';
import '../../models/player_score.dart';
import '../../models/player_statistics.dart';
import '../../services/player_service.dart';
import '../../stores/game_playthroughs_details_store.dart';
import '../../stores/scores_store.dart';

part 'playthrough_statistics_view_model.g.dart';

@singleton
class PlaythroughStatisticsViewModel = _PlaythroughStatisticsViewModel
    with _$PlaythroughStatisticsViewModel;

abstract class _PlaythroughStatisticsViewModel with Store {
  _PlaythroughStatisticsViewModel(
    this._playerService,
    this._scoresStore,
    this._gamePlaythroughsStore,
  );

  final PlayerService _playerService;
  final ScoresStore _scoresStore;
  final GamePlaythroughsDetailsStore _gamePlaythroughsStore;

  static const int _maxNumberOfTopScoresToDisplay = 5;

  @observable
  BoardGameStatistics boardGameStatistics = const BoardGameStatistics.none();

  @observable
  ObservableFuture<void>? futureLoadBoardGamesStatistics;

  @computed
  List<String> get _playthroughIds =>
      _gamePlaythroughsStore.playthroughs.map((playthrough) => playthrough.id).toList();

  @computed
  List<Score> get _playthroughsScores =>
      _scoresStore.scores.where((score) => _playthroughIds.contains(score.playthroughId)).toList();

  @computed
  String get boardGameId => _gamePlaythroughsStore.boardGameId;

  @computed
  String? get boardGameImageUrl => _gamePlaythroughsStore.boardGameImageUrl;

  @computed
  String get boardGameName => _gamePlaythroughsStore.boardGameName;

  @computed
  GameClassification get gameClassification => _gamePlaythroughsStore.gameClassification;

  @action
  void loadBoardGamesStatistics() =>
      futureLoadBoardGamesStatistics = ObservableFuture<void>(_loadBoardGamesStatistics());

  Future<void> _loadBoardGamesStatistics() async {
    boardGameStatistics = const BoardGameStatistics.loading();
    Fimber.d(
      'Loading stats for a game ${_gamePlaythroughsStore.boardGameName} classified as ${gameClassification.toString()} [${_gamePlaythroughsStore.boardGameId}]',
    );
    final players = await _playerService.retrievePlayers(includeDeleted: true);
    final playersById = <String, Player>{for (Player player in players) player.id: player};

    if (_gamePlaythroughsStore.playthroughs.isEmpty) {
      boardGameStatistics = const BoardGameStatistics.none();
      return;
    }

    final Map<String, List<Score>> playthroughScoresByPlaythroughId =
        groupBy(_playthroughsScores, (s) => s.playthroughId!);
    final Map<String, List<Score>> playthroughScoresByBoardGameId =
        groupBy(_playthroughsScores, (s) => s.boardGameId);
    // MK Creating a local variable of finished playthroughs to avoid multitude of retrievals with a getter
    final finishedPlaythroughs = _gamePlaythroughsStore.finishedPlaythroughs;

    switch (gameClassification) {
      case GameClassification.Score:
        boardGameStatistics = _loadScoreBoardGamesStatistics(
          playersById,
          playthroughScoresByPlaythroughId,
          playthroughScoresByBoardGameId,
          finishedPlaythroughs,
        );
        break;
      case GameClassification.NoScore:
        boardGameStatistics = _loadNoScoreBoardGameStatistics(
          playersById,
          playthroughScoresByPlaythroughId,
          playthroughScoresByBoardGameId,
          finishedPlaythroughs,
        );
        break;
    }
  }

  BoardGameStatistics _loadNoScoreBoardGameStatistics(
    Map<String, Player> playersById,
    Map<String, List<Score>> playthroughScoresByPlaythroughId,
    Map<String, List<Score>> playthroughScoresByBoardGameId,
    List<Playthrough> finishedPlaythroughs,
  ) {
    if (finishedPlaythroughs.isEmpty) {
      return const BoardGameStatistics.none();
    }

    final totalWins = playthroughScoresByPlaythroughId.values
        .where((playthroughScores) =>
            playthroughScores.first.noScoreGameResult?.cooperativeGameResult ==
            CooperativeGameResult.win)
        .length;
    final totalLosses = playthroughScoresByPlaythroughId.values
        .where((playthroughScores) =>
            playthroughScores.first.noScoreGameResult?.cooperativeGameResult ==
            CooperativeGameResult.loss)
        .length;

    final noScoreBoardGameStatistics = NoScoreBoardGameStatistics(
      numberOfGamesPlayed: finishedPlaythroughs.length,
      averageNumberOfPlayers: finishedPlaythroughs.averageNumberOfPlayers,
      lastTimePlayed: finishedPlaythroughs.lastTimePlayed,
      totalWins: totalWins,
      totalLosses: totalLosses,
      totalPlaytimeInSeconds: finishedPlaythroughs.totalPlaytimeInSeconds,
      averagePlaytimeInSeconds: finishedPlaythroughs.averagePlaytimeInSeconds,
    );

    final List<PlayerStatistics> playersStatistics = [];
    final List<Score> playerScoresCollection =
        playthroughScoresByBoardGameId[boardGameId].onlyCooperativeGames();
    if (playerScoresCollection.isNotEmpty) {
      final Map<String, List<Score>> playerScoresGrouped =
          groupBy(playerScoresCollection, (Score score) => score.playerId);
      for (final String playerId in playerScoresGrouped.keys) {
        final Player player = playersById[playerId]!;
        playersStatistics.add(
          PlayerStatistics.noScoreGames(
            player: player,
            totalGamesPlayed: playerScoresGrouped[player.id]?.length ?? 0,
            totalWins: playerScoresGrouped[player.id].totalCooperativeWins,
            totalLosses: playerScoresGrouped[player.id].totalCooperativeLosses,
          ),
        );
      }
    }

    final playerCountPercentage = _retrievePlayerCountPercentage(finishedPlaythroughs);

    return BoardGameStatistics.noScore(
      boardGameStatistics: noScoreBoardGameStatistics.copyWith(
        playersStatistics: playersStatistics.sortByResult.toList(),
        playerCountPercentage: playerCountPercentage,
      ),
    );
  }

  BoardGameStatistics _loadScoreBoardGamesStatistics(
    Map<String, Player> playersById,
    Map<String, List<Score>> playthroughScoresByPlaythroughId,
    Map<String, List<Score>> playthroughScoresByBoardGameId,
    List<Playthrough> finishedPlaythroughs,
  ) {
    if (finishedPlaythroughs.isEmpty) {
      return const BoardGameStatistics.none();
    }

    final scoreBoardGameStatistics = ScoreBoardGameStatistics(
      numberOfGamesPlayed: finishedPlaythroughs.length,
      averageNumberOfPlayers: finishedPlaythroughs.averageNumberOfPlayers,
      lastTimePlayed: finishedPlaythroughs.lastTimePlayed,
      totalPlaytimeInSeconds: finishedPlaythroughs.totalPlaytimeInSeconds,
      averagePlaytimeInSeconds: finishedPlaythroughs.averagePlaytimeInSeconds,
      averageScorePrecision: _gamePlaythroughsStore.averageScorePrecision,
    );

    _updateLastGameWinners(
      finishedPlaythroughs,
      scoreBoardGameStatistics,
      playthroughScoresByPlaythroughId,
      playersById,
      _gamePlaythroughsStore.gameGameFamily,
    );

    if (!playthroughScoresByBoardGameId.containsKey(boardGameId)) {
      return BoardGameStatistics.score(boardGameStatistics: scoreBoardGameStatistics);
    }

    final List<Score> playerScoresCollection =
        playthroughScoresByBoardGameId[boardGameId].onlyScoresWithValue();
    if (playerScoresCollection.isNotEmpty) {
      final Map<String, List<Score>> playerScoresGrouped =
          groupBy(playerScoresCollection, (Score score) => score.playerId);
      scoreBoardGameStatistics.bestScore =
          playerScoresCollection.toBestScore(_gamePlaythroughsStore.gameGameFamily);
      scoreBoardGameStatistics.averageScore = playerScoresCollection.toAverageScore();

      final topFiveScores = playerScoresCollection
          .sortByScore(_gamePlaythroughsStore.gameGameFamily, ignorePlaces: true)!
          .take(_maxNumberOfTopScoresToDisplay);
      scoreBoardGameStatistics.topScoreres = [];
      for (final Score score in topFiveScores) {
        final Player player = playersById[score.playerId]!;
        if (scoreBoardGameStatistics.topScoreres!.length < _maxNumberOfTopScoresToDisplay) {
          scoreBoardGameStatistics.topScoreres!.add(Tuple2<Player, double>(player, score.score!));
        }
      }

      final playersStatistics = <PlayerStatistics>[];
      for (final String playerId in playerScoresGrouped.keys) {
        final Player player = playersById[playerId]!;
        playersStatistics.add(
          PlayerStatistics.scoreGames(
            player: player,
            averageScore: playerScoresGrouped[player.id]!.toAverageScore(),
            totalGamesPlayed: playerScoresGrouped[player.id]?.length ?? 0,
            personalBestScore: playerScoresGrouped[player.id]!
                    .toBestScore(_gamePlaythroughsStore.gameGameFamily)
                    ?.toInt() ??
                0,
          ),
        );
      }

      scoreBoardGameStatistics.playersStatistics = playersStatistics.sortByResult.toList();
    }

    scoreBoardGameStatistics.playerCountPercentage =
        _retrievePlayerCountPercentage(finishedPlaythroughs);
    scoreBoardGameStatistics.playerWinsPercentage = _retrievePlayerWinsPercentage(
      finishedPlaythroughs,
      playthroughScoresByPlaythroughId,
      playersById,
      _gamePlaythroughsStore.gameGameFamily,
    );

    return BoardGameStatistics.score(boardGameStatistics: scoreBoardGameStatistics);
  }

  void _updateLastGameWinners(
    List<Playthrough> finishedPlaythroughs,
    ScoreBoardGameStatistics scoreBoardGameStatistics,
    Map<String, List<Score>> playthroughScoresByPlaythroughId,
    Map<String, Player> playersById,
    GameFamily gameFamily,
  ) {
    final lastPlaythrough = finishedPlaythroughs.mostRecentPlaythrough;
    if (!playthroughScoresByPlaythroughId.containsKey(lastPlaythrough.id)) {
      return;
    }

    final lastPlaythroughBestScores =
        playthroughScoresByPlaythroughId[lastPlaythrough.id].winners(gameFamily);
    if (lastPlaythroughBestScores.isEmpty) {
      return;
    }

    scoreBoardGameStatistics.lastGameWinners = lastPlaythroughBestScores
        .map((Score score) => PlayerScore(
              player: playersById[score.playerId],
              score: score,
            ))
        .toList();
  }

  List<PlayerCountStatistics> _retrievePlayerCountPercentage(
    List<Playthrough> finishedPlaythroughs,
  ) {
    final List<PlayerCountStatistics> playerCountStatistics = [];
    final numberOfPlayersInPlaythroughs = finishedPlaythroughs
        .map((Playthrough playthrough) => playthrough.playerIds.length)
        .toList()
      ..sort((int numberOfPlayers, int otherNumberOfPlayers) =>
          numberOfPlayers.compareTo(otherNumberOfPlayers));
    groupBy(numberOfPlayersInPlaythroughs, (int numberOfPlayers) => numberOfPlayers).forEach(
      (numberOfPlayers, playthroughs) => playerCountStatistics.add(
        PlayerCountStatistics(
          numberOfPlayers: numberOfPlayers,
          numberOfGamesPlayed: playthroughs.length,
          gamesPlayedPercentage: playthroughs.length / finishedPlaythroughs.length,
        ),
      ),
    );

    return playerCountStatistics
      ..sort((playerCount, otherPlayerCount) =>
          otherPlayerCount.numberOfGamesPlayed.compareTo(playerCount.numberOfGamesPlayed));
  }

  List<PlayerWinsStatistics> _retrievePlayerWinsPercentage(
    List<Playthrough> finishedPlaythroughs,
    Map<String, List<Score>> playthroughScoresByPlaythroughId,
    Map<String, Player> playersById,
    GameFamily gameFamily,
  ) {
    final Map<Player, int> playerWins = {};
    for (final Playthrough finishedPlaythrough in finishedPlaythroughs) {
      final playthroughScores = playthroughScoresByPlaythroughId[finishedPlaythrough.id]
              .onlyScoresWithValue()
              .sortByScore(gameFamily) ??
          [];
      if (playthroughScores.isEmpty) {
        continue;
      }

      final Player? winner = playersById[playthroughScores.first.playerId];
      if (winner == null) {
        break;
      }
      playerWins[winner] = (playerWins[winner] ?? 0) + 1;
    }

    final playerWinsPercentage = <PlayerWinsStatistics>[];
    for (final MapEntry<Player, int> playerWin in playerWins.entries) {
      playerWinsPercentage.add(PlayerWinsStatistics(
        player: playerWin.key,
        numberOfWins: playerWin.value,
        winsPercentage: playerWin.value / finishedPlaythroughs.length,
      ));
    }

    return playerWinsPercentage
      ..sort((playerWins, otherPlayerWins) =>
          otherPlayerWins.numberOfWins.compareTo(playerWins.numberOfWins));
  }
}
