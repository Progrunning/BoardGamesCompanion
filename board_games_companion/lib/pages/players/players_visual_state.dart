import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/hive/player.dart';

part 'players_visual_state.freezed.dart';

@freezed
class PlayersVisualState with _$PlayersVisualState {
  const factory PlayersVisualState.loadingPlayers() = LoadingPlayers;

  /// Show [activePlayers] only
  const factory PlayersVisualState.activePlayers({
    required List<Player> activePlayers,
  }) = ActivePlayers;

  /// Show [activePlayers] and [deletedPlayers]
  const factory PlayersVisualState.allPlayersPlayers({
    required List<Player> activePlayers,
    required List<Player> deletedPlayers,
  }) = AllPlayers;

  /// A mode in which users can check players on the screen and delete
  /// selected
  const factory PlayersVisualState.deletePlayers({
    required List<Player> activePlayers,
  }) = DeletePlayers;

  const PlayersVisualState._();

  bool get isDeletePlayersMode => switch (this) {
        DeletePlayers() => true,
        _ => false,
      };

  bool get isShowingAllPlayers => switch (this) {
        AllPlayers() => true,
        _ => false,
      };
}
