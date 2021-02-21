import 'dart:io';

import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/services/file_service.dart';
import 'package:board_games_companion/services/hive_base_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class PlayerService extends BaseHiveService<Player> {
  final _fileExtensionRegiex = RegExp(r'\.[0-9a-z]+$', caseSensitive: false);

  final FileService fileService;

  PlayerService(this.fileService);

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

  Future<bool> addOrUpdatePlayer(Player player, String currentAvatarUri) async {
    if ((player?.name?.isEmpty ?? true) ||
        !await ensureBoxOpen(HiveBoxes.Players)) {
      return false;
    }

    if (player.id?.isEmpty ?? true) {
      player.id = uuid.v4();
    }

    if (currentAvatarUri != player.imageUri ||
        !await fileService.fileExists(player.imageUri)) {
      var savedAvatarImage = await saveAvatar(player.avatarFileToSave);
      if (savedAvatarImage == null) {
        return false;
      }
    }

    if ((currentAvatarUri?.isEmpty ?? false) &&
        player.imageUri != currentAvatarUri) {
      await deleteAvatar(currentAvatarUri);
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

  Future<File> saveAvatar(PickedFile avatarImage) async {
    final avatarImageName = Uuid().v4();
    var avatarImageNameFileExtension = '.jpg';
    if (_fileExtensionRegiex.hasMatch(avatarImage.path)) {
      avatarImageNameFileExtension =
          _fileExtensionRegiex.firstMatch(avatarImage.path).group(0);
    }

    final fileName = '$avatarImageName$avatarImageNameFileExtension';

    return await fileService.saveToDocumentsDirectory(fileName, avatarImage);
  }

  Future<bool> deleteAvatar(String avatarUri) async {
    return await fileService.deleteFile(avatarUri);
  }
}
