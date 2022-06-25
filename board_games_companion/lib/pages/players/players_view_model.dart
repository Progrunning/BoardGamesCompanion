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

  final List<Player> _selectedPlayers = <Player>[];
  Player? _player;

  List<Player> get players => _playersStore.players;
  Player? get player => _player;

  String? searchPhrase;

  // TODO Update these flags to proper visual states using Freezed and Mobx
  bool get isSearching => searchPhrase?.isNotEmpty ?? false;

  bool _isEditMode = false;
  bool get isEditMode => _isEditMode;
  set isEditMode(bool value) {
    if (_isEditMode == value) {
      return;
    }

    _isEditMode = value;
    notifyListeners();
  }

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

  Future<void> deletePlayers(List<String> playerIds) async {
    try {
      for (final playerId in playerIds) {
        await _playersStore.deletePlayer(playerId);
      }

      notifyListeners();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  void selectPlayer(Player player) {
    _selectedPlayers.add(player);
  }

  void deselectPlayer(Player player) {
    _selectedPlayers.remove(player);
  }

  Future<void> deleteSelectedPlayers() async {
    await deletePlayers(_selectedPlayers.map((Player player) => player.id).toList());
    _selectedPlayers.clear();
    isEditMode = false;
  }

  void setPlayer({Player? player}) {
    _player = player ?? Player(id: const Uuid().v4());
  }
}
