import 'package:board_games_companion/pages/playthroughs/average_score_precision.dart';

extension AverageScorePrecisionExtensions on AverageScorePrecision {
  String toFormattedText() {
    return when(
      none: () => 'None',
      precision: (value) {
        if (value == 1) {
          return '.0';
        }

        if (value == 2) {
          return '.00';
        }

        return 'Unknown';
      },
    );
  }
}
