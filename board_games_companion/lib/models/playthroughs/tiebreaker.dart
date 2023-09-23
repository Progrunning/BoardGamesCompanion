import 'package:freezed_annotation/freezed_annotation.dart';

import 'score_tirebreaker.dart';

part 'tiebreaker.freezed.dart';

@freezed
class Tiebreaker with _$Tiebreaker {
  const factory Tiebreaker({
    required List<ScoreTiebreaker> scores,
  }) = _Tiebreaker;

  const Tiebreaker._();
}
