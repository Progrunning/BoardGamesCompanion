import '../models/hive/no_score_game_result.dart';

extension BoolExtensions on bool {
  CooperativeGameResult toCooperativeResult() =>
      this ? CooperativeGameResult.win : CooperativeGameResult.loss;
}
