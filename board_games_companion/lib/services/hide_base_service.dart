import 'package:hive/hive.dart';

class BaseHiveService {
  void closeBox(String boxName) {
    if (boxName?.isEmpty ?? true) {
      return;
    }

    Hive.box(boxName).close();
  }
}
