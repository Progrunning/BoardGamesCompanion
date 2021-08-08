import 'package:hive/hive.dart';

import '../../common/hive_boxes.dart';

part 'board_game_category.g.dart';

@HiveType(typeId: HiveBoxes.BoardGamesCategoryTypeId)
class BoardGameCategory {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
}
