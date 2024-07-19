import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart' show Uuid;

import '../common/constants.dart';
import '../common/regex_expressions.dart';
import '../models/hive/player.dart';
import 'file_service.dart';
import 'hive_base_service.dart';

@singleton
class PlayerService extends BaseHiveService<Player, PlayerService> {
  PlayerService(super.hive, this.fileService);

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
      player = await _saveAvatar(player);
    }

    final existingPlayer = storageBox.get(player.id);

    if ((existingPlayer?.avatarFileName?.isNotEmpty ?? false) &&
        player.avatarFileName != existingPlayer?.avatarFileName) {
      await _deleteAvatar(existingPlayer!.avatarFileName!);
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

  Future<bool> restorePlayer(String playerId) async {
    if (playerId.isEmpty) {
      return false;
    }

    if (!await ensureBoxOpen()) {
      return false;
    }

    final playerToRestore = storageBox.get(playerId);
    if (playerToRestore == null || playerToRestore.isDeleted == false) {
      return false;
    }

    await storageBox.put(playerId, playerToRestore.copyWith(isDeleted: false));

    return true;
  }

  Future<Player> _saveAvatar(Player player) async {
    if (player.avatarFileToSave == null) {
      return player;
    }

    final imageName = const Uuid().v4();
    String? imageNameFileExtension = '.${Constants.jpgFileExtension}';
    if (RegexExpressions.findFileExtensionRegex.hasMatch(player.avatarFileToSave!.path)) {
      imageNameFileExtension = RegexExpressions.findFileExtensionRegex
          .firstMatch(player.avatarFileToSave!.path)!
          .group(0);
    }

    final fileName = '$imageName$imageNameFileExtension';
    final File? savedImage = await fileService.saveToDocumentsDirectory(
      fileName,
      player.avatarFileToSave!,
    );

    if (savedImage == null) {
      return player;
    }

    return player.copyWith(avatarFileName: fileName);
  }

  Future<bool> _deleteAvatar(String avatarFileName) async {
    return fileService.deleteFileFromDocumentsDirectory(avatarFileName);
  }
}
