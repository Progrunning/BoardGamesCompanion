import 'package:board_games_companion/common/enums/order_by.dart';
import 'package:board_games_companion/common/enums/sort_by_option.dart';
import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/collection_filters.dart';
import 'package:board_games_companion/models/sort_by.dart';
import 'package:board_games_companion/services/board_games_filters_service.dart';
import 'package:flutter/foundation.dart';

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

  CollectionFilters _collectionFilters;

  List<SortBy> get sortBy => _sortBy;
  double get filterByRating => _collectionFilters?.filterByRating;

  BoardGamesFiltersStore(this._boardGamesFiltersService);

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

    _collectionFilters.sortBy = sortBy;

    await _boardGamesFiltersService.addOrUpdateUser(_collectionFilters);

    notifyListeners();
  }

  Future<void> updateFilterByRating(double filterByRating) async {
    if (_collectionFilters == null) {
      _collectionFilters = CollectionFilters();
    }

    _collectionFilters.filterByRating = filterByRating;

    await _boardGamesFiltersService.addOrUpdateUser(_collectionFilters);

    notifyListeners();
  }

  @override
  void dispose() {
    _boardGamesFiltersService.closeBox(HiveBoxes.CollectionFilters);

    super.dispose();
  }
}
