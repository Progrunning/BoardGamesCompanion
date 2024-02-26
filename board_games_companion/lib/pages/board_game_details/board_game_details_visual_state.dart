import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'board_game_details_visual_state.freezed.dart';

@freezed
class BoardGameDetailsVisualState with _$BoardGameDetailsVisualState {
  const factory BoardGameDetailsVisualState.loading() = _loading;
  const factory BoardGameDetailsVisualState.detailsLoaded({
    required BoardGameDetails boardGameDetails,
  }) = _detailsLoaded;
  const factory BoardGameDetailsVisualState.loadingFailed() = _loadingFailed;
}
