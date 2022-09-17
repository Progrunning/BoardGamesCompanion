import 'package:basics/basics.dart';
import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class BaseHiveService<TBox, TService> {
  @protected
  final uuid = const Uuid();

  late Box<TBox> storageBox;

  String? get _boxName => HiveBoxes.boxesNamesMap[TService];

  void closeBox() {
    if (_boxName.isNullOrBlank) {
      return;
    }

    Hive.box<TBox>(_boxName!).close();
  }

  Future<bool> ensureBoxOpen() async {
    if (_boxName.isNullOrBlank) {
      return false;
    }

    if (!Hive.isBoxOpen(_boxName!)) {
      storageBox = await Hive.openBox<TBox>(_boxName!);
    }

    return storageBox != null;
  }
}
