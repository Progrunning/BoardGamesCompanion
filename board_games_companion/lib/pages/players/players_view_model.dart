// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../models/hive/player.dart';
import '../../stores/players_store.dart';

part 'players_view_model.g.dart';

@injectable
class PlayersViewModel = _PlayersViewModel with _$PlayersViewModel;

abstract class _PlayersViewModel with Store {
  _PlayersViewModel(this._playersStore);

  final PlayersStore _playersStore;

  final List<Player> _selectedPlayers = <Player>[];

  @observable
  ObservableFuture<void>? futureLoadPlayers;

  @observable
  bool isEditMode = false;

  @computed
  List<Player> get players => _playersStore.activePlayers;

  @computed
  bool get hasAnyPlayers => players.isNotEmpty;

  String? searchPhrase;

  // TODO Update these flags to proper visual states using Freezed and Mobx
  bool get isSearching => searchPhrase?.isNotEmpty ?? false;

  @action
  void loadPlayers() => futureLoadPlayers = ObservableFuture<void>(_loadPlayers());

  @action
  void toggleEditMode() => isEditMode = !isEditMode;

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
