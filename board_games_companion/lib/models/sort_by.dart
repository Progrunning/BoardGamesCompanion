import 'package:board_games_companion/common/enums/order_by.dart';
import 'package:board_games_companion/common/enums/sort_by_option.dart';
import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:hive/hive.dart';

part 'sort_by.g.dart';

@HiveType(typeId: HiveBoxes.SortByTypeId)
class SortBy {
  @HiveField(0)
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
    }

    return null;
  }

  @HiveField(1)
  OrderBy orderBy = OrderBy.Ascending;
  @HiveField(2)
  bool selected = false;
}
