// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../models/hive/player.dart';
import '../../stores/players_store.dart';
import 'players_visual_state.dart';

part 'players_view_model.g.dart';

@injectable
class PlayersViewModel = _PlayersViewModel with _$PlayersViewModel;

abstract class _PlayersViewModel with Store {
  _PlayersViewModel(this._playersStore) {
    // MK React to any updates on the players collection (e.g. delete or restore)
    _playersReactionDisposer = reaction((_) => _playersStore.players, (_) {
      switch (visualState) {
        case ActivePlayers():
          visualState = PlayersVisualState.activePlayers(activePlayers: activePlayers);
        case AllPlayers():
          visualState = PlayersVisualState.allPlayersPlayers(
            activePlayers: activePlayers,
            deletedPlayers: deletedPlayers,
          );
      }
    });
  }

  late final ReactionDisposer _playersReactionDisposer;

  final PlayersStore _playersStore;

  final List<Player> _selectedPlayers = <Player>[];

  @observable
  ObservableFuture<void>? futureLoadPlayers;

  @observable
  PlayersVisualState visualState = const PlayersVisualState.loadingPlayers();

  @computed
  List<Player> get activePlayers => _playersStore.activePlayers.sortAlphabetically();

  @computed
  List<Player> get deletedPlayers => _playersStore.deletedPlayers.sortAlphabetically();

  @computed
  bool get hasAnyActivePlayers => activePlayers.isNotEmpty;

  @computed
  bool get hasAnyDeletedPlayers => activePlayers.isNotEmpty;

  @computed
  bool get hasAnyPlayers => activePlayers.isNotEmpty && deletedPlayers.isNotEmpty;

  String? searchPhrase;

  // TODO Update these flags to proper visual states using Freezed and Mobx
  bool get isSearching => searchPhrase?.isNotEmpty ?? false;

  @action
  void loadPlayers() => futureLoadPlayers = ObservableFuture<void>(_loadPlayers());

  @action
  void toggleDeletePlayersMode() {
    switch (visualState) {
      case DeletePlayers():
        visualState = PlayersVisualState.activePlayers(activePlayers: activePlayers);
        _selectedPlayers.clear();
      case _:
        visualState = PlayersVisualState.deletePlayers(activePlayers: activePlayers);
    }
  }

  @action
  void toggleShowDeletePlayers() {
    switch (visualState) {
      case AllPlayers():
        visualState = PlayersVisualState.activePlayers(activePlayers: activePlayers);
      case _:
        visualState = PlayersVisualState.allPlayersPlayers(
          activePlayers: activePlayers,
          deletedPlayers: deletedPlayers,
        );
    }
  }

  @action
  Future<void> deleteSelectedPlayers() async {
    try {
      final playerIdsToDelete = _selectedPlayers.map((Player player) => player.id).toList();
      for (final playerId in playerIdsToDelete) {
        await _playersStore.deletePlayer(playerId);
      }

      toggleDeletePlayersMode();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  void selectPlayer(Player player) => _selectedPlayers.add(player);

  void deselectPlayer(Player player) => _selectedPlayers.remove(player);

  Future<void> _loadPlayers() async {
    try {
      visualState = const PlayersVisualState.loadingPlayers();
      await _playersStore.loadPlayers();
      visualState = PlayersVisualState.activePlayers(activePlayers: activePlayers);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  void dispose() {
    _playersReactionDisposer();
  }
}
