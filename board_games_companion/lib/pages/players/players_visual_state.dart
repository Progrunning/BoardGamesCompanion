import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/hive/player.dart';

part 'players_visual_state.freezed.dart';

@freezed
class PlayersVisualState with _$PlayersVisualState {
  const factory PlayersVisualState.loadingPlayers() = LoadingPlayers;
  const factory PlayersVisualState.loadingFailed() = LoadingFailed;

  /// No players
  const factory PlayersVisualState.noPlayers() = NoPlayers;

  /// No active players
  const factory PlayersVisualState.noActivePlayers() = NoActivePlayers;

  /// Show [activePlayers] only
  const factory PlayersVisualState.activePlayers({
    required List<Player> activePlayers,
  }) = ActivePlayers;

  /// Show [activePlayers] and [deletedPlayers]
  const factory PlayersVisualState.allPlayersPlayers({
    required List<Player> activePlayers,
    required List<Player> deletedPlayers,
  }) = AllPlayers;

  /// A mode in which users can players on the screen and delete
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
