import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart' show Uuid;

import '../models/hive/player.dart';
import 'file_service.dart';
import 'hive_base_service.dart';

@singleton
class PlayerService extends BaseHiveService<Player, PlayerService> {
  PlayerService(this.fileService);

  final RegExp _fileExtensionRegex = RegExp(r'\.[0-9a-z]+$', caseSensitive: false);

  final FileService fileService;

  Future<List<Player>> retrievePlayers({
    List<String>? playerIds,
    bool includeDeleted = false,
  }) async {
    if (!await ensureBoxOpen()) {
      return <Player>[];
    }

    final List<Player> players = storageBox
        .toMap()
        .values
        .where((Player player) =>
            (playerIds?.contains(player.id) ?? true) &&
            (includeDeleted || !(player.isDeleted ?? false)))
        .toList();

    for (var i = 0; i < players.length; i++) {
      final hasAvatarFileName = players[i].avatarFileName?.isNotEmpty ?? false;
      if (hasAvatarFileName) {
        final avatarImageUri =
            await fileService.createDocumentsFilePath(players[i].avatarFileName!);
        players[i] = players[i].copyWith(avatarImageUri: avatarImageUri);
      }
    }

    return players;
  }

  Future<bool> addOrUpdatePlayer(Player player) async {
    if ((player.name?.isEmpty ?? true) || !await ensureBoxOpen()) {
      return false;
    }

    if (player.id.isEmpty) {
      player = player.copyWith(id: uuid.v4());
    }

    if (player.avatarFileToSave != null) {
      player = await saveAvatar(player);
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
    if (playerId.isEmpty) {
      return false;
    }

    if (!await ensureBoxOpen()) {
      return false;
    }

    final playerToDelete = storageBox.get(playerId);
    if (playerToDelete == null || (playerToDelete.isDeleted ?? false)) {
      return false;
    }

    await storageBox.put(playerId, playerToDelete.copyWith(isDeleted: true));

    return true;
  }

  Future<Player> saveAvatar(Player player) async {
    if (player.avatarFileToSave == null) {
      return player;
    }

    final avatarImageName = const Uuid().v4();
    String? avatarImageNameFileExtension = '.jpg';
    if (_fileExtensionRegex.hasMatch(player.avatarFileToSave!.path)) {
      avatarImageNameFileExtension =
          _fileExtensionRegex.firstMatch(player.avatarFileToSave!.path)!.group(0);
    }

    final avatarFileName = '$avatarImageName$avatarImageNameFileExtension';
    final File? savedAvatarImage = await fileService.saveToDocumentsDirectory(
      avatarFileName,
      player.avatarFileToSave!,
    );

    if (savedAvatarImage == null) {
      return player;
    }

    return player.copyWith(avatarFileName: avatarFileName);
  }

  Future<bool> deleteAvatar(String avatarFileName) async {
    return fileService.deleteFileFromDocumentsDirectory(avatarFileName);
  }
}
