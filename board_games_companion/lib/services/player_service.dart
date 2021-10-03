import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart' show Uuid;

import '../common/hive_boxes.dart' show HiveBoxes;
import '../models/hive/player.dart';
import 'file_service.dart';
import 'hive_base_service.dart';

@singleton
class PlayerService extends BaseHiveService<Player> {
  PlayerService(this.fileService);

  final RegExp _fileExtensionRegex = RegExp(r'\.[0-9a-z]+$', caseSensitive: false);

  final FileService fileService;

  Future<List<Player>> retrievePlayers({
    List<String>? playerIds,
    bool includeDeleted = false,
  }) async {
    if (!await ensureBoxOpen(HiveBoxes.Players)) {
      return <Player>[];
    }

    final List<Player> players = storageBox
        .toMap()
        .values
        .where((Player player) =>
            (playerIds?.contains(player.id) ?? true) &&
            (includeDeleted || !(player.isDeleted ?? false)))
        .toList();

    for (final Player player in players) {
      if (player.avatarFileName?.isNotEmpty ?? false) {
        player.avatarImageUri = await fileService.createDocumentsFilePath(player.avatarFileName!);
      }
    }

    return players;
  }

  Future<bool> addOrUpdatePlayer(Player player) async {
    if ((player?.name?.isEmpty ?? true) || !await ensureBoxOpen(HiveBoxes.Players)) {
      return false;
    }

    if (player.id?.isEmpty ?? true) {
      player.id = uuid.v4();
    }

    if (player.avatarFileToSave != null) {
      final File? savedAvatarImage = await saveAvatar(player);
      if (savedAvatarImage == null) {
        return false;
      }
    }

    final existingPlayer = storageBox.get(player.id);

    if ((existingPlayer?.avatarFileName?.isNotEmpty ?? false) &&
        player.avatarFileName != existingPlayer?.avatarFileName) {
      await deleteAvatar(existingPlayer!.avatarFileName!);
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

    final playerToDelete = storageBox.get(playerId);
    if (playerToDelete == null || (playerToDelete.isDeleted ?? false)) {
      return false;
    }

    playerToDelete.isDeleted = true;

    await storageBox.put(playerId, playerToDelete);

    return true;
  }

  Future<File?> saveAvatar(Player player) async {
    if (player?.avatarFileToSave == null) {
      return null;
    }

    final avatarImageName = Uuid().v4();
    String? avatarImageNameFileExtension = '.jpg';
    if (_fileExtensionRegex.hasMatch(player.avatarFileToSave!.path)) {
      avatarImageNameFileExtension =
          _fileExtensionRegex.firstMatch(player.avatarFileToSave!.path)!.group(0);
    }

    player.avatarFileName = '$avatarImageName$avatarImageNameFileExtension';

    return fileService.saveToDocumentsDirectory(player.avatarFileName!, player.avatarFileToSave!);
  }

  Future<bool> deleteAvatar(String avatarFileName) async {
    return fileService.deleteFileFromDocumentsDirectory(avatarFileName);
  }
}
