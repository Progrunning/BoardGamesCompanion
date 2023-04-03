// ignore_for_file: constant_identifier_names

import 'package:hive/hive.dart';

import '../hive_boxes.dart';

part 'game_family.g.dart';

@HiveType(typeId: HiveBoxes.gameFamilyTypeId)
enum GameFamily {
  @HiveField(0)
  HighestScore,
  @HiveField(1)
  LowestScore,
  @HiveField(2)
  Cooperative,
}
