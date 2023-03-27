import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../common/hive_boxes.dart';
import 'score.dart';

part 'no_score_game_result.freezed.dart';
part 'no_score_game_result.g.dart';

@freezed
abstract class NoScoreGameResult with _$NoScoreGameResult {
  @HiveType(typeId: HiveBoxes.noScoreGameResult, adapterName: 'NoScoreGameResultAdapter')
  const factory NoScoreGameResult({
    CooperativeGameResult? cooperativeGameResult,
  }) = _NoScoreGameResult;

  const NoScoreGameResult._();
}
