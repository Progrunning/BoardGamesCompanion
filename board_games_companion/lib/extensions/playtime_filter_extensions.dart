import 'package:sprintf/sprintf.dart';

import '../common/app_text.dart';
import '../pages/plays/game_spinner_filters.dart';

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
