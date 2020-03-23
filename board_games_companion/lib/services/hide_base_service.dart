import 'package:hive/hive.dart';

class BaseHiveService<T> {
  Box<T> storageBox;

  void closeBox(String boxName) {
    if (boxName?.isEmpty ?? true) {
      return;
    }

    Hive.box(boxName).close();
  }

  Future<bool> ensureBoxOpen(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      storageBox = await Hive.openBox<T>(boxName);
    }

    return storageBox != null;
  }
}
