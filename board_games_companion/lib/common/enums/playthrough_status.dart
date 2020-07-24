import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:hive/hive.dart';

part 'playthrough_status.g.dart';

@HiveType(typeId: HiveBoxes.PlaythroughStatusTypeId)
enum PlaythroughStatus {
  @HiveField(0)
  Started,
  @HiveField(1)
  Finished,
}
