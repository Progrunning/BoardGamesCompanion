import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/hive/player.dart';
import '../../models/player_score.dart';

part 'playthroughs_log_game_players.freezed.dart';

@freezed
class PlaythroughsLogGamePlayers with _$PlaythroughsLogGamePlayers {
  const factory PlaythroughsLogGamePlayers.loading() = _loading;
  const factory PlaythroughsLogGamePlayers.noPlayers() = _noPlayers;
  const factory PlaythroughsLogGamePlayers.noPlayersSelected() = _noPlayersSelected;
  const factory PlaythroughsLogGamePlayers.playersSelected({
    required List<Player> players,
    required Map<String, PlayerScore> playerScores,
  }) = _playersSelected;
}
