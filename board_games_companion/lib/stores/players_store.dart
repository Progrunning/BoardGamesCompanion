// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../models/hive/player.dart';
import '../services/player_service.dart';

part 'players_store.g.dart';

@singleton
class PlayersStore = _PlayersStore with _$PlayersStore;

abstract class _PlayersStore with Store {
  _PlayersStore(this._playerService);

  final PlayerService _playerService;

  @observable
  ObservableList<Player> players = ObservableList.of([]);

  @computed
  List<Player> get activePlayers =>
      players.where((player) => !(player.isDeleted ?? false)).toList();

  @computed
  List<Player> get deletedPlayers => players.where((player) => player.isDeleted ?? false).toList();

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
      return await _playerService.deletePlayer(playerId);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }

  @action
  Future<bool> restorePlayer(String playerId) async {
    try {
      return await _playerService.restorePlayer(playerId);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }
}
