import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: HiveBoxes.UserTypeId)
class User {
  @HiveField(1)
  String name;
}
