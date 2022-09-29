// ignore_for_file: library_private_types_in_public_api

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../common/enums/playthrough_status.dart';
import '../../common/hive_boxes.dart';

part 'playthrough.freezed.dart';
part 'playthrough.g.dart';

@freezed
abstract class Playthrough with _$Playthrough {
  @HiveType(typeId: HiveBoxes.playthroughTypeId, adapterName: 'PlaythroughAdapter')
  const factory Playthrough({
    @HiveField(0) required String id,
    @HiveField(1) required String boardGameId,
    @HiveField(2) required List<String> playerIds,
    @HiveField(3) required List<String> scoreIds,
    @HiveField(4) required DateTime startDate,
    @HiveField(5) DateTime? endDate,
    @HiveField(6) PlaythroughStatus? status,
    @Default(false) @HiveField(7) bool? isDeleted,
    @HiveField(8) int? bggPlayId,
    @HiveField(9) List<String>? notes,
  }) = _Playthrough;
}
