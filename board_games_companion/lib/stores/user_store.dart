// ignore_for_file: library_private_types_in_public_api

import 'package:basics/basics.dart';
import 'package:board_games_companion/stores/app_store.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../models/hive/user.dart';
import '../services/user_service.dart';

part 'user_store.g.dart';

@singleton
class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  _UserStore(
    this._userService,
    this._appStore,
  ) {
    // MK When restoring a backup, reload user data
    reaction((_) => _appStore.backupRestored, (bool? backupRestored) async {
      if (backupRestored ?? false) {
        await loadUser();
      }
    });
  }

  final UserService _userService;
  final AppStore _appStore;

  @observable
  User? user;

  @observable
  ObservableFuture<void>? futureLoadUser;

  @computed
  String? get userName => user?.name;

  @computed
  bool get hasUser => userName.isNotNullOrBlank;

  @action
  ObservableFuture<void> loadUser() => futureLoadUser = ObservableFuture(_loadUser());

  Future<void> _loadUser() async {
    try {
      user = await _userService.retrieveUser();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  Future<bool> addOrUpdateUser(User user) async {
    try {
      final addOrUpdateUserSucceeded = await _userService.addOrUpdateUser(user);
      if (addOrUpdateUserSucceeded) {
        this.user = user;
      }

      return true;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }

  Future<bool> removeUser() async {
    if (user == null) {
      return false;
    }

    try {
      if (await _userService.removeUser(user!)) {
        user = null;
      }

      return true;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }
}
