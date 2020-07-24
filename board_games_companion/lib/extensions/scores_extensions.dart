import 'package:board_games_companion/models/hive/score.dart';

extension ScoresExtesions on List<Score> {
  List<Score> onlyScoresWithValue() {
    return this
            ?.where((s) =>
                (s.value?.isNotEmpty ?? false) && num.tryParse(s.value) != null)
            ?.toList() ??
        List<Score>();
  }
}
