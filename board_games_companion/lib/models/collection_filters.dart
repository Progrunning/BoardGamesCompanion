import 'package:hive/hive.dart';

import '../common/hive_boxes.dart';
import 'sort_by.dart';

part 'collection_filters.g.dart';

@HiveType(typeId: HiveBoxes.collectionFiltersId)
class CollectionFilters {
  @HiveField(0)
  SortBy? sortBy;

  @HiveField(1)
  double? filterByRating;

  @HiveField(2)
  int? numberOfPlayers;
}
