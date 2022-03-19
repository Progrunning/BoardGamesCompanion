import 'package:board_games_companion/common/constants.dart';

import '../models/hive/score.dart';

extension ScoresExtesions on List<Score>? {
  List<Score> onlyScoresWithValue() {
    return this
            ?.where((s) => (s.value?.isNotEmpty ?? false) && num.tryParse(s.value!) != null)
            .toList() ??
        <Score>[];
  }

  List<Score>? sortByScore() {
    return this
      ?..sort((Score a, Score b) {
        if (a.value == null && b.value == null) {
          return Constants.LeaveAsIs;
        }

        if (a.value == null) {
          return Constants.MoveBelow;
        }

        if (b.value == null) {
          return Constants.MoveAbove;
        }

        final num? aNumber = num.tryParse(a.value!);
        final num? bNumber = num.tryParse(b.value!);
        if (aNumber == null && bNumber == null) {
          return Constants.LeaveAsIs;
        }

        if (aNumber == null) {
          return Constants.MoveBelow;
        }

        if (bNumber == null) {
          return Constants.MoveAbove;
        }

        return bNumber.compareTo(aNumber);
      });
  }
}
