import 'package:freezed_annotation/freezed_annotation.dart';

part 'score_tirebreaker.freezed.dart';

@freezed
class ScoreTiebreaker with _$ScoreTiebreaker{
  const factory ScoreTiebreaker.sharedPlace({required String playerScoreId}) = _sharedPlace;
  const factory ScoreTiebreaker.victory({required String playerScoreId}) = _victory;
}