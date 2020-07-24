import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:hive/hive.dart';

part 'score.g.dart';

@HiveType(typeId: HiveBoxes.ScoreTypeId)
class Score {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String playthroughId;
  @HiveField(2)
  String playerId;
  @HiveField(3)
  String boardGameId;

  @HiveField(4)
  String value;

  @HiveField(5)
  String isDeleted;
}
