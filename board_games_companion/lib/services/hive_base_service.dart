import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class BaseHiveService<T> {
  @protected
  final uuid = Uuid();

  Box<T> storageBox;

  void closeBox(String boxName) {
    if (boxName?.isEmpty ?? true) {
      return;
    }

    Hive.box<T>(boxName).close();
  }

  Future<bool> ensureBoxOpen(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      storageBox = await Hive.openBox<T>(boxName);
    }

    return storageBox != null;
  }
}
