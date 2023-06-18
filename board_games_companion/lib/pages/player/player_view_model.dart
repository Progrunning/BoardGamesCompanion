// ignore_for_file: library_private_types_in_public_api

import 'package:basics/basics.dart';
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
  Player? _player;

  @observable
  Player? playerWorkingCopy;

  @computed
  String? get playerName => playerWorkingCopy?.name;

  @computed
  String? get playerAvatarImageUri => playerWorkingCopy?.avatarImageUri;

  @computed
  bool get playerHasName => playerName.isNotNullOrBlank;

  @computed
  bool get isEditMode => _player?.name?.isNotNullOrBlank ?? false;

  @computed
  bool get hasUnsavedChanges =>
      playerAvatarImageUri != _player?.avatarImageUri || playerName != _player?.name;

  @action
  void setPlayer(Player? player) {
    _player = player ?? Player(id: const Uuid().v4());
    playerWorkingCopy = _player!.copyWith();
  }

  @action
  void updatePlayerWorkingCopy(Player player) => playerWorkingCopy = player;

  // TODO Split this method into create and update (i.e. detect when updating or when creating a player)
  @action
  Future<bool> createOrUpdatePlayer(Player playerToCreateOrUpdate) async {
    try {
      final addOrUpdateSucceeded = await _playersStore.createOrUpdatePlayer(playerToCreateOrUpdate);
      if (addOrUpdateSucceeded) {
        _player = playerToCreateOrUpdate;
      }

      return addOrUpdateSucceeded;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }

  @action
  Future<void> deletePlayer() async {
    try {
      await _playersStore.deletePlayer(_player!.id);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }
}
