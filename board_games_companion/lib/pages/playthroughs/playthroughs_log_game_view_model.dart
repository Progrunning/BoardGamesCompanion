// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:board_games_companion/models/hive/playthrough_note.dart';
import 'package:board_games_companion/models/hive/score_game_results.dart';
import 'package:clock/clock.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

import '../../common/analytics.dart';
import '../../common/enums/game_classification.dart';
import '../../common/enums/game_family.dart';
import '../../models/hive/no_score_game_result.dart';
import '../../models/hive/player.dart';
import '../../models/hive/score.dart';
import '../../models/player_score.dart';
import '../../models/playthroughs/playthrough_details.dart';
import '../../services/analytics_service.dart';
import '../../stores/game_playthroughs_details_store.dart';
import '../../stores/players_store.dart';
import 'playthrough_notes_state.dart';
import 'playthrough_timeline.dart';
import 'playthroughs_log_game_players.dart';

part 'playthroughs_log_game_view_model.g.dart';

@injectable
class PlaythroughsLogGameViewModel = _PlaythroughsLogGameViewModel
    with _$PlaythroughsLogGameViewModel;

abstract class _PlaythroughsLogGameViewModel with Store {
  _PlaythroughsLogGameViewModel(
    this._playersStore,
    this._gamePlaythroughsStore,
    this._analyticsService,
  );

  final PlayersStore _playersStore;
  final GamePlaythroughsDetailsStore _gamePlaythroughsStore;
  final AnalyticsService _analyticsService;

  @observable
  DateTime playthroughDate = DateTime.now();

  @observable
  Duration playthroughDuration = const Duration();

  @observable
  PlaythroughNotesState notesState = const PlaythroughNotesState.empty();

  @observable
  ObservableFuture<void>? futureLoadPlayers;

  @observable
  CooperativeGameResult? cooperativeGameResult;

  @observable
  PlaythroughTimeline playthroughTimeline = const PlaythroughTimeline.now();

  @computed
  ObservableList<Player> get players => _playersStore.players;

  @observable
  PlaythroughsLogGamePlayers playersState = const PlaythroughsLogGamePlayers.loading();

  @computed
  String get boardGameId => _gamePlaythroughsStore.boardGameId;

  @computed
  GameClassification get gameClassification => _gamePlaythroughsStore.gameClassification;

  @computed
  GameFamily get gameFamily => _gamePlaythroughsStore.gameGameFamily;

  @action
  void loadPlayers() => futureLoadPlayers = ObservableFuture<void>(_loadPlayers());

  @action
  Future<PlaythroughDetails?> createPlaythrough() async {
    return playersState.maybeWhen(
      playersSelected: (selectedPlayers, selectedPlayerScores) async {
        final updatedPlayerScores = _assignPlayerPlaces(selectedPlayerScores);
        final PlaythroughDetails? newPlaythrough = await _gamePlaythroughsStore.createPlaythrough(
          boardGameId,
          selectedPlayers,
          updatedPlayerScores,
          playthroughTimeline.when(now: () => clock.now(), inThePast: () => playthroughDate),
          playthroughTimeline.when(now: () => null, inThePast: () => playthroughDuration),
          notes: notesState.maybeWhen(
            notes: (playthroughNotes) => playthroughNotes,
            orElse: () => null,
          ),
        );

        unawaited(_analyticsService.logEvent(
          name: Analytics.logPlaythrough,
          parameters: <String, String>{
            Analytics.boardGameIdParameter: boardGameId,
            Analytics.logPlaythroughNumberOfPlayers: selectedPlayers.length.toString(),
            Analytics.logPlaythroughStarTime: playthroughTimeline.when(
              now: () => Analytics.playthroughTimelineInThePast,
              inThePast: () => Analytics.playthroughTimelineInThePast,
            ),
            Analytics.logPlaythroughDuration: playthroughDuration.toString(),
          },
        ));

        // MK Reset the log screen
        playthroughDate = clock.now();
        playthroughDuration = const Duration();
        cooperativeGameResult = null;
        notesState = const PlaythroughNotesState.empty();

        if (_playersStore.players.isEmpty) {
          playersState = const PlaythroughsLogGamePlayers.noPlayers();
        } else {
          playersState = const PlaythroughsLogGamePlayers.noPlayersSelected();
        }

        return newPlaythrough;
      },
      orElse: () => null,
    );
  }

  @action
  void setSelectedPlayers(List<Player> selectedPlayers) {
    final playerScores = <String, PlayerScore>{};
    for (final player in selectedPlayers) {
      final score = Score(
        id: const Uuid().v4(),
        playerId: player.id,
        boardGameId: boardGameId,
      );
      playerScores[player.id] = PlayerScore(player: player, score: score);

      if (gameFamily == GameFamily.Cooperative && cooperativeGameResult != null) {
        playerScores[player.id] = playerScores[player.id]!.copyWith(
          score: score.copyWith(
            noScoreGameResult: NoScoreGameResult(cooperativeGameResult: cooperativeGameResult),
          ),
        );
      }
    }

    playersState = PlaythroughsLogGamePlayers.playersSelected(
      players: selectedPlayers.sortAlphabetically(),
      playerScores: playerScores,
    );
  }

  @action
  void updatePlayerScore(PlayerScore playerScore, double newScore) {
    if (playerScore.score.score == newScore || playerScore.player == null) {
      return;
    }

    playersState.maybeWhen(
      playersSelected: (selectedPlayers, selectedPlayerScores) {
        final updatedPlayerScores = Map<String, PlayerScore>.from(selectedPlayerScores);
        final playerScoreToUpdate = selectedPlayerScores[playerScore.id];
        if (playerScoreToUpdate == null) {
          return;
        }

        final updatedPlayerScore = playerScoreToUpdate.copyWith(
          score: _updateScore(playerScoreToUpdate.score, newScore: newScore),
        );
        updatedPlayerScores[playerScore.player!.id] = updatedPlayerScore;

        playersState = PlaythroughsLogGamePlayers.playersSelected(
          players: selectedPlayers,
          playerScores: updatedPlayerScores,
        );
      },
      orElse: () {},
    );
  }

  @action
  void updateCooperativeGameResult(CooperativeGameResult cooperativeGameResult) {
    this.cooperativeGameResult = cooperativeGameResult;

    playersState.maybeWhen(
      playersSelected: (selectedPlayers, selectedPlayerScores) {
        final updatedPlayerScores = <String, PlayerScore>{};
        for (final playerScore in selectedPlayerScores.values) {
          if (playerScore.player == null) {
            continue;
          }

          updatedPlayerScores[playerScore.player!.id] = playerScore.copyWith(
            score: playerScore.score.copyWith(
              noScoreGameResult: NoScoreGameResult(
                cooperativeGameResult: cooperativeGameResult,
              ),
            ),
          );
        }

        playersState = PlaythroughsLogGamePlayers.playersSelected(
          players: selectedPlayers,
          playerScores: updatedPlayerScores,
        );
      },
      orElse: () {},
    );
  }

  @action
  void addNote(PlaythroughNote note) {
    notesState.when(
      notes: (playthroughNotes) {
        notesState = PlaythroughNotesState.notes(
          playthroughNotes: [...playthroughNotes, note],
        );
      },
      empty: () => notesState = PlaythroughNotesState.notes(playthroughNotes: [note]),
    );
  }

  @action
  void editNote(PlaythroughNote note) {
    notesState.maybeWhen(
      notes: (playthroughNotes) {
        final notes = playthroughNotes.toList();
        final noteToUpdateIndex = notes.indexWhere((n) => n.id == note.id);
        if (noteToUpdateIndex == null) {
          return;
        }

        notes[noteToUpdateIndex] = note;

        notesState = PlaythroughNotesState.notes(
          playthroughNotes: notes,
        );
      },
      orElse: () {},
    );
  }

  @action
  void deleteNote(PlaythroughNote note) {
    notesState.maybeWhen(
      notes: (playthroughNotes) {
        final notes = playthroughNotes.toList();
        notes.remove(note);
        if (notes.isEmpty) {
          notesState = const PlaythroughNotesState.empty();
        } else {
          notesState = PlaythroughNotesState.notes(
            playthroughNotes: notes,
          );
        }
      },
      orElse: () {},
    );
  }

  @action
  void setPlaythroughTimeline(PlaythroughTimeline playthroughTimeline) =>
      this.playthroughTimeline = playthroughTimeline;
  Future<void> _loadPlayers() async {
    playersState = const PlaythroughsLogGamePlayers.loading();

    await _playersStore.loadPlayers();

    if (_playersStore.players.isEmpty) {
      playersState = const PlaythroughsLogGamePlayers.noPlayers();
      return;
    }

    playersState = const PlaythroughsLogGamePlayers.noPlayersSelected();
  }

  Map<String, PlayerScore> _assignPlayerPlaces(Map<String, PlayerScore> playerScoresMap) {
    final updatedPlayerScores = Map<String, PlayerScore>.from(playerScoresMap);
    if (gameFamily == GameFamily.Cooperative) {
      return updatedPlayerScores;
    }

    final orderedPlayerScores = updatedPlayerScores.values.toList().sortByScore(
          gameFamily,
          ignorePlaces: true,
        );

    final tiedScoresSet = {
      for (final tiedScore in orderedPlayerScores.onlyTiedScores()) tiedScore.id: tiedScore
    };

    for (var i = 0; i < orderedPlayerScores.length; i++) {
      updatedPlayerScores[orderedPlayerScores[i].id!] = orderedPlayerScores[i].copyWith(
        score: _updateScore(
          orderedPlayerScores[i].score,
          place: i + 1,
          isTied: tiedScoresSet.containsKey(orderedPlayerScores[i].id),
        ),
      );
    }

    return updatedPlayerScores;
  }

  Score _updateScore(Score score, {double? newScore, int? place, bool isTied = false}) {
    final scoreGameResult = score.scoreGameResult ?? const ScoreGameResult();
    return score.copyWith(
      scoreGameResult: scoreGameResult.copyWith(
        points: newScore ?? scoreGameResult.points,
        place: place,
        tiebreakerType: isTied ? ScoreTiebreakerType.place : null,
      ),
    );
  }
}
