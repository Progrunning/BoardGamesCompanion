// ignore_for_file: library_private_types_in_public_api

import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';

import '../../common/enums/playthrough_status.dart';
import '../../common/hive_boxes.dart';

part 'playthrough.g.dart';

@HiveType(typeId: HiveBoxes.playthroughTypeId)
class Playthrough = _Playthrough with _$Playthrough;

abstract class _Playthrough with Store {
  _Playthrough({
    required this.id,
    required this.boardGameId,
    required this.playerIds,
    required this.scoreIds,
    required this.startDate,
    // MK It is used but for whatever reason linter thinks it isn't
    // ignore: unused_element
    this.bggPlayId,
  });

  @HiveField(0)
  String id;
  @HiveField(1)
  String boardGameId;
  @HiveField(2)
  List<String> playerIds;
  @HiveField(3)
  List<String> scoreIds;

  @HiveField(4)
  @observable
  DateTime startDate;
  @HiveField(5)
  @observable
  DateTime? endDate;
  @HiveField(6)
  @observable
  PlaythroughStatus? status;
  @HiveField(7)
  @observable
  bool? isDeleted = false;
  @HiveField(8)
  int? bggPlayId;
}
