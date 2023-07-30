import 'package:basics/basics.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../common/hive_boxes.dart';

abstract class BaseHiveService<TBox, TService> {
  BaseHiveService(this._hive);

  final HiveInterface _hive;

  @protected
  final uuid = const Uuid();

  late Box<TBox> storageBox;

  String get _boxName => HiveBoxes.boxesNamesMap[TService] ?? '';

  bool get _isBoxOpen => _hive.isBoxOpen(_boxName);

  void closeBox() {
    if (_boxName.isNullOrBlank || !_isBoxOpen) {
      return;
    }

    _hive.box<TBox>(_boxName).close();
  }

  Future<bool> ensureBoxOpen() async {
    if (_boxName.isNullOrBlank) {
      return false;
    }

    if (!_isBoxOpen) {
      storageBox = await _hive.openBox<TBox>(_boxName);
    }

    return storageBox != null;
  }
}
