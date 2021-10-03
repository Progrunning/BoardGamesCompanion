import '../models/hive/score.dart';

extension ScoresExtesions on List<Score>? {
  List<Score> onlyScoresWithValue() {
    return this
            ?.where((s) => (s.value?.isNotEmpty ?? false) && num.tryParse(s.value!) != null)
            .toList() ??
        <Score>[];
  }
}
