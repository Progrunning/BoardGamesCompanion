import 'package:freezed_annotation/freezed_annotation.dart';

import 'hive/player.dart';
import 'hive/score.dart';

export '../extensions/player_score_extensions.dart';

part 'player_score.freezed.dart';

/// Model containing [Player] and their [Score]
@freezed
class PlayerScore with _$PlayerScore {
  const factory PlayerScore({
    required Player? player,
    required Score score,
    int? place,
  }) = _PlayerScore;

  const PlayerScore._();

  String? get id => player?.id;
}
