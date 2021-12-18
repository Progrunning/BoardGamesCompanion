import 'package:hive/hive.dart';

import '../../common/hive_boxes.dart';

part 'score.g.dart';

@HiveType(typeId: HiveBoxes.ScoreTypeId)
class Score {
  Score({
    required this.id,
    required this.playerId,
    required this.boardGameId,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  String? playthroughId;
  @HiveField(2)
  String playerId;
  @HiveField(3)
  String boardGameId;

  @HiveField(4)
  String? value;

  int get valueInt => int.tryParse(value ?? '0') ?? 0;
}
