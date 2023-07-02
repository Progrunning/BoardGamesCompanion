import 'package:freezed_annotation/freezed_annotation.dart';

import 'board_game_playthrough.dart';

part 'historical_playthrough.freezed.dart';

@freezed
class HistoricalPlaythrough with _$HistoricalPlaythrough {
  const factory HistoricalPlaythrough.withDateHeader({
    required DateTime playedOn,
    required BoardGamePlaythrough boardGamePlaythroughs,
  }) = _withDateHeader;
  const factory HistoricalPlaythrough.withoutDateHeader({
    required BoardGamePlaythrough boardGamePlaythroughs,
  }) = _withoutDateHeader;
}
