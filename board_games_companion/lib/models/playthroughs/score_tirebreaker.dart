import 'package:freezed_annotation/freezed_annotation.dart';

part 'score_tirebreaker.freezed.dart';

@freezed
class ScoreTiebreaker with _$ScoreTiebreaker {
  const factory ScoreTiebreaker.sharedPlace({
    required List<String> playerScoreIds,
    required int place,
  }) = _sharedPlace;
  const factory ScoreTiebreaker.place({
    required String playerScoreId,
    required int place,
  }) = _place;
}
