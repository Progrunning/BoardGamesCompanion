import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

import '../../common/app_text.dart';
import '../../extensions/date_time_extensions.dart';
import '../../extensions/string_extensions.dart';
import 'board_game_playthrough.dart';

part 'grouped_board_game_playthroughs.freezed.dart';

final DateFormat playthroughGroupingDateFormat = DateFormat('d MMMM y');

@freezed
class GroupedBoardGamePlaythroughs with _$GroupedBoardGamePlaythroughs {
  const factory GroupedBoardGamePlaythroughs({
    required DateTime date,
    required List<BoardGamePlaythrough> boardGamePlaythroughs,
  }) = _GroupedBoardGamePlaythroughs;

  const GroupedBoardGamePlaythroughs._();

  String get dateFormtted {
    if (date.isToday) {
      return AppText.today.toCapitalized();
    }

    if (date.isYesterday) {
      return AppText.yesteday.toCapitalized();
    }

    if (date.isDayBeforeYesterday) {
      return AppText.dayBeforeYesteday.toCapitalized();
    }

    return playthroughGroupingDateFormat.format(date);
  }
}
