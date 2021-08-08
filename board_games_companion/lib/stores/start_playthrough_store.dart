import 'package:flutter/cupertino.dart';

import '../models/playthrough_player.dart';
import 'players_store.dart';

class StartPlaythroughStore with ChangeNotifier {
  StartPlaythroughStore(this._playersStore);
  
  final PlayersStore _playersStore;

  List<PlaythroughPlayer> _playthroughPlayers;
  List<PlaythroughPlayer> get playthroughPlayers => _playthroughPlayers;

  Future<List<PlaythroughPlayer>> loadPlaythroughPlayers() async {
    final players = await _playersStore.loadPlayers();

    _playthroughPlayers = players
        ?.map(
          (p) => PlaythroughPlayer(p),
        )
        ?.toList();

    return _playthroughPlayers ?? <PlaythroughPlayer>[];
  }
}
