// ignore_for_file: library_private_types_in_public_api

import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../common/analytics.dart';
import '../common/constants.dart';
import '../common/enums/order_by.dart';
import '../common/enums/sort_by_option.dart';
import '../models/collection_filters.dart';
import '../models/sort_by.dart';
import '../services/analytics_service.dart';
import '../services/board_games_filters_service.dart';

part 'board_games_filters_store.g.dart';

@singleton
class BoardGamesFiltersStore = _BoardGamesFiltersStore with _$BoardGamesFiltersStore;

abstract class _BoardGamesFiltersStore with Store {
  _BoardGamesFiltersStore(
    this._boardGamesFiltersService,
    this._analyticsService,
  );

  final BoardGamesFiltersService _boardGamesFiltersService;
  final AnalyticsService _analyticsService;

  @observable
  CollectionFilters? _collectionFilters;

  @observable
  ObservableList<SortBy> sortByOptions = ObservableList.of([
    SortBy(sortByOption: SortByOption.Name),
    SortBy(sortByOption: SortByOption.YearPublished),
    SortBy(sortByOption: SortByOption.LastUpdated)..selected = true,
    SortBy(sortByOption: SortByOption.Rank),
    SortBy(sortByOption: SortByOption.Playtime),
    SortBy(sortByOption: SortByOption.Rating),
  ]);

  @computed
  double? get filterByRating => _collectionFilters?.filterByRating;

  @computed
  int? get numberOfPlayers => _collectionFilters?.numberOfPlayers;

  @computed
  bool get anyFiltersApplied => filterByRating != null || numberOfPlayers != null;

  @action
  Future<void> loadFilterPreferences() async {
    _collectionFilters = await _boardGamesFiltersService.retrieveCollectionFiltersPreferences();
    if (_collectionFilters == null) {
      return;
    }

    _updateSortBy();
  }

  @action
  Future<void> clearFilters() async {
    await _boardGamesFiltersService.clearFilters();
    _collectionFilters = null;
  }

  @action
  Future<void> updateSortBySelection(SortBy sortBy) async {
    // MK If already selected, update ordering direction
    if (sortBy.selected) {
      if (sortBy.orderBy == OrderBy.Ascending) {
        sortBy.orderBy = OrderBy.Descending;
      } else {
        sortBy.orderBy = OrderBy.Ascending;
      }
    }

    for (final sb in sortByOptions) {
      sb.selected = false;
    }

    sortBy.selected = true;

    _collectionFilters ??= CollectionFilters();

    await _analyticsService.logEvent(
      name: Analytics.sortCollection,
      parameters: <String, String?>{
        Analytics.sortByParameter: sortBy.name,
        Analytics.orderByParameter: sortBy.orderBy.toString()
      },
    );
    _collectionFilters!.sortBy = sortBy;

    await _boardGamesFiltersService.addOrUpdateCollectionFilters(_collectionFilters);
  }

  @action
  Future<void> updateFilterByRating(double? filterByRating) async {
    _collectionFilters ??= CollectionFilters();

    _collectionFilters!.filterByRating = filterByRating;

    await _analyticsService.logEvent(
      name: Analytics.filterCollection,
      parameters: <String, dynamic>{
        Analytics.filterByParameter: 'rating',
        Analytics.filterByValueParameter: filterByRating ?? Constants.filterByAny
      },
    );

    await _boardGamesFiltersService.addOrUpdateCollectionFilters(_collectionFilters);
  }

  @action
  Future<void> changeNumberOfPlayers(int? numberOfPlayers) async {
    _collectionFilters ??= CollectionFilters();

    _collectionFilters!.numberOfPlayers = numberOfPlayers;
  }

  @action
  Future<void> updateNumberOfPlayersFilter() async {
    await _analyticsService.logEvent(
      name: Analytics.filterCollection,
      parameters: <String, dynamic>{
        Analytics.filterByParameter: 'number_of_players',
        Analytics.filterByValueParameter: filterByRating ?? Constants.filterByAny,
      },
    );

    await _boardGamesFiltersService.addOrUpdateCollectionFilters(_collectionFilters);
  }

  void _updateSortBy() {
    for (final sb in sortByOptions) {
      sb.selected = false;
    }

    final SortBy? selectedSortBy =
        sortByOptions.firstWhereOrNull((sb) => sb.name == _collectionFilters?.sortBy?.name);

    if (selectedSortBy != null) {
      selectedSortBy.orderBy = _collectionFilters!.sortBy!.orderBy;
      selectedSortBy.selected = _collectionFilters!.sortBy!.selected;
    }
  }
}
