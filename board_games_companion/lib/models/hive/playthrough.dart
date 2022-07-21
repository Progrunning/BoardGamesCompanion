import 'package:hive/hive.dart';

import '../../common/enums/playthrough_status.dart';
import '../../common/hive_boxes.dart';

part 'playthrough.g.dart';

@HiveType(typeId: HiveBoxes.playthroughTypeId)
class Playthrough {
  Playthrough({
    required this.id,
    required this.boardGameId,
    required this.playerIds,
    required this.scoreIds,
    required this.startDate,
    this.bggPlayId,
  });

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
  DateTime? endDate;
  @HiveField(6)
  PlaythroughStatus? status;
  @HiveField(7)
  bool? isDeleted = false;
  @HiveField(8)
  int? bggPlayId;
}
