import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/player.dart';
import 'package:board_games_companion/services/hide_base_service.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class PlayerService extends BaseHiveService {
  static final PlayerService _instance = new PlayerService._createInstance();

  factory PlayerService() {
    return _instance;
  }

  PlayerService._createInstance();

  final _uuid = Uuid();

  Future<List<Player>> retrievePlayers() async {
    var boardGamesBox = await Hive.openBox<Player>(HiveBoxes.Players);

    return boardGamesBox.toMap()?.values?.toList();
  }

  Future<bool> addOrUpdatePlayer(Player player) async {
    if (player?.name?.isEmpty ?? true) {
      return false;
    }

    if (player.id?.isEmpty ?? true) {
      player.id = _uuid.v4();
    }

    var boardGamesBox = await Hive.openBox<Player>(HiveBoxes.Players);
    await boardGamesBox.put(player.id, player);

    return true;
  }

  Future<bool> deletePlayer(String playerId) async {
    if (playerId?.isEmpty ?? true) {
      return false;
    }

    var playersBox = await Hive.openBox<Player>(HiveBoxes.Players);
    var playerToDelete = playersBox.get(playerId);
    if (playerToDelete == null || (playerToDelete.isDeleted ?? false)) {
      return false;
    }

    playerToDelete.isDeleted = true;

    await playersBox.put(playerId, playerToDelete);

    return true;
  }
}
