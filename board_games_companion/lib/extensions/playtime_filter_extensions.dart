import 'package:board_games_companion/common/app_text.dart';
import 'package:board_games_companion/pages/plays/game_spinner_filters.dart';
import 'package:sprintf/sprintf.dart';

extension PlaytimeFilterExtensions on PlaytimeFilter {
  String toFormattedText() {
    return when(
      any: () => AppText.playsPageGameSpinnerPlaytimeFilterAny,
      lessThan: (playtimeInMinutes) {
        if (playtimeInMinutes >= Duration.minutesPerHour) {
          final isFullHour = playtimeInMinutes % Duration.minutesPerHour == 0;
          return sprintf(AppText.playsPageGameSpinnerPlaytimeFilterInMinutesFormat, [
            (playtimeInMinutes / Duration.minutesPerHour).toStringAsFixed(isFullHour ? 0 : 1),
            'h',
          ]);
        }

        return sprintf(AppText.playsPageGameSpinnerPlaytimeFilterInMinutesFormat, [
          playtimeInMinutes,
          'min',
        ]);
      },
    );
  }
}
