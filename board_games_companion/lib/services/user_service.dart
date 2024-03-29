import 'package:injectable/injectable.dart';

import '../models/hive/user.dart';
import 'hive_base_service.dart';

@singleton
class UserService extends BaseHiveService<User, UserService> {
  UserService(super.hive);

  Future<User?> retrieveUser() async {
    if (!await ensureBoxOpen()) {
      return null;
    }

    if (storageBox.values.isEmpty) {
      return null;
    }

    return storageBox.values.first;
  }

  Future<bool> addOrUpdateUser(User user) async {
    if (user.name.isEmpty) {
      return false;
    }

    if (!await ensureBoxOpen()) {
      return false;
    }

    await storageBox.put(user.name, user);

    return true;
  }

  Future<bool> removeUser(User user) async {
    if (user.name.isEmpty) {
      return false;
    }

    if (!await ensureBoxOpen()) {
      return false;
    }

    await storageBox.delete(user.name);

    return true;
  }
}
