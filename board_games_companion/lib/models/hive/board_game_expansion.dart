import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../common/hive_boxes.dart';

part 'board_game_expansion.freezed.dart';
part 'board_game_expansion.g.dart';

@freezed
class BoardGameExpansion with _$BoardGameExpansion {
  @HiveType(typeId: HiveBoxes.boardGamesExpansionId, adapterName: 'BoardGamesExpansionAdapter')
  const factory BoardGameExpansion({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    // MK Removed this property as it wasn't required anymroe
    // @HiveField(2) required bool? isInCollection,
  }) = _BoardGameExpansion;
}
