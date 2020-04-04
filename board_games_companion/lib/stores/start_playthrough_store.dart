import 'package:board_games_companion/models/playthrough_player.dart';
import 'package:board_games_companion/stores/players_store.dart';
import 'package:flutter/cupertino.dart';

class StartPlaythroughStore with ChangeNotifier {
  final PlayersStore _playersStore;

  StartPlaythroughStore(this._playersStore);

  List<PlaythroughPlayer> _playthroughPlayers;
  List<PlaythroughPlayer> get playthroughPlayers => _playthroughPlayers;

  Future<List<PlaythroughPlayer>> loadPlaythroughPlayers() async {
    final players = await _playersStore.loadPlayers();

    _playthroughPlayers = players
        ?.map(
          (p) => PlaythroughPlayer(p),
        )
        ?.toList();

    return _playthroughPlayers ?? Iterable<PlaythroughPlayer>.empty();
  }
}
