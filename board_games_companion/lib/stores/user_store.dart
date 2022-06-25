import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import '../models/hive/user.dart';
import '../services/user_service.dart';

class UserStore with ChangeNotifier {
  UserStore(this._userService);

  final UserService _userService;

  User? _user;
  User? get user => _user;

  Future<void> loadUser() async {
    try {
      final user = await _userService.retrieveUser();
      if (user != null) {
        _user = user;
        notifyListeners();
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
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
      FirebaseCrashlytics.instance.recordError(e, stack);
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
      FirebaseCrashlytics.instance.recordError(e, stack);
    }

    return false;
  }
}
