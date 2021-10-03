import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

abstract class BaseBoardGame with ChangeNotifier {
  BaseBoardGame({required this.id, required String name}) {
    _name = name;
  }

  @HiveField(0)
  String id;

  int? _rank;
  late String _name;
  String? _thumbnailUrl;
  int? _yearPublished;

  @HiveField(1)
  String get name => _name;
  @HiveField(2)
  String? get thumbnailUrl => _thumbnailUrl;
  @HiveField(3)
  int? get rank => _rank;
  @HiveField(4)
  int? get yearPublished => _yearPublished;

  @HiveField(1)
  set name(String value) {
    if (_name != value) {
      _name = value;
      notifyListeners();
    }
  }

  @HiveField(2)
  set thumbnailUrl(String? value) {
    if (_thumbnailUrl != value) {
      _thumbnailUrl = value;
      notifyListeners();
    }
  }

  @HiveField(3)
  set rank(int? value) {
    if (_rank != value) {
      _rank = value;
      notifyListeners();
    }
  }

  @HiveField(4)
  set yearPublished(int? value) {
    if (_yearPublished != value) {
      _yearPublished = value;
      notifyListeners();
    }
  }
}
