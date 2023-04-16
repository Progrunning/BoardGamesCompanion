import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common/enums/plays_tab.dart';
import '../../models/hive/board_game_details.dart';
import 'grouped_board_game_playthroughs.dart';

part 'plays_page_visual_states.freezed.dart';

@freezed
class PlaysPageVisualState with _$PlaysPageVisualState {
  const factory PlaysPageVisualState.history(
    PlaysTab playsTab,
    List<GroupedBoardGamePlaythroughs> finishedBoardGamePlaythroughs,
  ) = _History;
  const factory PlaysPageVisualState.statistics(PlaysTab playsTab) = _Statistics;
  const factory PlaysPageVisualState.selectGame(
    PlaysTab playsTab,
    List<BoardGameDetails> shuffledBoardGames,
  ) = _SelectGame;
}
