import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/models/hive/user.dart';
import 'package:board_games_companion/services/hive_base_service.dart';

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
