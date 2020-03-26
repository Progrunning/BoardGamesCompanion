import 'package:flutter/cupertino.dart';

class HomeStore with ChangeNotifier {
  int boardGamesPageIndex = 0;

  void updateSelectedPageIndex(int selectedPageIndex) {
    boardGamesPageIndex = selectedPageIndex;
    notifyListeners();
  }
}
