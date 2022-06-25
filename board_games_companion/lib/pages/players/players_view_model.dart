import 'package:board_games_companion/stores/players_store.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../models/hive/player.dart';

@singleton
class PlayersViewModel with ChangeNotifier {
  PlayersViewModel(this._playersStore);

  final PlayersStore _playersStore;

  Player? _player;

  List<Player> get players => _playersStore.players;
  Player? get player => _player;

  String? searchPhrase;

  bool get isSearching => searchPhrase?.isNotEmpty ?? false;

  Future<List<Player>> loadPlayers() async {
    if (players.isNotEmpty) {
      return players;
    }

    try {
      await _playersStore.loadPlayers();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return players;
  }

  // TODO Test creating and updating players to see if there's no data flashing because of frequent data updates and notification
  Future<bool> createOrUpdatePlayer(Player player) async {
    try {
      final addOrUpdateSucceeded = await _playersStore.createOrUpdatePlayer(player);
      if (addOrUpdateSucceeded) {
        _player!.id = player.id;
        _player!.avatarFileName = player.avatarFileName;
        _player!.avatarImageUri = player.avatarImageUri;
        _player!.name = player.name;
        _player!.bggName = player.bggName;

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
      final deleteSucceeded = await _playersStore.deletePlayer(playerId);
      if (deleteSucceeded) {
        notifyListeners();
      }

      return deleteSucceeded;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }

  void setPlayer({Player? player}) {
    _player = player ?? Player(id: const Uuid().v4());
  }
}
