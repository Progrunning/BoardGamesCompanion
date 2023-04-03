import 'package:freezed_annotation/freezed_annotation.dart';

import '../hive/player.dart';

part 'playthrough_players_selection_result.freezed.dart';

@freezed
class PlaythroughPlayersSelectionResult with _$PlaythroughPlayersSelectionResult {
  const factory PlaythroughPlayersSelectionResult.selectedPlayers({required List<Player> players}) =
      _selectedPlayers;
}
