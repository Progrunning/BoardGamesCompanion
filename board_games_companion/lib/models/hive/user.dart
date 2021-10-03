import 'package:hive/hive.dart';

import '../../common/hive_boxes.dart';

part 'user.g.dart';

@HiveType(typeId: HiveBoxes.UserTypeId)
class User {
  User({required this.name});

  @HiveField(1)
  String name;
}
