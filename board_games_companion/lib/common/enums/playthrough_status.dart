import 'package:hive/hive.dart';

import '../hive_boxes.dart';

part 'playthrough_status.g.dart';

@HiveType(typeId: HiveBoxes.PlaythroughStatusTypeId)
enum PlaythroughStatus {
  @HiveField(0)
  Started,
  @HiveField(1)
  Finished,
}
