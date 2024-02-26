import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sprintf/sprintf.dart';

import '../../common/app_text.dart';
import '../../models/hive/board_game_details.dart';

part 'most_played_game.freezed.dart';

@freezed
class MostPlayedGame with _$MostPlayedGame {
  const factory MostPlayedGame({
    required BoardGameDetails boardGameDetails,
    required int totalNumberOfPlays,
    required int totalTimePlayedInMinutes,
  }) = _MostPlayedGame;

  const MostPlayedGame._();

  String get totalTimePlayedFormatted {
    if (totalTimePlayedInMinutes >= Duration.minutesPerHour) {
      final isFullHour = totalTimePlayedInMinutes % Duration.minutesPerHour == 0;
      return sprintf(AppText.playsPageOverallStatsTotalPlayedTimeFormat, [
        (totalTimePlayedInMinutes / Duration.minutesPerHour).toStringAsFixed(isFullHour ? 0 : 1),
        'h',
      ]);
    }

    return sprintf(AppText.playsPageOverallStatsTotalPlayedTimeFormat, [
      totalTimePlayedInMinutes,
      'min',
    ]);
  }
}
