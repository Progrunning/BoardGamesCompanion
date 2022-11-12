// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/stores/players_store.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../models/hive/player.dart';

part 'players_view_model.g.dart';

@injectable
class PlayersViewModel = _PlayersViewModel with _$PlayersViewModel;

abstract class _PlayersViewModel with Store {
  _PlayersViewModel(this._playersStore);

  final PlayersStore _playersStore;

  final List<Player> _selectedPlayers = <Player>[];

  @computed
  ObservableList<Player> get players => _playersStore.players;

  @computed
  bool get hasAnyPlayers => players.isNotEmpty;

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
  }

  @observable
  ObservableFuture<void>? futureLoadPlayers;

  @action
  void loadPlayers() => futureLoadPlayers = ObservableFuture<void>(_loadPlayers());

  Future<void> deletePlayers(List<String> playerIds) async {
    try {
      for (final playerId in playerIds) {
        await _playersStore.deletePlayer(playerId);
      }
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

  Future<void> _loadPlayers() async {
    try {
      await _playersStore.loadPlayers();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }
}
