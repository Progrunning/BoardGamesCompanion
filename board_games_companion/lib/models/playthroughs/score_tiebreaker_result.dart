import 'package:freezed_annotation/freezed_annotation.dart';

part 'score_tiebreaker_result.freezed.dart';

@freezed
class ScoreTiebreakerResult with _$ScoreTiebreakerResult {
  /// Occurs when multiple players share the same place (i.e. the tiebreak couldn't be resolved)
  const factory ScoreTiebreakerResult.sharedPlace() = _sharedPlace;

  /// Occurs when a tie was resolved based on the tie breaking rules and a player was awarted
  /// adequat place based on the resolution by dragging and dropping.
  const factory ScoreTiebreakerResult.place({required int place}) = _place;
}
