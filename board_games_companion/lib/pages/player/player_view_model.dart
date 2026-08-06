// ignore_for_file: library_private_types_in_public_api

import 'dart:math';

import 'package:basics/basics.dart';
import 'package:board_games_companion/pages/player/player_visual_state.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

import '../../common/app_colors.dart';
import '../../models/hive/player.dart';
import '../../stores/players_store.dart';

part 'player_view_model.g.dart';

@injectable
class PlayerViewModel = _PlayerViewModel with _$PlayerViewModel;

abstract class _PlayerViewModel with Store {
  _PlayerViewModel(this._playersStore);

  final Random random = Random();
  final List<int> avatarColors =
      AppColors.playerAvatarColors.map((color) => color.toARGB32()).toList();

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
  bool get isBggUser => playerWorkingCopy?.isBggUser ?? false;

  @computed
  String? get bggName => playerWorkingCopy?.bggName;

  @computed
  String? get playerAvatarImageUri => playerWorkingCopy?.avatarImageUri;

  @computed
  int? get playerAvatarColor => playerWorkingCopy?.avatarColor;

  bool get playerHasName => playerName.isNotNullOrBlank;

  @computed
  bool get hasUnsavedChanges =>
      playerAvatarImageUri != _player?.avatarImageUri ||
      playerName != _player?.name ||
      playerAvatarColor != _player?.avatarColor;

  @action
  void setPlayer(Player? player) {
    final isNewPlayer = player == null;
    _player = player ?? Player(id: const Uuid().v4());
    playerWorkingCopy = _player!.copyWith(
      avatarColor:
          isNewPlayer ? avatarColors[random.nextInt(avatarColors.length)] : _player!.avatarColor,
    );

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
      final result = await _playersStore.deletePlayer(_player!.id);
      if (result.isSuccess) {
        setPlayer(result.data);
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  @action
  Future<bool> restorePlayer() async {
    final result = await _playersStore.restorePlayer(_player!.id);
    if (result.isSuccess) {
      visualState = const PlayerVisualState.restored();
      setPlayer(result.data);
    }

    return result.isSuccess;
  }

  Future<bool> _createOrUpdatePlayer(Player player) async {
    try {
      final result = await _playersStore.createOrUpdatePlayer(player);
      if (result.isSuccess) {
        setPlayer(result.data);
      }

      return result.isSuccess;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }
}
