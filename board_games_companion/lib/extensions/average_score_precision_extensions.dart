import 'package:board_games_companion/pages/playthroughs/average_score_precision.dart';

extension AverageScorePrecisionExtensions on AverageScorePrecision {
  String toFormattedText() {
    return when(
      none: () => 'None',
      value: (precision) {
        if (precision == 1) {
          return '.0';
        }

        if (precision == 2) {
          return '.00';
        }

        return 'Unknown';
      },
    );
  }
}
