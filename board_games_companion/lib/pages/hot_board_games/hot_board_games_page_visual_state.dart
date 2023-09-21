import 'package:freezed_annotation/freezed_annotation.dart';

part 'hot_board_games_page_visual_state.freezed.dart';

@freezed
class HotBoardGamesPageVisualState with _$HotBoardGamesPageVisualState {
  const factory HotBoardGamesPageVisualState.loading() = _loading;
  const factory HotBoardGamesPageVisualState.loaded() = _loaded;
  const factory HotBoardGamesPageVisualState.failedLoading() = _failedLoading;
}
