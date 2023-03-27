import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../common/hive_boxes.dart';

export '../../extensions/no_score_game_result_extensions.dart';

part 'no_score_game_result.freezed.dart';
part 'no_score_game_result.g.dart';

@HiveType(typeId: HiveBoxes.cooperativeGameResultTypeId)
enum CooperativeGameResult {
  @HiveField(0)
  win,
  @HiveField(1)
  loss,
}

@freezed
abstract class NoScoreGameResult with _$NoScoreGameResult {
  @HiveType(typeId: HiveBoxes.noScoreGameResultTypeId, adapterName: 'NoScoreGameResultAdapter')
  const factory NoScoreGameResult({
    @HiveField(0, defaultValue: null) CooperativeGameResult? cooperativeGameResult,
  }) = _NoScoreGameResult;

  const NoScoreGameResult._();
}
