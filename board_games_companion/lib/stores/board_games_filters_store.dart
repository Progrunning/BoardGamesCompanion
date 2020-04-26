import 'package:board_games_companion/common/enums/sort_by_option.dart';
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

  List<SortBy> get sortBy => _sortBy;

  BoardGamesFiltersStore(this._boardGamesFiltersService);

  Future<void> loadSortByPreferences() async {
    final selectedSortByPreference =
        await _boardGamesFiltersService.retrieveSelectedSortByPreference();
    if (selectedSortByPreference == null) {
      notifyListeners();
      return;
    }

    _sortBy.forEach((sb) {
      sb.selected = false;
    });

    final selectedSortBy = _sortBy.firstWhere(
        (sb) => sb.name == selectedSortByPreference.name, orElse: () {
      return null;
    });

    if (selectedSortBy != null) {
      selectedSortBy.orderBy = selectedSortByPreference.orderBy;
      selectedSortBy.selected = selectedSortByPreference.selected;
    }

    notifyListeners();
  }

  Future<void> updateSelection(SortBy sortBy) async {
    _sortBy.forEach((sb) => sb.selected = false);
    sortBy.selected = true;

    await _boardGamesFiltersService.addOrUpdateUser(sortBy);

    notifyListeners();
  }
}
