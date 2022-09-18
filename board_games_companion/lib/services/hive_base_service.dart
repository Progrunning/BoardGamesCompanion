import 'package:basics/basics.dart';
import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

abstract class BaseHiveService<TBox, TService> {
  @protected
  final uuid = const Uuid();

  late Box<TBox> storageBox;

  String? get _boxName => HiveBoxes.boxesNamesMap[TService];

  bool get _isBoxOpen => Hive.isBoxOpen(_boxName!);

  void closeBox() {
    if (_boxName.isNullOrBlank || !_isBoxOpen) {
      return;
    }

    Hive.box<TBox>(_boxName!).close();
  }

  Future<bool> ensureBoxOpen() async {
    if (_boxName.isNullOrBlank) {
      return false;
    }

    if (!_isBoxOpen) {
      storageBox = await Hive.openBox<TBox>(_boxName!);
    }

    return storageBox != null;
  }
}
