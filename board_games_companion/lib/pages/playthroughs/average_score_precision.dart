import 'package:freezed_annotation/freezed_annotation.dart';

part 'average_score_precision.freezed.dart';

@freezed
class AverageScorePrecision with _$AverageScorePrecision {
  const factory AverageScorePrecision.none() = _none;
  const factory AverageScorePrecision.precision({required int value}) = _precision;
}
