// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/stores/players_store.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

part 'player_view_model.g.dart';

@injectable
class PlayerViewModel = _PlayerViewModel with _$PlayerViewModel;

abstract class _PlayerViewModel with Store {
  _PlayerViewModel(this._playersStore);

  final PlayersStore _playersStore;

  late Player playerWorkingCopy;

  @observable
  Player? player;

  @computed
  bool get isEditMode => player?.name?.isNotEmpty ?? false;

  @action
  void setPlayer(Player? player) {
    this.player = player ?? Player(id: const Uuid().v4());
    playerWorkingCopy = this.player!.copyWith();
  }

  // TODO Split this method into create and update (i.e. detect when updating or when creating a player)
  @action
  Future<bool> createOrUpdatePlayer(Player playerToCreateOrUpdate) async {
    try {
      final addOrUpdateSucceeded = await _playersStore.createOrUpdatePlayer(playerToCreateOrUpdate);
      if (addOrUpdateSucceeded) {
        player = playerToCreateOrUpdate;
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
      await _playersStore.deletePlayer(player!.id);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }
}
