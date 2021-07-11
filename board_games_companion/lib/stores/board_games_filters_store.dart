import 'package:flutter/foundation.dart';

import '../common/analytics.dart';
import '../common/constants.dart';
import '../common/enums/order_by.dart';
import '../common/enums/sort_by_option.dart';
import '../common/hive_boxes.dart';
import '../models/collection_filters.dart';
import '../models/sort_by.dart';
import '../services/analytics_service.dart';
import '../services/board_games_filters_service.dart';

class BoardGamesFiltersStore with ChangeNotifier {
  List<SortBy> _sortBy = [
    SortBy()..sortByOption = SortByOption.Name,
    SortBy()..sortByOption = SortByOption.YearPublished,
    SortBy()
      ..sortByOption = SortByOption.LastUpdated
      ..selected = true,
    SortBy()..sortByOption = SortByOption.Rank,
    SortBy()..sortByOption = SortByOption.Playtime,
    SortBy()..sortByOption = SortByOption.Rating,
  ];

  final BoardGamesFiltersService _boardGamesFiltersService;
  final AnalyticsService _analyticsService;

  CollectionFilters _collectionFilters;

  List<SortBy> get sortBy => _sortBy;
  double get filterByRating => _collectionFilters?.filterByRating;
  int get numberOfPlayers => _collectionFilters?.numberOfPlayers;

  BoardGamesFiltersStore(
    this._boardGamesFiltersService,
    this._analyticsService,
  );

  Future<void> loadFilterPreferences() async {
    _collectionFilters =
        await _boardGamesFiltersService.retrieveCollectionFiltersPreferences();
    if (_collectionFilters == null) {
      notifyListeners();
      return;
    }

    _updateSortBy();

    notifyListeners();
  }

  void _updateSortBy() {
    _sortBy.forEach((sb) {
      sb.selected = false;
    });

    final selectedSortBy = _sortBy.firstWhere(
        (sb) => sb.name == _collectionFilters?.sortBy?.name, orElse: () {
      return null;
    });

    if (selectedSortBy != null) {
      selectedSortBy.orderBy = _collectionFilters.sortBy.orderBy;
      selectedSortBy.selected = _collectionFilters.sortBy.selected;
    }
  }

  Future<void> updateSortBySelection(SortBy sortBy) async {
    // MK If already selected, update ordering direction
    if (sortBy.selected) {
      if (sortBy.orderBy == OrderBy.Ascending) {
        sortBy.orderBy = OrderBy.Descending;
      } else {
        sortBy.orderBy = OrderBy.Ascending;
      }
    }

    _sortBy.forEach((sb) => sb.selected = false);
    sortBy.selected = true;

    if (_collectionFilters == null) {
      _collectionFilters = CollectionFilters();
    }

    await _analyticsService.logEvent(
      name: Analytics.SortCollection,
      parameters: {
        Analytics.SortByParameter: sortBy.name,
        Analytics.OrderByParameter: sortBy.orderBy.toString()
      },
    );

    _collectionFilters.sortBy = sortBy;

    await _boardGamesFiltersService
        .addOrUpdateCollectionFilters(_collectionFilters);

    notifyListeners();
  }

  Future<void> updateFilterByRating(double filterByRating) async {
    if (_collectionFilters == null) {
      _collectionFilters = CollectionFilters();
    }

    _collectionFilters.filterByRating = filterByRating;

    await _analyticsService.logEvent(
      name: Analytics.FilterCollection,
      parameters: {
        Analytics.FilterByParameter: 'rating',
        Analytics.FilterByValueParameter:
            filterByRating ?? Constants.FilterByAny
      },
    );

    await _boardGamesFiltersService
        .addOrUpdateCollectionFilters(_collectionFilters);

    notifyListeners();
  }

  Future<void> changeNumberOfPlayers(int numberOfPlayers) async {
    if (_collectionFilters == null) {
      _collectionFilters = CollectionFilters();
    }

    _collectionFilters.numberOfPlayers = numberOfPlayers;

    notifyListeners();
  }

  Future<void> updateNumberOfPlayers(int numberOfPlayers) async {
    await _analyticsService.logEvent(
      name: Analytics.FilterCollection,
      parameters: {
        Analytics.FilterByParameter: 'number_of_players',
        Analytics.FilterByValueParameter:
            filterByRating ?? Constants.FilterByAny,
      },
    );

    await _boardGamesFiltersService
        .addOrUpdateCollectionFilters(_collectionFilters);
  }

  @override
  void dispose() {
    _boardGamesFiltersService.closeBox(HiveBoxes.CollectionFilters);

    super.dispose();
  }
}
