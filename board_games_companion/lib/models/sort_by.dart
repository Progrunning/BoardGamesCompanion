// ignore_for_file: library_private_types_in_public_api

import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';

import '../common/enums/order_by.dart';
import '../common/enums/sort_by_option.dart';
import '../common/hive_boxes.dart';

part 'sort_by.g.dart';

@HiveType(typeId: HiveBoxes.sortByTypeId)
class SortBy = _SortBy with _$SortBy;

abstract class _SortBy with Store {
  _SortBy({required this.sortByOption});

  @HiveField(0)
  @observable
  SortByOption sortByOption;

  String get name {
    switch (sortByOption) {
      case SortByOption.Name:
        return 'Name';
      case SortByOption.YearPublished:
        return 'Year published';
      case SortByOption.LastUpdated:
        return 'Last updated';
      case SortByOption.Rank:
        return 'Rank';
      case SortByOption.NumberOfPlayers:
        return 'Number of players';
      case SortByOption.Playtime:
        return 'Playtime';
      case SortByOption.Rating:
        return 'Rating';
      case SortByOption.MostRecentlyPlayed:
        return 'Most recently played';
    }
  }

  @HiveField(1)
  @observable
  OrderBy orderBy = OrderBy.Ascending;

  @HiveField(2)
  @observable
  bool selected = false;
}
