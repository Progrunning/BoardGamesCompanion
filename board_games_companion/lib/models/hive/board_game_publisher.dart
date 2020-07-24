import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:hive/hive.dart';

part 'board_game_publisher.g.dart';

@HiveType(typeId: HiveBoxes.BoardGamesPublisherTypeId)
class BoardGamePublisher {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
}
