import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/sort_by.dart';
import 'package:board_games_companion/services/hide_base_service.dart';

class BoardGamesFiltersService extends BaseHiveService<SortBy> {
  static const String _selectedSortPreferenceKey = "sortBy";

  Future<SortBy> retrieveSelectedSortByPreference() async {
    if (!await ensureBoxOpen(HiveBoxes.SortBy)) {
      return null;
    }

    if (storageBox?.values?.isEmpty ?? true) {
      return null;
    }

    return storageBox.get(_selectedSortPreferenceKey);
  }

  Future<bool> addOrUpdateUser(SortBy sortBy) async {
    if (sortBy?.name?.isEmpty ?? true) {
      return false;
    }

    if (!await ensureBoxOpen(HiveBoxes.SortBy)) {
      return false;
    }

    await storageBox.put(_selectedSortPreferenceKey, sortBy);

    return true;
  }
}
