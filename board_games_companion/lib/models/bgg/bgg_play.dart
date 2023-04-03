import 'package:freezed_annotation/freezed_annotation.dart';

import 'bgg_play_player.dart';

part 'bgg_play.freezed.dart';

@freezed
abstract class BggPlay with _$BggPlay {
  const factory BggPlay({
    required int id,
    required String boardGameId,
    required int? playTimeInMinutes,
    required DateTime? playDate,
    required bool completed,
    required List<BggPlayPlayer> players,
  }) = _BggPlay;

  const BggPlay._();
}
