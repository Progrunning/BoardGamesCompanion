import 'package:hive/hive.dart';

import '../../common/hive_boxes.dart';

part 'board_game_artist.g.dart';

@HiveType(typeId: HiveBoxes.BoardGamesArtistTypeId)
class BoardGameArtist {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
}
