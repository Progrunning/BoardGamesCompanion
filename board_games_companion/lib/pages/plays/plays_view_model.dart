// ignore_for_file: library_private_types_in_public_api

import 'package:basics/basics.dart';
import 'package:board_games_companion/common/enums/plays_tab.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
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
import 'plays_page_visual_states.dart';

part 'plays_view_model.g.dart';

@injectable
class PlaysViewModel = _PlaysViewModel with _$PlaysViewModel;

abstract class _PlaysViewModel with Store {
  _PlaysViewModel(
    this._playthroughsStore,
    this._boardGamesStore,
    this._playersStore,
    this._scoreStore,
  );

  final PlaythroughsStore _playthroughsStore;
  final BoardGamesStore _boardGamesStore;
  final PlayersStore _playersStore;
  final ScoresStore _scoreStore;

  @observable
  List<BoardGameDetails> _shuffledBoardGames = [];

  @observable
  ObservableFuture<void>? futureLoadGamesPlaythroughs;

  @observable
  PlaysPageVisualState? visualState;

  @computed
  Map<String, Score> get _scores {
    return {
      for (final Score score
          in _scoreStore.scores.where((Score score) => score.playthroughId.isNotNullOrBlank))
        score.toMapKey(): score
    };
  }

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

  @computed
  List<BoardGameDetails> get shuffledBoardGames => _shuffledBoardGames
      .where((boardGame) => (boardGame.isFriends ?? false) || (boardGame.isOwned ?? false))
      .toList();

  @action
  void loadGamesPlaythroughs() =>
      futureLoadGamesPlaythroughs = ObservableFuture<void>(_loadGamesPlaythroughs());

  @action
  void setSelectTab(PlaysTab selectedTab) {
    switch (selectedTab) {
      case PlaysTab.history:
        visualState = PlaysPageVisualState.history(PlaysTab.history, finishedBoardGamePlaythroughs);
        break;

      case PlaysTab.statistics:
        visualState = const PlaysPageVisualState.statistics(PlaysTab.statistics);
        break;

      case PlaysTab.selectGame:
        visualState = PlaysPageVisualState.selectGame(PlaysTab.selectGame, shuffledBoardGames);
        break;

      default:
    }
  }

  Future<void> _loadGamesPlaythroughs() async {
    await _scoreStore.loadScores();
    await _playersStore.loadPlayers();
    await _playthroughsStore.loadPlaythroughs();

    _shuffledBoardGames = _boardGamesStore.allBoardGames..shuffle();
    visualState = PlaysPageVisualState.history(
      PlaysTab.history,
      finishedBoardGamePlaythroughs,
    );
  }
}
