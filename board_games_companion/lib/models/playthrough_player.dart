import 'package:flutter/cupertino.dart';

import 'hive/player.dart';

class PlaythroughPlayer with ChangeNotifier {
  PlaythroughPlayer(this.player);

  Player player;
  bool _isChecked = false;
  bool get isChecked => _isChecked;

  set isChecked(bool checked) {
    if (_isChecked != checked) {
      _isChecked = checked;
      notifyListeners();
    }
  }
}
