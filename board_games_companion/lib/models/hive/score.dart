import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:hive/hive.dart';

part 'score.g.dart';

@HiveType(typeId: HiveBoxes.ScoreTypeId)
class Score {
  @HiveField(0)
  String id;
  @HiveField(1)
  String playerId;
  @HiveField(2)
  String boardGameId;

  @HiveField(3)
  String value;
}
