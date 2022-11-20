// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/services/player_service.dart';
import 'package:board_games_companion/stores/app_store.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'players_store.g.dart';

@singleton
class PlayersStore = _PlayersStore with _$PlayersStore;

abstract class _PlayersStore with Store {
  _PlayersStore(
    this._playerService,
    this._appStore,
  ) {
    // MK When restoring a backup, reload players
    reaction((_) => _appStore.backupRestored, (bool? backupRestored) async {
      if (backupRestored ?? false) {
        await loadPlayers();
      }
    });
  }

  final PlayerService _playerService;
  final AppStore _appStore;

  @observable
  ObservableList<Player> players = ObservableList.of([]);

  @computed
  List<Player> get activePlayers =>
      players.where((player) => !(player.isDeleted ?? false)).toList();

  @computed
  Map<String, Player> get playersById => {for (final player in players) player.id: player};

  @action
  Future<void> loadPlayers() async {
    if (players.isNotEmpty) {
      return;
    }

    try {
      players = ObservableList.of(await _playerService.retrievePlayers(includeDeleted: true));
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  @action
  Future<bool> createOrUpdatePlayer(Player player) async {
    try {
      final existingPlayerIndex = players.indexWhere((p) => p.id == player.id);
      final addOrUpdateSucceeded = await _playerService.addOrUpdatePlayer(player);
      if (addOrUpdateSucceeded) {
        if (existingPlayerIndex == -1) {
          players.add(player);
        } else {
          players[existingPlayerIndex] = player;
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
