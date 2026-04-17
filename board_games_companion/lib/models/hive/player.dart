import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/constants.dart';
import '../../common/hive_boxes.dart';

export '../../extensions/players_extensions.dart';

part 'player.freezed.dart';
part 'player.g.dart';

@freezed
class Player with _$Player {
  @HiveType(typeId: HiveBoxes.playersTypeId, adapterName: 'PlayerAdapter')
  const factory Player({
    @HiveField(0) required String id,
    @HiveField(1) String? name,
    @HiveField(3) bool? isDeleted,
    @HiveField(4) String? avatarFileName,
    @HiveField(5) String? bggName,
    @Default(Constants.defaultAvatartAssetsPath) String avatarImageUri,
    XFile? avatarFileToSave,
  }) = _Player;

  const Player._();

  bool get hasName => (name != null && name!.isNotEmpty) || isBggUser;

  bool get hasAvatarImage =>
      avatarImageUri != null && avatarImageUri != Constants.defaultAvatartAssetsPath;

  bool get isBggUser => bggName != null && bggName!.isNotEmpty;

  String? get initials {
    if (hasName) {
      return _getInitials(name!);
    }

    if (isBggUser) {
      return _getInitials(bggName!);
    }

    return null;
  }

  String? _getInitials(String text) {
    final nameParts = text.split(' ');
    if (nameParts.length == 1) {
      return nameParts[0][0].toUpperCase();
    }

    return nameParts[0][0].toUpperCase() + nameParts[1][0].toUpperCase();
  }
}
