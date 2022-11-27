// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/services/search_service.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../models/hive/search_history_entry.dart';

part 'search_store.g.dart';

@singleton
class SearchStore = _SearchStore with _$SearchStore;

abstract class _SearchStore with Store {
  _SearchStore(this._searchService);

  final SearchService _searchService;

  @observable
  ObservableList<SearchHistoryEntry> searchHistory = <SearchHistoryEntry>[].asObservable();

  @action
  Future<void> loadSearchHistory() async =>
      searchHistory = (await _searchService.retrieveSearchHistory()).asObservable();

  @action
  Future<void> addOrUpdateScore(SearchHistoryEntry searchHistoryEntry) async {
    final operationSucceeded = await _searchService.addOrUpdateScore(searchHistoryEntry);
    if (operationSucceeded) {
      final entryIndex = searchHistory
          .indexWhere((SearchHistoryEntry entry) => entry.query == searchHistoryEntry.query);
      if (entryIndex == -1) {
        searchHistory.add(searchHistoryEntry);
      } else {
        searchHistory[entryIndex] = searchHistoryEntry;
      }
    }
  }
}
