// ignore_for_file: library_private_types_in_public_api

import 'dart:math';

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
import 'package:tuple/tuple.dart';

import '../../models/hive/score.dart';
import '../../services/analytics_service.dart';
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
    this._analyticsService,
  );

  static const Map<int, Tuple2<String, String>> _screenViewByTabIndex = {
    1: Tuple2<String, String>('History', 'PlaysHistoryPage'),
    0: Tuple2<String, String>('SelectGame', 'PlaysSelectGamePage'),
  };

  static const int _numberOfTimesSpinnerCanTurn = 3;

  final PlaythroughsStore _playthroughsStore;
  final BoardGamesStore _boardGamesStore;
  final PlayersStore _playersStore;
  final ScoresStore _scoreStore;
  final AnalyticsService _analyticsService;

  @observable
  List<BoardGameDetails> _shuffledBoardGames = [];

  @observable
  ObservableFuture<void>? futureLoadGamesPlaythroughs;

  @observable
  PlaysPageVisualState? visualState;

  @observable
  GameSpinnerFilters gameSpinnerFilters = const GameSpinnerFilters(
    collections: <CollectionType>{},
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
  bool get hasAnyBoardGames => _boardGamesStore.allBoardGamesInCollections.isNotEmpty;

  @computed
  bool get hasAnyBoardGamesToShuffle => shuffledBoardGames.isNotEmpty;

  @computed
  List<BoardGameDetails> get shuffledBoardGames {
    final filteredShuffledBoardGames = <BoardGameDetails>[];
    if (gameSpinnerFilters.hasOwnedCollection) {
      filteredShuffledBoardGames.addAll(_shuffledBoardGames.inCollection(CollectionType.owned));
    }
    if (gameSpinnerFilters.hasFriendsCollection) {
      filteredShuffledBoardGames.addAll(_shuffledBoardGames.inCollection(CollectionType.friends));
    }

    return filteredShuffledBoardGames;
  }

  /// Picking a pseudo-random item index based on the number of shuffled board games
  /// multipled by an arbitrary number of how many times the wheel could spin (added for better effect).
  ///
  /// NOTE: The list will spin in a loop so it's safe to go over the actual board games collection size.
  @computed
  int get randomItemIndex =>
      Random().nextInt(shuffledBoardGames.length * _numberOfTimesSpinnerCanTurn);

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
  void toggleGameSpinnerCollectionFilter(CollectionType collectionTypeToggled) {
    // MK Remove collection filter only if other filter is active (i.e. if we remove both collection there won't be any games to pick from)
    if (gameSpinnerFilters.collections.contains(collectionTypeToggled) &&
        gameSpinnerFilters.collections.length > 1) {
      gameSpinnerFilters = gameSpinnerFilters.copyWith(
        collections: Set.from(gameSpinnerFilters.collections)..remove(collectionTypeToggled),
      );
    } else {
      gameSpinnerFilters = gameSpinnerFilters.copyWith(
        collections: Set.from(gameSpinnerFilters.collections)..add(collectionTypeToggled),
      );
    }

    visualState = PlaysPageVisualState.selectGame(PlaysTab.selectGame, shuffledBoardGames);
  }

  Future<void> trackTabChange(int tabIndex) async {
    await _analyticsService.logScreenView(
      screenName: _screenViewByTabIndex[tabIndex]!.item1,
      screenClass: _screenViewByTabIndex[tabIndex]!.item2,
    );
  }

  Future<void> _loadGamesPlaythroughs() async {
    await _scoreStore.loadScores();
    await _playersStore.loadPlayers();
    await _playthroughsStore.loadPlaythroughs();

    _shuffledBoardGames = _boardGamesStore.allBoardGames..shuffle();
    _setupGameSpinnerFilters();
    visualState = PlaysPageVisualState.history(
      PlaysTab.history,
      finishedBoardGamePlaythroughs,
    );
  }

  void _setupGameSpinnerFilters() {
    final filterCollections = <CollectionType>{};
    if (_shuffledBoardGames.inCollection(CollectionType.owned).isNotEmpty) {
      filterCollections.add(CollectionType.owned);
    }
    if (_shuffledBoardGames.inCollection(CollectionType.friends).isNotEmpty) {
      filterCollections.add(CollectionType.friends);
    }
    gameSpinnerFilters = gameSpinnerFilters.copyWith(
      collections: filterCollections,
    );
  }
}
