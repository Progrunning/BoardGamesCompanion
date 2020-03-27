import 'package:hive/hive.dart';

abstract class BaseBoardGame {
  BaseBoardGame(this.name);

  @HiveField(0)
  String id;
  @HiveField(1)
  int rank;
  @HiveField(2)
  String name;
  @HiveField(3)
  String thumbnailUrl;
  @HiveField(4)
  int yearPublished;
}
