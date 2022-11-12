import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../common/hive_boxes.dart';

part 'score.freezed.dart';
part 'score.g.dart';

@freezed
class Score with _$Score {
  @HiveType(typeId: HiveBoxes.scoreTypeId, adapterName: 'ScoreAdapter')
  const factory Score({
    @HiveField(0) required String id,
    @HiveField(2) required String playerId,
    @HiveField(3) required String boardGameId,
    @HiveField(4) String? value,
    @HiveField(1) String? playthroughId,
  }) = _Score;

  const Score._();

  int get valueInt => int.tryParse(value ?? '0') ?? 0;
}
