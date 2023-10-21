import 'package:freezed_annotation/freezed_annotation.dart';

part 'score_tirebreaker.freezed.dart';

@freezed
class ScoreTiebreaker with _$ScoreTiebreaker {
  /// Occurs when multiple players share the same place (i.e. the tiebreak couldn't be resolved)
  const factory ScoreTiebreaker.sharedPlace({
    required List<String> playerScoreIds,
    required int place,
  }) = _sharedPlace;

  /// Occurs when a tie was resolved based on the tie breaking rules and a player was awarded
  /// adequat place based on the resolution by dragging and dropping.
  const factory ScoreTiebreaker.place({
    required String playerScoreId,
    required int place,
  }) = _place;
}
