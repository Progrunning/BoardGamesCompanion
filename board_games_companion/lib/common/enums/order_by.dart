import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:hive/hive.dart';

part 'order_by.g.dart';

@HiveType(typeId: HiveBoxes.OrderByTypeId)
enum OrderBy {
  @HiveField(0)
  Ascending,
  @HiveField(1)
  Descending,
}
