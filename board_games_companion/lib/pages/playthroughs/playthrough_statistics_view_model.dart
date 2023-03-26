// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/common/enums/game_family.dart';
import 'package:board_games_companion/stores/game_playthroughs_details_store.dart';
import 'package:board_games_companion/stores/scores_store.dart';
import 'package:collection/collection.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:tuple/tuple.dart';

import '../../common/enums/game_classification.dart';
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
    // TODO Implement
    return const BoardGameStatistics.none();
  }

  BoardGameStatistics _loadScoreBoardGamesStatistics(
    Map<String, Player> playersById,
    Map<String, List<Score>> playthroughScoresByPlaythroughId,
    Map<String, List<Score>> playthroughScoresByBoardGameId,
    List<Playthrough> finishedPlaythroughs,
  ) {
    final scoreBoardGameStatistics = ScoreBoardGameStatistics();

    _updateLastPlayedAndWinner(
      finishedPlaythroughs,
      scoreBoardGameStatistics,
      playthroughScoresByPlaythroughId,
      playersById,
      _gamePlaythroughsStore.gameGameFamily,
    );

    if (finishedPlaythroughs.isEmpty) {
      return const BoardGameStatistics.none();
    }

    scoreBoardGameStatistics.numberOfGamesPlayed = finishedPlaythroughs.length;
    scoreBoardGameStatistics.averageNumberOfPlayers = finishedPlaythroughs
            .map((Playthrough playthrough) => playthrough.playerIds.length)
            .reduce((a, b) => a + b) /
        scoreBoardGameStatistics.numberOfGamesPlayed!;

    if (!playthroughScoresByBoardGameId.containsKey(boardGameId)) {
      return BoardGameStatistics.score(scoreBoardGameStatistics: scoreBoardGameStatistics);
    }

    final List<Score> playerScoresCollection = playthroughScoresByBoardGameId[boardGameId]
        .onlyScoresWithValue()
      ..sortByScore(_gamePlaythroughsStore.gameGameFamily);
    if (playerScoresCollection.isNotEmpty) {
      final Map<String, List<Score>> playerScoresGrouped =
          groupBy(playerScoresCollection, (Score score) => score.playerId);
      scoreBoardGameStatistics.bestScore =
          playerScoresCollection.toBestScore(_gamePlaythroughsStore.gameGameFamily);
      scoreBoardGameStatistics.averageScore = playerScoresCollection.toAverageScore();

      scoreBoardGameStatistics.topScoreres = [];
      scoreBoardGameStatistics.playersStatistics = [];
      for (final Score score in playerScoresCollection) {
        final Player player = playersById[score.playerId]!;
        if (scoreBoardGameStatistics.topScoreres!.length < _maxNumberOfTopScoresToDisplay) {
          scoreBoardGameStatistics.topScoreres!.add(Tuple2<Player, String>(player, score.value!));
        }

        if (scoreBoardGameStatistics.playersStatistics!
            .any((PlayerStatistics playerStats) => playerStats.player == player)) {
          continue;
        }

        final PlayerStatistics playerStatistics = PlayerStatistics(player);
        playerStatistics.personalBestScore = num.tryParse(score.value!);
        playerStatistics.numberOfGamesPlayed = playerScoresGrouped[player.id]?.length ?? 0;
        playerStatistics.averageScore = playerScoresGrouped[player.id]!.toAverageScore();
        scoreBoardGameStatistics.playersStatistics!.add(playerStatistics);
      }
    }

    _updatePlayerCountPercentage(finishedPlaythroughs, scoreBoardGameStatistics);
    _updatePlayerWinsPercentage(
      finishedPlaythroughs,
      scoreBoardGameStatistics,
      playthroughScoresByPlaythroughId,
      playersById,
      _gamePlaythroughsStore.gameGameFamily,
    );

    scoreBoardGameStatistics.averageScorePrecision = _gamePlaythroughsStore.averageScorePrecision;
    scoreBoardGameStatistics.totalPlaytimeInSeconds = finishedPlaythroughs
        .map((Playthrough p) => p.endDate!.difference(p.startDate).inSeconds)
        .reduce((a, b) => a + b);

    return BoardGameStatistics.score(scoreBoardGameStatistics: scoreBoardGameStatistics);
  }

  void _updateLastPlayedAndWinner(
    List<Playthrough>? finishedPlaythroughs,
    ScoreBoardGameStatistics scoreBoardGameStatistics,
    Map<String, List<Score>> playthroughScoresByPlaythroughId,
    Map<String, Player> playersById,
    GameFamily gameFamily,
  ) {
    if (finishedPlaythroughs?.isEmpty ?? true) {
      return;
    }

    final lastPlaythrough = finishedPlaythroughs!.first;
    scoreBoardGameStatistics.lastPlayed = lastPlaythrough.startDate;

    if (!playthroughScoresByPlaythroughId.containsKey(lastPlaythrough.id)) {
      return;
    }

    final lastPlaythroughScores = playthroughScoresByPlaythroughId[lastPlaythrough.id]
        .onlyScoresWithValue()
      ..sortByScore(gameFamily);

    if (lastPlaythroughScores.isEmpty) {
      scoreBoardGameStatistics.lastWinner = null;
      return;
    }

    final lastPlaythroughBestScore = lastPlaythroughScores.first;
    if (!playersById.containsKey(lastPlaythroughBestScore.playerId)) {
      return;
    }

    scoreBoardGameStatistics.lastWinner = PlayerScore(
      player: playersById[lastPlaythroughBestScore.playerId],
      score: lastPlaythroughBestScore,
    );
  }

  void _updatePlayerCountPercentage(
    List<Playthrough> finishedPlaythroughs,
    ScoreBoardGameStatistics scoreBoardGameStatistics,
  ) {
    scoreBoardGameStatistics.playerCountPercentage = [];
    final numberOfPlayersInPlaythroughs = finishedPlaythroughs
        .map((Playthrough playthrough) => playthrough.playerIds.length)
        .toList()
      ..sort((int numberOfPlayers, int otherNumberOfPlayers) =>
          numberOfPlayers.compareTo(otherNumberOfPlayers));
    groupBy(numberOfPlayersInPlaythroughs, (int numberOfPlayers) => numberOfPlayers).forEach(
      (numberOfPlayers, playthroughs) => scoreBoardGameStatistics.playerCountPercentage!.add(
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
    ScoreBoardGameStatistics scoreBoardGameStatistics,
    Map<String, List<Score>> playthroughScoresByPlaythroughId,
    Map<String, Player> playersById,
    GameFamily gameFamily,
  ) {
    final Map<Player, int> playerWins = {};
    for (final Playthrough finishedPlaythrough in finishedPlaythroughs) {
      final List<Score> playthroughScores =
          playthroughScoresByPlaythroughId[finishedPlaythrough.id].sortByScore(gameFamily) ?? [];
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

    scoreBoardGameStatistics.playerWinsPercentage = [];
    for (final MapEntry<Player, int> playerWin in playerWins.entries) {
      scoreBoardGameStatistics.playerWinsPercentage!.add(PlayerWinsStatistics(
        player: playerWin.key,
        numberOfWins: playerWin.value,
        winsPercentage: playerWin.value / finishedPlaythroughs.length,
      ));
    }
  }
}
