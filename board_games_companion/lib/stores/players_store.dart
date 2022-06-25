import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/services/player_service.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@singleton
class PlayersStore with ChangeNotifier {
  PlayersStore(this._playerService);

  final PlayerService _playerService;

  List<Player> players = [];

  Future<List<Player>> loadPlayers() async {
    if (players.isNotEmpty) {
      return players;
    }

    try {
      players = await _playerService.retrievePlayers();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return players;
  }

  Future<bool> createOrUpdatePlayer(Player player) async {
    try {
      final existingPlayer = players.firstWhereOrNull(
        (p) => p.id == player.id,
      );
      final addOrUpdateSucceeded = await _playerService.addOrUpdatePlayer(player);
      if (addOrUpdateSucceeded) {
        if (existingPlayer == null) {
          players.add(player);
        } else {
          existingPlayer.id = player.id;
          existingPlayer.avatarFileName = player.avatarFileName;
          existingPlayer.avatarImageUri = player.avatarImageUri;
          existingPlayer.name = player.name;
          existingPlayer.bggName = player.bggName;
        }

        notifyListeners();
      }

      return addOrUpdateSucceeded;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }

  Future<bool> deletePlayer(String playerId) async {
    try {
      final deleteSucceeded = await _playerService.deletePlayer(playerId);
      if (deleteSucceeded) {
        players.removeWhere((p) => p.id == playerId);
        notifyListeners();
      }

      return deleteSucceeded;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }

  @override
  void dispose() {
    _playerService.closeBox(HiveBoxes.Players);

    super.dispose();
  }
}
