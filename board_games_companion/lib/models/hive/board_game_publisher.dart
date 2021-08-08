import 'package:hive/hive.dart';

import '../../common/hive_boxes.dart';

part 'board_game_publisher.g.dart';

@HiveType(typeId: HiveBoxes.BoardGamesPublisherTypeId)
class BoardGamePublisher {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
}
