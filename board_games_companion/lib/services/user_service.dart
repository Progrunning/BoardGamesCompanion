import 'package:injectable/injectable.dart';

import '../common/hive_boxes.dart';
import '../models/hive/user.dart';
import 'hive_base_service.dart';

@singleton
class UserService extends BaseHiveService<User> {
  Future<User> retrieveUser() async {
    if (!await ensureBoxOpen(HiveBoxes.User)) {
      return null;
    }

    if (storageBox?.values?.isEmpty ?? true) {
      return null;
    }

    return storageBox.values.first;
  }

  Future<bool> addOrUpdateUser(User user) async {
    if (user?.name?.isEmpty ?? true) {
      return false;
    }

    if (!await ensureBoxOpen(HiveBoxes.User)) {
      return false;
    }

    await storageBox.put(user.name, user);

    return true;
  }

  Future<bool> removeUser(User user) async {
    if (user?.name?.isEmpty ?? true) {
      return false;
    }

    if (!await ensureBoxOpen(HiveBoxes.User)) {
      return false;
    }

    await storageBox.delete(user.name);

    return true;
  }
}
