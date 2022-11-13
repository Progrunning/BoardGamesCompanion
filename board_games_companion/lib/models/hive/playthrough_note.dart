import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../common/hive_boxes.dart';

part 'playthrough_note.freezed.dart';
part 'playthrough_note.g.dart';

@freezed
class PlaythroughNote with _$PlaythroughNote {
  @HiveType(typeId: HiveBoxes.playthroughNoteId, adapterName: 'PlaythroughNoteAdapter')
  const factory PlaythroughNote({
    @HiveField(0) required String id,
    @HiveField(1) required String text,
    @HiveField(2) required DateTime createdAt,
    @HiveField(3) DateTime? modifiedAt,
  }) = _PlaythroughNote;
}
