import 'package:basics/basics.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/app_colors.dart';
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
    @Default(AppColors.defaultPlayerAvatarColorHexidecimal) @HiveField(6) int avatarColor,
    String? avatarImageUri,
    XFile? avatarFileToSave,
  }) = _Player;

  const Player._();

  bool get hasName => (name != null && name!.isNotEmpty) || isBggUser;

  bool get hasAvatarImage => avatarImageUri != null;

  bool get isBggUser => bggName.isNotNullOrBlank;

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
    if (nameParts.length == 1 || nameParts[1].isEmpty) {
      return nameParts[0][0].toUpperCase();
    }

    return nameParts[0][0].toUpperCase() + nameParts[1][0].toUpperCase();
  }
}
