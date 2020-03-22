import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:hive/hive.dart';

part 'player.g.dart';

@HiveType(typeId: HiveBoxes.PlayersTypeId)
class Player {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String imageUri;
  @HiveField(3)
  bool isDeleted;
}
