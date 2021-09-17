import 'package:board_games_companion/pages/playthroughs/playthroughs_log_game_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../../models/playthrough_player.dart';
import '../../stores/players_store.dart';

@injectable
class PlaythroughsLogGameViewModel with ChangeNotifier {
  PlaythroughsLogGameViewModel(this._playersStore);

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

  DateTime playthroughDate = DateTime.now();

  PlaythroughStartTime playthroughStartTime = PlaythroughStartTime.now;

  Duration playthroughDuration = const Duration(minutes: 30);

  int _logGameStep = 0;
  int get logGameStep => _logGameStep;

  set logGameStep(int value) {
    if (_logGameStep != value) {
      _logGameStep = value;
      notifyListeners();
    }
  }

  bool get anyPlayerSelected => playthroughPlayers.any((player) => player.isChecked);
}
