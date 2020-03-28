import 'package:board_games_companion/models/playthrough_player.dart';
import 'package:board_games_companion/stores/players_store.dart';
import 'package:flutter/cupertino.dart';

class StartPlaythroughStore with ChangeNotifier {
  final PlayersStore _playersStore;

  StartPlaythroughStore(this._playersStore);

  List<PlaythroughPlayer> _playthroughPlayers;
  List<PlaythroughPlayer> get playthroughPlayers => _playthroughPlayers;

  Future<void> loadPlaythroughPlayers() async {
    await _playersStore.loadPlayers();
    if (_playersStore.players?.isEmpty ?? true) {
      return;
    }

    _playthroughPlayers = _playersStore.players.map(
      (p) => PlaythroughPlayer(p),
    ).toList();

    notifyListeners();
  }
}
