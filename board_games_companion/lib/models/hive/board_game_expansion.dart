import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'board_game_expansion.g.dart';

@HiveType(typeId: HiveBoxes.BoardGamesExpansionId)
class BoardGamesExpansion with ChangeNotifier {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;

  bool _isInCollection;
  @HiveField(2)
  bool get isInCollection => _isInCollection;
  @HiveField(2)
  set isInCollection(bool value) {
    if (_isInCollection != value) {
      _isInCollection = value;
      notifyListeners();
    }
  }
}
