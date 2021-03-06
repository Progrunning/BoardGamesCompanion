import 'package:hive/hive.dart';

import '../hive_boxes.dart';

part 'sort_by_option.g.dart';

@HiveType(typeId: HiveBoxes.SortByOptionTypeId)
enum SortByOption {
  @HiveField(0)
  Name,
  @HiveField(1)
  YearPublished,
  @HiveField(2)
  LastUpdated,
  @HiveField(3)
  Rank,
  @HiveField(4)
  NumberOfPlayers,
  @HiveField(5)
  Playtime,
  @HiveField(6)
  Rating
}
