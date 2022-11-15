import 'package:freezed_annotation/freezed_annotation.dart';

import 'board_game_playthrough.dart';

part 'grouped_board_game_playthroughs.freezed.dart';

@freezed
class GroupedBoardGamePlaythroughs with _$GroupedBoardGamePlaythroughs {
  const factory GroupedBoardGamePlaythroughs({
    required DateTime date,
    required List<BoardGamePlaythrough> boardGamePlaythroughs,
  }) = _GroupedBoardGamePlaythroughs;
}
