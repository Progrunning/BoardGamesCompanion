import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../common/hive_boxes.dart';

part 'score_game_results.freezed.dart';
part 'score_game_results.g.dart';

@HiveType(typeId: HiveBoxes.scoreTiebreakerTypeId)
enum ScoreTiebreakerType {
  @HiveField(0)
  shared,
  @HiveField(1)
  place,
}

@freezed
class ScoreGameResult with _$ScoreGameResult {
  @HiveType(typeId: HiveBoxes.scoreGameResultTypeId, adapterName: 'ScoreGameResultAdapter')
  const factory ScoreGameResult({
    @HiveField(0) double? points,
    @HiveField(1) int? place,
    @HiveField(2) ScoreTiebreakerType? tiebreakerType,
  }) = _ScoreGameResult;

  const ScoreGameResult._();

  bool get hasScore => points != null;
}
