import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/services/player_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class PlayersStore with ChangeNotifier {
  final PlayerService _playerService;

  List<Player> _players;
  Player _playerToCreateOrEdit;

  PlayersStore(this._playerService);

  List<Player> get players => _players;
  Player get playerToCreateOrEdit => _playerToCreateOrEdit;
  String get currentPlayerAvatarImageUri => _playerToCreateOrEdit.imageUri;
  String get currentPlayerName => _playerToCreateOrEdit.name;

  Future<List<Player>> loadPlayers() async {
    if (_players != null) {
      return _players;
    }

    try {
      _players = await _playerService.retrievePlayers();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return _players ?? List<Player>();
  }

  Future<bool> addOrUpdatePlayer(Player player) async {
    try {
      final existingPlayer = _players.firstWhere(
        (p) => p.id == player.id,
        orElse: () => null,
      );

      final isCreatingNewPlayer = existingPlayer == null;
      final addOrUpdateSucceeded = await _playerService.addOrUpdatePlayer(
          player, currentPlayerAvatarImageUri);
      if (addOrUpdateSucceeded) {
        _playerToCreateOrEdit.imageUri = player.imageUri;
        _playerToCreateOrEdit.name = player.name;

        if (isCreatingNewPlayer) {
          _players.add(player);

          notifyListeners();
        }
      }

      return addOrUpdateSucceeded;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }

  Future<bool> deletePlayer(String playerId) async {
    try {
      final deleteSucceeded = await _playerService.deletePlayer(playerId);
      if (deleteSucceeded) {
        _players.removeWhere((p) => p.id == playerId);
        notifyListeners();
      }
      return deleteSucceeded;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }

  void setPlayerToCreateOrEdit({Player player}) {
    _playerToCreateOrEdit = player ?? Player();
  }

  @override
  void dispose() {
    _playerService.closeBox(HiveBoxes.Players);

    super.dispose();
  }
}
