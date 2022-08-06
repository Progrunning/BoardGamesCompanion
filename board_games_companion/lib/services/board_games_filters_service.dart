import 'package:injectable/injectable.dart';

import '../common/hive_boxes.dart';
import '../models/collection_filters.dart';
import 'hive_base_service.dart';

@singleton
class BoardGamesFiltersService extends BaseHiveService<CollectionFilters> {
  static const String _collectionFiltersPreferenceKey = 'collectionFilters';

  Future<CollectionFilters?> retrieveCollectionFiltersPreferences() async {
    if (!await ensureBoxOpen(HiveBoxes.collectionFilters)) {
      return null;
    }

    if (storageBox.values.isEmpty) {
      return null;
    }

    return storageBox.get(_collectionFiltersPreferenceKey);
  }

  Future<bool> addOrUpdateCollectionFilters(CollectionFilters? collectionFilters) async {
    if (collectionFilters == null) {
      return false;
    }

    if (!await ensureBoxOpen(HiveBoxes.collectionFilters)) {
      return false;
    }

    await storageBox.put(_collectionFiltersPreferenceKey, collectionFilters);

    return true;
  }

  Future<void> clearFilters() async {
    await storageBox.delete(_collectionFiltersPreferenceKey);
  }
}
