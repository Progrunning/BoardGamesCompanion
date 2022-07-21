import 'package:hive/hive.dart';

import '../../common/hive_boxes.dart';

part 'board_game_artist.g.dart';

@HiveType(typeId: HiveBoxes.boardGamesArtistTypeId)
class BoardGameArtist {
  BoardGameArtist({required this.id, required this.name});

  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
}
