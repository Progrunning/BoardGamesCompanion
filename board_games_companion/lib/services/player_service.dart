import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/services/hide_base_service.dart';

class PlayerService extends BaseHiveService<Player> {
  Future<List<Player>> retrievePlayers([List<String> playerIds]) async {
    if (!await ensureBoxOpen(HiveBoxes.Players)) {
      return List<Player>();
    }

    return storageBox
        ?.toMap()
        ?.values
        ?.where((player) =>
            !(player.isDeleted ?? false) &&
            (playerIds?.contains(player.id) ?? true))
        ?.toList();
  }

  Future<bool> addOrUpdatePlayer(Player player) async {
    if (player?.name?.isEmpty ?? true) {
      return false;
    }

    if (player.id?.isEmpty ?? true) {
      player.id = uuid.v4();
    }

    if (!await ensureBoxOpen(HiveBoxes.Players)) {
      return false;
    }

    await storageBox.put(player.id, player);

    return true;
  }

  Future<bool> deletePlayer(String playerId) async {
    if (playerId?.isEmpty ?? true) {
      return false;
    }

    if (!await ensureBoxOpen(HiveBoxes.Players)) {
      return false;
    }

    var playerToDelete = storageBox.get(playerId);
    if (playerToDelete == null || (playerToDelete.isDeleted ?? false)) {
      return false;
    }

    playerToDelete.isDeleted = true;

    await storageBox.put(playerId, playerToDelete);

    return true;
  }
}
