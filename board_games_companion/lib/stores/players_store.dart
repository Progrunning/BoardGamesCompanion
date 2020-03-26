import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/player.dart';
import 'package:board_games_companion/services/player_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class PlayersStore with ChangeNotifier {
  final PlayerService _playerService;

  LoadDataState _loadDataState = LoadDataState.None;
  List<Player> _players;

  PlayersStore(this._playerService);

  LoadDataState get loadDataState => _loadDataState;
  List<Player> get players => _players;

  Future<void> loadPlayers() async {
    _loadDataState = LoadDataState.Loading;
    notifyListeners();

    try {
      _players = await _playerService.retrievePlayers();
    } catch (e, stack) {
      _loadDataState = LoadDataState.Error;
      Crashlytics.instance.recordError(e, stack);
    }

    _loadDataState = LoadDataState.Loaded;
    notifyListeners();
  }

  @override
  void dispose() {
    _playerService.closeBox(HiveBoxes.Players);

    super.dispose();
  }
}
