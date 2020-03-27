import 'package:flutter/cupertino.dart';

class HomeStore with ChangeNotifier {
  int _boardGamesPageIndex = 0;
  int get boardGamesPageIndex => _boardGamesPageIndex;

  set boardGamesPageIndex(int selectedPageIndex) {
    if (_boardGamesPageIndex != selectedPageIndex) {
      _boardGamesPageIndex = selectedPageIndex;
      notifyListeners();
    }
  }
}
