import 'package:basics/basics.dart';
import 'package:injectable/injectable.dart';

import '../models/hive/search_history_entry.dart';
import 'hive_base_service.dart';

@singleton
class SearchService extends BaseHiveService<SearchHistoryEntry, SearchService> {
  SearchService(super.hive);

  Future<bool> addOrUpdateEntry(SearchHistoryEntry searchHistoryEntry) async {
    if (!await ensureBoxOpen()) {
      return false;
    }

    await storageBox.put(searchHistoryEntry.query, searchHistoryEntry);

    return true;
  }

  Future<List<SearchHistoryEntry>> retrieveSearchHistory({String? searchPhrase}) async {
    if (!await ensureBoxOpen()) {
      return <SearchHistoryEntry>[];
    }

    return storageBox
        .toMap()
        .values
        .where((entry) => searchPhrase.isNullOrBlank || entry.query.contains(searchPhrase!))
        .toList();
  }
}
