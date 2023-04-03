import 'package:freezed_annotation/freezed_annotation.dart';

part 'bgg_play_player.freezed.dart';

@freezed
class BggPlayPlayer with _$BggPlayPlayer {
  const factory BggPlayPlayer({
    required String playerName,
    required String? playerBggName,
    required int? playerBggUserId,
    int? playerScore,
    bool? playerWin,
  }) = _BggPlayPlayer;

  const BggPlayPlayer._();
}
