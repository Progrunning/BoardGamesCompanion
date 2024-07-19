// ignore_for_file: library_private_types_in_public_api

import 'package:basics/basics.dart';
import 'package:board_games_companion/pages/player/player_visual_state.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

import '../../models/hive/player.dart';
import '../../stores/players_store.dart';

part 'player_view_model.g.dart';

@injectable
class PlayerViewModel = _PlayerViewModel with _$PlayerViewModel;

abstract class _PlayerViewModel with Store {
  _PlayerViewModel(this._playersStore);

  final PlayersStore _playersStore;

  @observable
  PlayerVisualState visualState = const PlayerVisualState.init();

  @observable
  Player? _player;

  @observable
  Player? playerWorkingCopy;

  @computed
  String? get playerName => playerWorkingCopy?.name;

  @computed
  bool get isBggUser => playerWorkingCopy?.bggName.isNotNullOrBlank ?? false;

  @computed
  String? get playerAvatarImageUri => playerWorkingCopy?.avatarImageUri;

  bool get playerHasName => playerName.isNotNullOrBlank;

  @computed
  bool get hasUnsavedChanges =>
      playerAvatarImageUri != _player?.avatarImageUri || playerName != _player?.name;

  @action
  void setPlayer(Player? player) {
    _player = player ?? Player(id: const Uuid().v4());
    playerWorkingCopy = _player!.copyWith();

    if (_player!.isDeleted ?? false) {
      visualState = const PlayerVisualState.deleted();
    } else if (_player?.name?.isNotNullOrBlank ?? false) {
      visualState = const PlayerVisualState.edit();
    } else {
      visualState = const PlayerVisualState.create();
    }
  }

  @action
  void updatePlayerWorkingCopy(Player player) => playerWorkingCopy = player;

  @action
  Future<bool> createPlayer(Player player) async {
    final operationSucceeded = await _createOrUpdatePlayer(player);
    if (operationSucceeded) {
      visualState = const PlayerVisualState.edit();
    }

    return operationSucceeded;
  }

  @action
  Future<bool> updatePlayer(Player player) async => _createOrUpdatePlayer(player);

  @action
  Future<void> deletePlayer() async {
    try {
      await _playersStore.deletePlayer(_player!.id);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  @action
  Future<bool> restorePlayer() async {
    final operationSucceeded = await _playersStore.restorePlayer(_player!.id);
    if (operationSucceeded) {
      visualState = const PlayerVisualState.restored();
    }

    return operationSucceeded;
  }

  Future<bool> _createOrUpdatePlayer(Player player) async {
    try {
      final operationSucceeded = await _playersStore.createOrUpdatePlayer(player);
      if (operationSucceeded) {
        _player = player;
      }

      return operationSucceeded;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }
}
