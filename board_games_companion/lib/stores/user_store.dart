import 'package:board_games_companion/models/hive/user.dart';
import 'package:board_games_companion/services/user_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class UserStore with ChangeNotifier {
  final UserService _userService;

  User _user;
  User get user => _user;

  bool _isSyncing;
  bool get isSyncing => _isSyncing;
  set isSyncing(bool value) {
    if (_isSyncing != value) {
      _isSyncing = value;
      notifyListeners();
    }
  }

  UserStore(this._userService);

  Future<void> loadUser() async {
    try {
      final user = await _userService.retrieveUser();
      if (user != null) {
        _user = user;
        notifyListeners();
      }
    } catch (e, stack) {
      Crashlytics.instance.recordError(e, stack);
    }
  }

  Future<bool> addOrUpdateUser(User user) async {
    try {
      final addOrUpdateUserSucceeded = await _userService.addOrUpdateUser(user);
      if (addOrUpdateUserSucceeded) {
        _user = user;
        notifyListeners();
      }

      return true;
    } catch (e, stack) {
      Crashlytics.instance.recordError(e, stack);
    }

    return false;
  }

  Future<bool> removeUser(User user) async {
    try {
      if (await _userService.removeUser(user)) {
        _user = null;
        notifyListeners();
      }

      return true;
    } catch (e, stack) {
      Crashlytics.instance.recordError(e, stack);
    }

    return false;
  }
}