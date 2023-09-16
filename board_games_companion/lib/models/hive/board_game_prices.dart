import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../common/hive_boxes.dart';

part 'board_game_prices.freezed.dart';
part 'board_game_prices.g.dart';

@freezed
class BoardGamePrices with _$BoardGamePrices {
  @HiveType(typeId: HiveBoxes.boardGamePrices, adapterName: 'BoardGamePricesAdapter')
  const factory BoardGamePrices({
    @HiveField(0) required String region,
    @HiveField(1) required String websiteUrl,
    @HiveField(2) double? highest,
    @HiveField(3) double? average,
    @HiveField(4) double? median,
    @HiveField(5) double? lowest,
    @HiveField(6) String? lowestStoreName,
    @HiveField(7) double? lowest30d,
    @HiveField(8) String? lowest30dStore,
    @HiveField(9) DateTime? lowest30dDate,
    @HiveField(10) double? lowest52w,
    @HiveField(11) String? lowest52wStore,
    @HiveField(12) DateTime? lowest52wDate,
  }) = _BoardGamePrices;

  const BoardGamePrices._();
}
