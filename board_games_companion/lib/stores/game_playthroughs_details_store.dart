// ignore_for_file: library_private_types_in_public_api

import 'package:collection/collection.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../common/enums/game_classification.dart';
import '../common/enums/game_family.dart';
import '../models/hive/board_game_details.dart';
import '../models/hive/player.dart';
import '../models/hive/playthrough.dart';
import '../models/hive/playthrough_note.dart';
import '../models/hive/score.dart';
import '../models/player_score.dart';
import '../models/playthroughs/playthrough_details.dart';
import 'board_games_store.dart';
import 'players_store.dart';
import 'playthroughs_store.dart';
import 'scores_store.dart';

part 'game_playthroughs_details_store.g.dart';

/// Store that loads [PlaythroughDetails] for a particular [BoardGameDetails].
/// [Playthrough]s are retrieved using [PlaythroughsStore] and filtered by board game id.
@singleton
class GamePlaythroughsDetailsStore = _GamePlaythroughsDetailsStore
    with _$GamePlaythroughsDetailsStore;

abstract class _GamePlaythroughsDetailsStore with Store {
  _GamePlaythroughsDetailsStore(
    this._playthroughsStore,
    this._scoresStore,
    this._playerStore,
    this._boardGamesStore,
  );

  final PlaythroughsStore _playthroughsStore;
  final ScoresStore _scoresStore;
  final PlayersStore _playerStore;
  final BoardGamesStore _boardGamesStore;

  @observable
  String? _boardGameId;

  @computed
  BoardGameDetails? get _boardGame => _boardGamesStore.allBoardGamesMap[_boardGameId];

  @observable
  ObservableList<PlaythroughDetails> playthroughsDetails = ObservableList.of([]);

  @computed
  List<Playthrough> get playthroughs => _playthroughsStore.playthroughs
      .where((playthrough) => playthrough.boardGameId == boardGameId)
      .toList();

  @computed
  List<Playthrough> get finishedPlaythroughs => _playthroughsStore.finishedPlaythroughs
      .where((playthrough) => playthrough.boardGameId == boardGameId)
      .toList()
    ..sort((playthrough, otherPlaythrough) =>
        otherPlaythrough.startDate.compareTo(playthrough.startDate));

  @computed
  String get boardGameName => _boardGame!.name;

  @computed
  String get boardGameId => _boardGame!.id;

  @computed
  String? get boardGameImageUrl => _boardGame!.imageUrl;

  @computed
  GameFamily get gameGameFamily => _boardGame!.settings?.gameFamily ?? GameFamily.HighestScore;

  @computed
  GameClassification get gameClassification =>
      _boardGame!.settings?.gameClassification ?? GameClassification.Score;

  @computed
  int get averageScorePrecision => _boardGame!.settings?.averageScorePrecision ?? 0;

  /// Ensure that [setBoardGameId] is called before loading playthoughs details and that [Playthrough]s in the [PlaythroughsStore] are loaded as well.
  @action
  void loadPlaythroughsDetails() {
    try {
      final loadedPlaythroughDetails = <PlaythroughDetails>[];
      for (final playthrough in playthroughs) {
        final playthroughDetails = createPlaythroughDetails(playthrough);
        loadedPlaythroughDetails.add(playthroughDetails);
      }

      playthroughsDetails = loadedPlaythroughDetails.asObservable();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  @action
  void setBoardGameId(String boardGameId) => _boardGameId = boardGameId;

  Future<PlaythroughDetails?> createPlaythrough(
    String boardGameId,
    List<Player> players,
    Map<String, PlayerScore> playerScores,
    DateTime startDate,
    Duration? duration, {
    int? bggPlayId,
    List<PlaythroughNote>? notes,
  }) async {
    final newPlaythrough = await _playthroughsStore.createPlaythrough(
      boardGameId,
      players,
      playerScores,
      startDate,
      duration,
      bggPlayId: bggPlayId,
      notes: notes,
    );

    if (newPlaythrough == null) {
      return null;
    }

    final newPlaythroughDetails = createPlaythroughDetails(newPlaythrough);
    playthroughsDetails.add(newPlaythroughDetails);
    return newPlaythroughDetails;
  }

  Future<void> updatePlaythrough(PlaythroughDetails? playthroughDetails) async {
    if (playthroughDetails?.id.isEmpty ?? true) {
      return;
    }

    try {
      final originalPlaythrough = _playthroughsStore.playthroughs
          .firstWhereOrNull((playthrough) => playthrough.id == playthroughDetails!.id);
      if (originalPlaythrough == null) {
        return;
      }

      final updateSuceeded =
          await _playthroughsStore.updatePlaythrough(playthroughDetails!.playthrough);
      if (updateSuceeded) {
        // MK Update playthrough's player scores
        for (final playerScoreId in originalPlaythrough.scoreIds) {
          final playerScore = playthroughDetails.playerScores
              .firstWhereOrNull((playerScore) => playerScore.score.id == playerScoreId);
          // MK Delete if not present anymore
          if (playerScore == null) {
            await _scoresStore.deleteScore(playerScoreId);
            continue;
          }

          // MK Add/Update extings ones
          await _scoresStore.addOrUpdateScore(playerScore.score);
        }

        loadPlaythroughsDetails();
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  Future<bool> deletePlaythrough(String playthroughId) async {
    try {
      final deleteSucceeded = await _playthroughsStore.deletePlaythrough(playthroughId);
      if (deleteSucceeded) {
        playthroughsDetails.removeWhere((p) => p.playthrough.id == playthroughId);
      }

      return deleteSucceeded;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }

  PlaythroughDetails createPlaythroughDetails(Playthrough playthrough) {
    final scores =
        _scoresStore.scores.where((score) => score.playthroughId == playthrough.id).toList()
          ..sortByScore(gameGameFamily)
          ..toList();
    final players =
        _playerStore.players.where((player) => playthrough.playerIds.contains(player.id)).toList();

    final playerScores = scores.mapIndexed((int index, Score score) {
      final player = players.firstWhereOrNull((Player p) => score.playerId == p.id);
      return PlayerScore(player: player, score: score, place: index + 1);
    }).toList()
      ..sortByPlayerName()
      ..sortByScore(gameGameFamily);

    return PlaythroughDetails(playthrough: playthrough, playerScores: playerScores);
  }
}
