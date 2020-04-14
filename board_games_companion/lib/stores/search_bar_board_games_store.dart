import 'package:flutter/material.dart';

class SearchBarBoardGamesStore with ChangeNotifier {
  String _searchPhrase;

  String get searchPhrase => _searchPhrase;
  set searchPhrase(String value) {
    if (_searchPhrase != value) {
      _searchPhrase = value;
      notifyListeners();
    }
  }
}
