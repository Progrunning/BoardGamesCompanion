// ignore_for_file: library_private_types_in_public_api

import 'dart:math';

import 'package:basics/basics.dart';
import 'package:board_games_companion/common/enums/plays_stats_preset_time_period.dart';
import 'package:board_games_companion/common/helpers/date_time_helpers.dart';
import 'package:board_games_companion/extensions/playthroughs_extensions.dart';
import 'package:board_games_companion/pages/plays/historical_playthrough.dart';
import 'package:board_games_companion/pages/plays/most_played_game.dart';
import 'package:board_games_companion/pages/plays/plays_stats_visual_states.dart';
import 'package:board_games_companion/pages/plays/time_period.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:tuple/tuple.dart';

import '../../common/analytics.dart';
import '../../common/enums/collection_type.dart';
import '../../common/enums/plays_tab.dart';
import '../../extensions/date_time_extensions.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/hive/playthrough.dart';
import '../../models/hive/score.dart';
import '../../models/player_score.dart';
import '../../models/playthroughs/playthrough_details.dart';
import '../../services/analytics_service.dart';
import '../../stores/board_games_store.dart';
import '../../stores/players_store.dart';
import '../../stores/playthroughs_store.dart';
import '../../stores/scores_store.dart';
import 'board_game_playthrough.dart';
import 'game_spinner_filters.dart';
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
    0: Tuple2<String, String>('History', 'PlaysHistoryPage'),
    1: Tuple2<String, String>('Statistics', 'PlaysStatisticsPage'),
    2: Tuple2<String, String>('SelectGame', 'PlaysSelectGamePage'),
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
  ObservableFuture<void>? futureLoadData;

  @observable
  PlaysPageVisualState visualState = const PlaysPageVisualState.history();

  @observable
  GameSpinnerFilters gameSpinnerFilters = const GameSpinnerFilters(
    collections: <CollectionType>{},
    includeExpansions: true,
  );

  @computed
  Map<String, Score> get _scores => {
        for (final Score score
            in _scoreStore.scores.where((Score score) => score.playthroughId.isNotNullOrBlank))
          score.toMapKey(): score
      };

  @computed
  List<Playthrough> get finishedPlaythroughs => _playthroughsStore.finishedPlaythroughs.toList();

  @computed
  List<HistoricalPlaythrough> get historicalPlaythroughs {
    final result = <HistoricalPlaythrough>[];
    final playthroughsGrouped = groupBy(finishedPlaythroughs.sortedByStartDate,
        (Playthrough playthrough) => historicalPlaythroughDateFormat.format(playthrough.startDate));

    for (final playthroughsEntry in playthroughsGrouped.entries) {
      result.add(
        HistoricalPlaythrough.withDateHeader(
          playedOn: historicalPlaythroughDateFormat.parse(playthroughsEntry.key),
          boardGamePlaythroughs: _mapToBoardGamePlaythrough(playthroughsEntry.value.first),
        ),
      );

      if (playthroughsEntry.value.length <= 1) {
        continue;
      }

      for (final playthrough in playthroughsEntry.value.skip(1)) {
        result.add(HistoricalPlaythrough.withoutDateHeader(
          boardGamePlaythroughs: _mapToBoardGamePlaythrough(playthrough),
        ));
      }
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
  int get maxNumberOfPlayers => _shuffledBoardGames.maxNumberOfPlayers;

  @computed
  List<BoardGameDetails> get shuffledBoardGames {
    final filteredShuffledBoardGames = <BoardGameDetails>[];
    if (gameSpinnerFilters.hasOwnedCollection) {
      filteredShuffledBoardGames.addAll(_shuffledBoardGames.inCollection(CollectionType.owned));
    }
    if (gameSpinnerFilters.hasFriendsCollection) {
      filteredShuffledBoardGames.addAll(_shuffledBoardGames.inCollection(CollectionType.friends));
    }

    if (!gameSpinnerFilters.includeExpansions) {
      filteredShuffledBoardGames.removeWhere((boardGame) => boardGame.isExpansion ?? false);
    }

    gameSpinnerFilters.numberOfPlayersFilter.maybeWhen(
      solo: () => filteredShuffledBoardGames
          .removeWhere((boardGame) => boardGame.minPlayers == null || boardGame.minPlayers! > 1),
      couple: () => filteredShuffledBoardGames.removeWhere(
        (boardGame) =>
            (boardGame.minPlayers == null || boardGame.minPlayers != 2) ||
            (boardGame.maxPlayers == null || boardGame.maxPlayers != 2),
      ),
      moreOrEqualTo: (numberOfPlayers) => filteredShuffledBoardGames.removeWhere(
          (boardGame) => boardGame.maxPlayers == null || boardGame.maxPlayers! < numberOfPlayers),
      orElse: () {},
    );

    gameSpinnerFilters.playtimeFilter.maybeWhen(
      lessThan: (playtimeInMinutes) => filteredShuffledBoardGames.removeWhere((boardGame) =>
          boardGame.maxPlaytime == null || playtimeInMinutes < boardGame.maxPlaytime!),
      orElse: () {},
    );

    return filteredShuffledBoardGames;
  }

  /// Picking a pseudo-random item index based on the number of shuffled board games
  /// multipled by an arbitrary number of how many times the wheel could spin (added for better effect).
  ///
  /// NOTE: The list will spin in a loop so it's safe to go over the actual board games collection size.
  @computed
  int get randomItemIndex =>
      Random().nextInt(shuffledBoardGames.length * _numberOfTimesSpinnerCanTurn);

  @observable
  PlaysStatsVisualState playsStatsVisualState = const PlaysStatsVisualState.init();

  @action
  void loadData() => futureLoadData = ObservableFuture<void>(_loadData());

  @action
  void setSelectTab(PlaysTab selectedTab) {
    switch (selectedTab) {
      case PlaysTab.history:
        visualState = const PlaysPageVisualState.history();
        break;

      case PlaysTab.statistics:
        visualState = const PlaysPageVisualState.statistics();
        updatePlaysPresetTimePeriod(PlayStatsPresetTimePeriod.LastWeek);
        break;

      case PlaysTab.selectGame:
        visualState = const PlaysPageVisualState.selectGame();
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

    visualState = const PlaysPageVisualState.selectGame();
  }

  @action
  void toggleIncludeExpansionsFilter(bool? includeExpansions) {
    gameSpinnerFilters = gameSpinnerFilters.copyWith(
      includeExpansions: includeExpansions ?? false,
    );

    visualState = const PlaysPageVisualState.selectGame();
  }

  @action
  void updateNumberOfPlayersNumberFilter(NumberOfPlayersFilter numberOfPlayersFilter) {
    gameSpinnerFilters = gameSpinnerFilters.copyWith(numberOfPlayersFilter: numberOfPlayersFilter);

    visualState = const PlaysPageVisualState.selectGame();
  }

  @action
  void updatePlaytimeFilter(PlaytimeFilter playtimeFilter) {
    gameSpinnerFilters = gameSpinnerFilters.copyWith(playtimeFilter: playtimeFilter);

    visualState = const PlaysPageVisualState.selectGame();
  }

  @action
  Future<void> updatePlaysPresetTimePeriod(PlayStatsPresetTimePeriod? presetTimePeriod) async {
    if (presetTimePeriod == null) {
      return;
    }

    final showStatsTimePeriod = _calculatePresetTimePeriod(presetTimePeriod);
    await _loadStats(showStatsTimePeriod.from, showStatsTimePeriod.to, presetTimePeriod);
  }

  @action
  Future<void> updatePlaysCustomTimePeriod(DateTimeRange dateTimeRange) async =>
      _loadStats(dateTimeRange.start, dateTimeRange.end, PlayStatsPresetTimePeriod.Custom);

  Future<void> trackTabChange(int tabIndex) async {
    await _analyticsService.logScreenView(
      screenName: _screenViewByTabIndex[tabIndex]!.item1,
      screenClass: _screenViewByTabIndex[tabIndex]!.item2,
    );
  }

  Future<void> trackGameSelected() async =>
      _analyticsService.logEvent(name: Analytics.selectRandomGame);

  Future<void> _loadData() async {
    await _scoreStore.loadScores();
    await _playersStore.loadPlayers();
    await _playthroughsStore.loadPlaythroughs();

    _shuffledBoardGames = _boardGamesStore.allBoardGames
        .where((boardGame) => (boardGame.isOwned ?? false) || (boardGame.isFriends ?? false))
        .toList()
      ..shuffle();
    _setupGameSpinnerFilters();
  }

  Future<void> _loadStats(
    DateTime timePeriodFrom,
    DateTime timePeriodTo,
    PlayStatsPresetTimePeriod presetTimePeriod,
  ) async {
    playsStatsVisualState = const PlaysStatsVisualState.loading();
    if (historicalPlaythroughs.isEmpty) {
      playsStatsVisualState = const PlaysStatsVisualState.empty();
      return;
    }

    final boardGamePlaythroughsInPeriod = historicalPlaythroughs
        .where((hp) =>
            hp.boardGamePlaythroughs.playthrough.endDate! >= timePeriodFrom &&
            hp.boardGamePlaythroughs.playthrough.endDate! <= timePeriodTo)
        .map((hp) => hp.boardGamePlaythroughs)
        .toList();
    if (boardGamePlaythroughsInPeriod.isEmpty) {
      playsStatsVisualState = PlaysStatsVisualState.noStatsInPeriod(
        timePeriod: TimePeriod(
          presetTimePeriod: presetTimePeriod,
          earliestPlaythrough:
              historicalPlaythroughs.last.boardGamePlaythroughs.playthrough.endDate!,
          from: timePeriodFrom,
          to: timePeriodTo,
        ),
      );
      return;
    }

    final playthroughsGroupedByGame = groupBy(
        boardGamePlaythroughsInPeriod, (BoardGamePlaythrough bgp) => bgp.boardGameDetails.id);
    final mostPlayedGames = <MostPlayedGame>[];
    for (final playthroughsGrouped in playthroughsGroupedByGame.entries) {
      final boardGameDetails =
          _boardGamesStore.allBoardGamesInCollectionsMap[playthroughsGrouped.key];
      if (boardGameDetails == null) {
        continue;
      }

      mostPlayedGames.add(MostPlayedGame(
        boardGameDetails: boardGameDetails,
        totalNumberOfPlays: playthroughsGrouped.value.length,
        totalTimePlayedInSeconds: playthroughsGrouped.value
            .map((e) => e.playthrough.duration.inSeconds)
            .reduce((a, b) => a + b),
      ));
    }

    playsStatsVisualState = PlaysStatsVisualState.stats(
      timePeriod: TimePeriod(
        presetTimePeriod: presetTimePeriod,
        earliestPlaythrough: historicalPlaythroughs.last.boardGamePlaythroughs.playthrough.endDate!,
        from: timePeriodFrom,
        to: timePeriodTo,
      ),
      mostPlayedGames: mostPlayedGames
        ..sort((mostPlayedGame, otherMostPlayedGame) =>
            otherMostPlayedGame.totalNumberOfPlays.compareTo(mostPlayedGame.totalNumberOfPlays)),
      totalGamesLogged: boardGamePlaythroughsInPeriod.length,
      totalGamesPlayed: playthroughsGroupedByGame.length,
      totalPlaytimeInSeconds: boardGamePlaythroughsInPeriod
          .map((bgp) => bgp.playthrough.duration.inSeconds)
          .reduce((a, b) => a + b),
      totalDuelGamesLogged:
          boardGamePlaythroughsInPeriod.where((element) => element.playthrough.isDuel).length,
      totalMultiPlayerGamesLogged: boardGamePlaythroughsInPeriod
          .where((element) => element.playthrough.isMultiPlayerGame)
          .length,
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

  BoardGamePlaythrough _mapToBoardGamePlaythrough(Playthrough playthrough) {
    return BoardGamePlaythrough(
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
      boardGameDetails: _boardGamesStore.allBoardGamesMap[playthrough.boardGameId]!,
    );
  }

  /// Calculates the [from] and [to] dates for the given [PlayStatsPresetTimePeriod].
  ///
  /// NOTE: [PlayStatsPresetTimePeriod.Custom] will result in the same calculations as
  /// [PlayStatsPresetTimePeriod.LastWeek] as a "default" option. This is an arbitrary decision
  /// of how this method should handle [PlayStatsPresetTimePeriod.Custom] option, which is not
  /// a preset value.
  ({DateTime from, DateTime to}) _calculatePresetTimePeriod(
      PlayStatsPresetTimePeriod presetTimePeriod) {
    final now = DateTime.now();
    switch (presetTimePeriod) {
      case PlayStatsPresetTimePeriod.Custom:
      case PlayStatsPresetTimePeriod.LastWeek:
        final lastSunday = mostRecentWeekday(now, 0);
        return (from: lastSunday.subtract(const Duration(days: 7)), to: lastSunday);
      case PlayStatsPresetTimePeriod.LastMonth:
        final firstDayOfThisMonth = DateTime(now.year, now.month, 1);
        final lastDayOfPreviousMonth = firstDayOfThisMonth.subtract(const Duration(days: 1));
        final firstDayOfPreviousMonth = DateTime(now.year, now.month - 1, 1);
        return (from: firstDayOfPreviousMonth, to: lastDayOfPreviousMonth);
      case PlayStatsPresetTimePeriod.LastYear:
        final firstDayOfThisYear = DateTime(now.year, 1, 1);
        final lastDayOfPreviousYear = firstDayOfThisYear.subtract(const Duration(days: 1));
        final firstDayOfPreviousYear = DateTime(now.year - 1, 1, 1);
        return (from: firstDayOfPreviousYear, to: lastDayOfPreviousYear);
    }
  }
}
