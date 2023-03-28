// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/stores/players_store.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../models/hive/player.dart';

part 'playthrough_players_selection_view_model.g.dart';

@injectable
class PlaythroughPlayersSelectionViewModel = _PlaythroughPlayersSelectionViewModel
    with _$PlaythroughPlayersSelectionViewModel;

abstract class _PlaythroughPlayersSelectionViewModel with Store {
  _PlaythroughPlayersSelectionViewModel(this._playersStore);

  final PlayersStore _playersStore;

  @computed
  ObservableList<Player> get players => _playersStore.players
    ..sort((player, otherPlayer) => player.name!.compareTo(otherPlayer.name!));

  @computed
  Map<String, Player> get playersMap => {for (final player in players) player.id: player};

  @computed
  bool get hasSelectedPlayers => selectedPlayersMap.isNotEmpty;

  @observable
  ObservableMap<String, Player> selectedPlayersMap = <String, Player>{}.asObservable();

  @observable
  ObservableFuture<void>? futureLoadPlayers;

  @action
  void loadPlayers() => futureLoadPlayers = ObservableFuture<void>(_loadPlayers());

  @action
  void togglePlayerSelection(Player player) {
    if (selectedPlayersMap.containsKey(player.id)) {
      selectedPlayersMap.remove(player.id);
      return;
    }

    selectedPlayersMap[player.id] = player;
  }

  Future<void> _loadPlayers() async {
    await _playersStore.loadPlayers();
  }
}
