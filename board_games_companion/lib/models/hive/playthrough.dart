import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:hive/hive.dart';

part 'playthrough.g.dart';

@HiveType(typeId: HiveBoxes.PlaythroughTypeId)
class Playthrough {
  @HiveField(0)
  String id;
  @HiveField(1)
  String boardGameId;
  @HiveField(2)
  List<String> playerIds;
  @HiveField(3)
  List<String> scoreIds;

  @HiveField(4)
  DateTime startDate;
  @HiveField(5)
  DateTime endDate;
  @HiveField(6)
  PlaythroughStatus status;
  @HiveField(7)
  bool isDeleted;
}