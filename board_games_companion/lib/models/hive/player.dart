import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/constants.dart';
import '../../common/hive_boxes.dart';

part 'player.g.dart';

@HiveType(typeId: HiveBoxes.PlayersTypeId)
class Player with ChangeNotifier {
  @HiveField(0)
  String id;

  @HiveField(1)
  String? _name;
  @HiveField(2)
  @Deprecated('Use avatarImageUri instead. The path to the image should be created at runtime, based on the avatarFileName and the path to the Documents folder.')
  String? _imageUri;
  @HiveField(3)
  bool? _isDeleted;
  @HiveField(4)
  String? _avatarFileName;
  
  String? _avatarImageUri;

  String? get name => _name;
  String get avatarImageUri => _avatarImageUri ?? _imageUri ?? Constants.DefaultAvatartAssetsPath;
  String? get avatarFileName => _avatarFileName;
  bool? get isDeleted => _isDeleted;

  PickedFile? avatarFileToSave;

  set name(String? value) {
    if (_name != value) {
      _name = value;
      notifyListeners();
    }
  }

  set avatarImageUri(String value) {
    if (_avatarImageUri != value) {
      _avatarImageUri = value;
      notifyListeners();
    }
  }
  
  set avatarFileName(String? value) {
    if (_avatarFileName != value) {
      _avatarFileName = value;
    }
  }

  set isDeleted(bool? value) {
    if (_isDeleted != value) {
      _isDeleted = value;
      notifyListeners();
    }
  }
}
