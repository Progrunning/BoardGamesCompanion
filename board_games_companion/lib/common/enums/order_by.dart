// ignore_for_file: constant_identifier_names

import 'package:hive/hive.dart';

import '../hive_boxes.dart';

part 'order_by.g.dart';

@HiveType(typeId: HiveBoxes.orderByTypeId)
enum OrderBy {
  @HiveField(0)
  Ascending,
  @HiveField(1)
  Descending,
}
