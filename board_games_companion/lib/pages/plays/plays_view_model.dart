// ignore_for_file: library_private_types_in_public_api

import 'package:basics/basics.dart';
import 'package:board_games_companion/common/enums/collection_type.dart';
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
import 'game_spinner_filters.dart';
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

  @observable
  GameSpinnerFilters gameSpinnerFilters = const GameSpinnerFilters(
    collections: <CollectionType>{
      CollectionType.owned,
      CollectionType.friends,
    },
  );

  @computed
  Map<String, Score> get _scores {
    return {
      for (final Score score
          in _scoreStore.scores.where((Score score) => score.playthroughId.isNotNullOrBlank))
        score.toMapKey(): score
    };
  }

  @computed
  List<Playthrough> get finishedPlaythroughs => _playthroughsStore.finishedPlaythroughs
      .where((playthrough) =>
          _boardGamesStore.allBoardGamesInCollectionsMap.containsKey(playthrough.boardGameId))
      .toList();

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
      .where((boardGame) =>
          (gameSpinnerFilters.collections.contains(CollectionType.friends) &&
              (boardGame.isFriends ?? false)) ||
          (gameSpinnerFilters.collections.contains(CollectionType.owned) &&
              (boardGame.isOwned ?? false)))
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

  @action
  void toggleGameSpinnerCollectionFilter(CollectionType collectionToggled) {
    // MK Remove collection filter only if other filter is active (i.e. if we remove both collection there won't be any games to pick from)
    if (gameSpinnerFilters.collections.contains(collectionToggled) &&
        gameSpinnerFilters.collections.length > 1) {
      gameSpinnerFilters = gameSpinnerFilters.copyWith(
        collections: Set.from(gameSpinnerFilters.collections)..remove(collectionToggled),
      );
    } else {
      gameSpinnerFilters = gameSpinnerFilters.copyWith(
        collections: Set.from(gameSpinnerFilters.collections)..add(collectionToggled),
      );
    }

    visualState = PlaysPageVisualState.selectGame(PlaysTab.selectGame, shuffledBoardGames);
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
