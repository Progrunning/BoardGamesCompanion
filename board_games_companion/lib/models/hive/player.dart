import 'package:board_games_companion/common/constants.dart';
import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

part 'player.g.dart';

@HiveType(typeId: HiveBoxes.PlayersTypeId)
class Player with ChangeNotifier {
  @HiveField(0)
  String id;

  @HiveField(1)
  String _name;
  @HiveField(2)
  String _imageUri;
  @HiveField(3)
  bool _isDeleted;

  String get name => _name;
  // TODO MK Need to introduce imageName to hold the name of the file and get the Documents path at runtime
  String get imageUri => _imageUri ?? Constants.DefaultAvatartAssetsPath;
  bool get isDeleted => _isDeleted;

  PickedFile avatarFileToSave;

  set name(String value) {
    if (_name != value) {
      _name = value;
      notifyListeners();
    }
  }

  set imageUri(String value) {
    if (_imageUri != value) {
      _imageUri = value;
      notifyListeners();
    }
  }

  set isDeleted(bool value) {
    if (_isDeleted != value) {
      _isDeleted = value;
      notifyListeners();
    }
  }
}
