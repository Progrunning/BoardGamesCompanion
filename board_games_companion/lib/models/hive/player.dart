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
}
