// ignore_for_file: library_private_types_in_public_api

import 'package:basics/basics.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/models/player_score.dart';
import 'package:board_games_companion/models/playthrough_details.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/stores/players_store.dart';
import 'package:board_games_companion/stores/scores_store.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../models/hive/score.dart';
import '../../stores/playthroughs_store.dart';
import 'board_game_playthrough.dart';
import 'grouped_board_game_playthroughs.dart';

part 'playthroughs_history_view_model.g.dart';

@injectable
class PlaythroughsHistoryViewModel = _PlaythroughsHistoryViewModel
    with _$PlaythroughsHistoryViewModel;

abstract class _PlaythroughsHistoryViewModel with Store {
  _PlaythroughsHistoryViewModel(
    this._playthroughsStore,
    this._boardGamesStore,
    this._playersStore,
    this._scoreStore,
  );

  final PlaythroughsStore _playthroughsStore;
  final BoardGamesStore _boardGamesStore;
  final PlayersStore _playersStore;
  final ScoresStore _scoreStore;

  @computed
  Map<String, Score> get _scores {
    return {
      for (final Score score
          in _scoreStore.scores.where((Score score) => score.playthroughId.isNotNullOrBlank))
        score.toMapKey(): score
    };
  }

  @observable
  ObservableFuture<void>? futureLoadGamesPlaythroughs;

  @computed
  List<Playthrough> get finishedPlaythroughs => _playthroughsStore.finishedPlaythroughs.toList();

  @computed
  List<GroupedBoardGamePlaythroughs> get finishedBoardGamePlaythroughs {
    final result = <GroupedBoardGamePlaythroughs>[];
    final finishedPlaythroughsGrouped = groupBy(
        finishedPlaythroughs
          ..sort((playthroughA, playthroughB) =>
              playthroughB.endDate!.compareTo(playthroughA.endDate!)),
        (Playthrough playthrough) => playthroughGroupingDateFormat.format(playthrough.endDate!));

    for (final playthroughsEntry in finishedPlaythroughsGrouped.entries) {
      result.add(
        GroupedBoardGamePlaythroughs(
          date: playthroughGroupingDateFormat.parse(playthroughsEntry.key),
          boardGamePlaythroughs: playthroughsEntry.value
              .map((playthrough) => BoardGamePlaythrough(
                    playthrough: PlaythroughDetails(
                      playthrough: playthrough,
                      playerScores: [
                        for (final playerId in playthrough.playerIds)
                          PlayerScore(
                            player: _playersStore.playersById[playerId],
                            score: _scores['${playthrough.id}$playerId'] ??
                                Score(
                                  id: '',
                                  playerId: playerId,
                                  boardGameId: playthrough.boardGameId,
                                ),
                          )
                      ],
                    ),
                    boardGameDetails:
                        _boardGamesStore.allBoardGamesInCollectionsMap[playthrough.boardGameId]!,
                  ))
              .toList(),
        ),
      );
    }

    return result;
  }

  @computed
  bool get hasAnyFinishedPlaythroughs => finishedPlaythroughs.isNotEmpty;

  @action
  void loadGamesPlaythroughs() =>
      futureLoadGamesPlaythroughs = ObservableFuture<void>(_loadGamesPlaythroughs());

  Future<void> _loadGamesPlaythroughs() async {
    await _playthroughsStore.loadPlaythroughs();
    await _playersStore.loadPlayers();
    await _scoreStore.loadScores();
  }
}
