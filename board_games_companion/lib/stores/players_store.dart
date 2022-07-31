// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/services/player_service.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'players_store.g.dart';

@singleton
class PlayersStore = _PlayersStore with _$PlayersStore;

abstract class _PlayersStore with Store {
  _PlayersStore(this._playerService);

  final PlayerService _playerService;

  @observable
  ObservableList<Player> players = ObservableList.of([]);

  @action
  Future<void> loadPlayers() async {
    if (players.isNotEmpty) {
      return;
    }

    try {
      players = ObservableList.of(await _playerService.retrievePlayers());
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  @action
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
      }

      return addOrUpdateSucceeded;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }

  @action
  Future<bool> deletePlayer(String playerId) async {
    try {
      final deleteSucceeded = await _playerService.deletePlayer(playerId);
      if (deleteSucceeded) {
        players.removeWhere((p) => p.id == playerId);
      }

      return deleteSucceeded;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }
}
