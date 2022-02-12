import 'package:collection/collection.dart' show IterableExtension;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../common/hive_boxes.dart';
import '../../models/hive/player.dart';
import '../../services/player_service.dart';

@singleton
class PlayersViewModel with ChangeNotifier {
  PlayersViewModel(this._playerService);

  final PlayerService _playerService;

  List<Player>? _players;
  Player? _player;

  List<Player>? get players => _players;
  Player? get player => _player;

  Future<List<Player>> loadPlayers() async {
    if (_players != null) {
      return _players!;
    }

    try {
      _players = await _playerService.retrievePlayers();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return _players ?? <Player>[];
  }

  Future<bool> createOrUpdatePlayer(Player player) async {
    try {
      final existingPlayer = _players!.firstWhereOrNull(
        (p) => p.id == player.id,
      );

      final isNewPlayer = existingPlayer == null;
      final addOrUpdateSucceeded = await _playerService.addOrUpdatePlayer(player);
      if (addOrUpdateSucceeded) {
        _player!.id = player.id;
        _player!.avatarFileName = player.avatarFileName;
        _player!.avatarImageUri = player.avatarImageUri;
        _player!.name = player.name;

        if (isNewPlayer) {
          _players!.add(player);

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
        _players!.removeWhere((p) => p.id == playerId);
        notifyListeners();
      }
      return deleteSucceeded;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }

  void setPlayer({Player? player}) {
    _player = player ?? Player(id: const Uuid().v4());
  }

  @override
  void dispose() {
    _playerService.closeBox(HiveBoxes.Players);

    super.dispose();
  }
}
