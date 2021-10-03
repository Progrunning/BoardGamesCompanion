import '../models/player_score.dart';

extension PlayerScoreExtensions on List<PlayerScore>? {
  static const moveDownTheList = 1;
  static const moveUpTheList = -1;

  void sortByScore() {
    if (this?.isEmpty ?? true) {
      return;
    }

    this?.sort((a, b) {
      final hasScore = a?.score?.value != null;
      if (!hasScore) {
        return moveDownTheList;
      }

      final comparerHasScore = b?.score?.value != null;
      if (!comparerHasScore) {
        return moveUpTheList;
      }

      final scoreNumber = num.tryParse(a.score!.value);
      final comparerScoreNumber = num.tryParse(b.score!.value);
      if (scoreNumber == null && comparerScoreNumber != null) {
        return moveDownTheList;
      }

      if (scoreNumber != null && comparerScoreNumber == null) {
        return moveUpTheList;
      }

      return comparerScoreNumber!.compareTo(scoreNumber!);
    });
  }
}
