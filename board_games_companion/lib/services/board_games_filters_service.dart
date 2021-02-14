import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/collection_filters.dart';
import 'package:board_games_companion/services/hive_base_service.dart';

class BoardGamesFiltersService extends BaseHiveService<CollectionFilters> {
  static const String _collectionFiltersPreferenceKey = "collectionFilters";

  Future<CollectionFilters> retrieveCollectionFiltersPreferences() async {
    if (!await ensureBoxOpen(HiveBoxes.CollectionFilters)) {
      return null;
    }

    if (storageBox?.values?.isEmpty ?? true) {
      return null;
    }

    return storageBox.get(_collectionFiltersPreferenceKey);
  }

  Future<bool> addOrUpdateCollectionFilters(
      CollectionFilters collectionFilters) async {
    if (collectionFilters == null) {
      return false;
    }

    if (!await ensureBoxOpen(HiveBoxes.CollectionFilters)) {
      return false;
    }

    await storageBox.put(_collectionFiltersPreferenceKey, collectionFilters);

    return true;
  }
}
