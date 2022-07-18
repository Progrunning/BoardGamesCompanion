import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../common/analytics.dart';
import '../common/constants.dart';
import '../common/enums/order_by.dart';
import '../common/enums/sort_by_option.dart';
import '../common/hive_boxes.dart';
import '../models/collection_filters.dart';
import '../models/sort_by.dart';
import '../services/analytics_service.dart';
import '../services/board_games_filters_service.dart';

@singleton
class BoardGamesFiltersStore with ChangeNotifier {
  BoardGamesFiltersStore(
    this._boardGamesFiltersService,
    this._analyticsService,
  );

  final List<SortBy> _sortBy = [
    SortBy(sortByOption: SortByOption.Name),
    SortBy(sortByOption: SortByOption.YearPublished),
    SortBy(sortByOption: SortByOption.LastUpdated)..selected = true,
    SortBy(sortByOption: SortByOption.Rank),
    SortBy(sortByOption: SortByOption.Playtime),
    SortBy(sortByOption: SortByOption.Rating),
  ];

  final BoardGamesFiltersService _boardGamesFiltersService;
  final AnalyticsService _analyticsService;

  CollectionFilters? _collectionFilters;

  List<SortBy> get sortBy => _sortBy;
  double? get filterByRating => _collectionFilters?.filterByRating;
  int? get numberOfPlayers => _collectionFilters?.numberOfPlayers;

  bool get anyFiltersApplied => filterByRating != null || numberOfPlayers != null;

  Future<void> loadFilterPreferences() async {
    _collectionFilters = await _boardGamesFiltersService.retrieveCollectionFiltersPreferences();
    if (_collectionFilters == null) {
      notifyListeners();
      return;
    }

    _updateSortBy();

    notifyListeners();
  }

  Future<void> clearFilters() async {
    await _boardGamesFiltersService.clearFilters();
    _collectionFilters = null;
    notifyListeners();
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

    for (final sb in _sortBy) {
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

    notifyListeners();
  }

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

    notifyListeners();
  }

  Future<void> changeNumberOfPlayers(int? numberOfPlayers) async {
    _collectionFilters ??= CollectionFilters();

    _collectionFilters!.numberOfPlayers = numberOfPlayers;

    notifyListeners();
  }

  Future<void> updateNumberOfPlayers(int? numberOfPlayers) async {
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
    for (final sb in _sortBy) {
      sb.selected = false;
    }

    final SortBy? selectedSortBy =
        _sortBy.firstWhereOrNull((sb) => sb.name == _collectionFilters?.sortBy?.name);

    if (selectedSortBy != null) {
      selectedSortBy.orderBy = _collectionFilters!.sortBy!.orderBy;
      selectedSortBy.selected = _collectionFilters!.sortBy!.selected;
    }
  }

  @override
  void dispose() {
    _boardGamesFiltersService.closeBox(HiveBoxes.collectionFilters);

    super.dispose();
  }
}
