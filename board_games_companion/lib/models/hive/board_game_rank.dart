import 'package:hive/hive.dart';

import '../../common/hive_boxes.dart';

part 'board_game_rank.g.dart';

@HiveType(typeId: HiveBoxes.BoardGamesrankTypeId)
class BoardGameRank {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String type;
  @HiveField(3)
  String friendlyName;
  @HiveField(4)
  num rank;
}
