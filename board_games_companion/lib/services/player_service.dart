import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../common/constants.dart';
import '../common/hive_boxes.dart';
import '../models/hive/player.dart';
import 'file_service.dart';
import 'hive_base_service.dart';

class PlayerService extends BaseHiveService<Player> {
  final _fileExtensionRegex = RegExp(r'\.[0-9a-z]+$', caseSensitive: false);

  final FileService fileService;

  PlayerService(this.fileService);

  Future<List<Player>> retrievePlayers([List<String> playerIds]) async {
    if (!await ensureBoxOpen(HiveBoxes.Players)) {
      return List<Player>();
    }

    var players = storageBox
        ?.toMap()
        ?.values
        ?.where((player) =>
            !(player.isDeleted ?? false) &&
            (playerIds?.contains(player.id) ?? true))
        ?.toList();

  // TODO MK Think how this will affect existing users?
    final applicationDocumentsDirectory =
        await fileService.getApplicationDocumentsDirectory();

    players.forEach((player) {
      player.imageUri = '${applicationDocumentsDirectory.path}/${player.imageUri}';
    });

    return players;
  }

  Future<bool> addOrUpdatePlayer(Player player, String currentAvatarUri) async {
    if ((player?.name?.isEmpty ?? true) ||
        !await ensureBoxOpen(HiveBoxes.Players)) {
      return false;
    }

    if (player.id?.isEmpty ?? true) {
      player.id = uuid.v4();
    }

    if (player.imageUri != Constants.DefaultAvatartAssetsPath &&
        (currentAvatarUri != player.imageUri ||
            !await fileService.fileExists(player.imageUri))) {
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
    if (_fileExtensionRegex.hasMatch(avatarImage.path)) {
      avatarImageNameFileExtension =
          _fileExtensionRegex.firstMatch(avatarImage.path).group(0);
    }

    final fileName = '$avatarImageName$avatarImageNameFileExtension';

    return await fileService.saveToDocumentsDirectory(fileName, avatarImage);
  }

  Future<bool> deleteAvatar(String avatarUri) async {
    return await fileService.deleteFile(avatarUri);
  }
}
