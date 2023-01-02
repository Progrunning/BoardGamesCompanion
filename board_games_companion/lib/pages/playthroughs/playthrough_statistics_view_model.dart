// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/common/enums/game_winning_condition.dart';
import 'package:board_games_companion/stores/game_playthroughs_details_store.dart';
import 'package:board_games_companion/stores/scores_store.dart';
import 'package:collection/collection.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:tuple/tuple.dart';

import '../../models/board_game_statistics.dart';
import '../../models/hive/player.dart';
import '../../models/hive/playthrough.dart';
import '../../models/hive/score.dart';
import '../../models/player_score.dart';
import '../../models/player_statistics.dart';
import '../../services/player_service.dart';

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

  BoardGameStatistics boardGameStatistics = BoardGameStatistics();

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

  @action
  void loadBoardGamesStatistics() =>
      futureLoadBoardGamesStatistics = ObservableFuture<void>(_loadBoardGamesStatistics());

  Future<void> _loadBoardGamesStatistics() async {
    Fimber.d(
        'Loading stats for game ${_gamePlaythroughsStore.boardGameName} [${_gamePlaythroughsStore.boardGameId}]');
    final boardGameId = _gamePlaythroughsStore.boardGameId;
    final gameWinningCondition = _gamePlaythroughsStore.gameWinningCondition;
    final players = await _playerService.retrievePlayers(includeDeleted: true);
    final playersById = <String, Player>{for (Player player in players) player.id: player};

    if (_gamePlaythroughsStore.playthroughs.isEmpty) {
      boardGameStatistics = BoardGameStatistics();
      return;
    }

    final Map<String, List<Score>> playthroughScoresByPlaythroughId =
        groupBy(_playthroughsScores, (s) => s.playthroughId!);
    final Map<String, List<Score>> playthroughScoresByBoardGameId =
        groupBy(_playthroughsScores, (s) => s.boardGameId);

    // MK Creating a local variable of finished playthroughs to avoid multitude of retrievals with a getter
    final finishedPlaythroughs = _gamePlaythroughsStore.finishedPlaythroughs;
    _updateLastPlayedAndWinner(
      finishedPlaythroughs,
      boardGameStatistics,
      playthroughScoresByPlaythroughId,
      playersById,
      gameWinningCondition,
    );

    if (finishedPlaythroughs.isEmpty) {
      boardGameStatistics = BoardGameStatistics();
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

    boardGameStatistics.averageScorePrecision = _gamePlaythroughsStore.averageScorePrecision;
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
    boardGameStatistics.playerCountPercentage = [];
    final numberOfPlayersInPlaythroughs = finishedPlaythroughs
        .map((Playthrough playthrough) => playthrough.playerIds.length)
        .toList()
      ..sort((int numberOfPlayers, int otherNumberOfPlayers) =>
          numberOfPlayers.compareTo(otherNumberOfPlayers));
    groupBy(numberOfPlayersInPlaythroughs, (int numberOfPlayers) => numberOfPlayers).forEach(
      (numberOfPlayers, playthroughs) => boardGameStatistics.playerCountPercentage!.add(
        PlayerCountStatistics(
          numberOfPlayers: numberOfPlayers,
          numberOfGamesPlayed: playthroughs.length,
          gamesPlayedPercentage: playthroughs.length / finishedPlaythroughs.length,
        ),
      ),
    );
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
              .sortByScore(gameWinningCondition) ??
          [];
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

    boardGameStatistics.playerWinsPercentage = [];
    for (final MapEntry<Player, int> playerWin in playerWins.entries) {
      boardGameStatistics.playerWinsPercentage!.add(PlayerWinsStatistics(
        player: playerWin.key,
        numberOfWins: playerWin.value,
        winsPercentage: playerWin.value / finishedPlaythroughs.length,
      ));
    }
  }
}
