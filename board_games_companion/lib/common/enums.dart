import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:hive/hive.dart';

part 'enums.g.dart';

enum MedalEnum {
  Gold,
  Silver,
  Bronze,
}

enum LoadDataState {
  None,
  Loading,
  Loaded,
  Error,
}

@HiveType(typeId: HiveBoxes.PlaythroughStatusTypeId)
enum PlaythroughStatus {
  @HiveField(0)
  Started,
  @HiveField(1)
  Finished,
}
