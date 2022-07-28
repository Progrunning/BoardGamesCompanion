import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';

import '../common/hive_boxes.dart';
import 'sort_by.dart';

part 'collection_filters.g.dart';

@HiveType(typeId: HiveBoxes.collectionFiltersId)
class CollectionFilters = _CollectionFilters with _$CollectionFilters;

abstract class _CollectionFilters with Store {
  @HiveField(0)
  @observable
  SortBy? sortBy;

  @HiveField(1)
  @observable
  double? filterByRating;

  @HiveField(2)
  @observable
  int? numberOfPlayers;
}
