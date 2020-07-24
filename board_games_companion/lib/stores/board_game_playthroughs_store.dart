import 'package:flutter/foundation.dart';

class BoardGamePlaythroughsStore with ChangeNotifier {
  int _boardGamePlaythroughPageIndex = 0;
  int get boardGamePlaythroughPageIndex => _boardGamePlaythroughPageIndex;

  set boardGamePlaythroughPageIndex(int selectedPageIndex) {
    if (_boardGamePlaythroughPageIndex != selectedPageIndex) {
      _boardGamePlaythroughPageIndex = selectedPageIndex;
      notifyListeners();
    }
  }
}
