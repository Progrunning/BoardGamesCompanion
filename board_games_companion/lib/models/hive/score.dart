import 'package:hive/hive.dart';

import '../../common/hive_boxes.dart';

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

  // TODO MK What is this used for?
  @HiveField(5)
  String isDeleted;
}
