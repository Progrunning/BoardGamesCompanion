import 'package:freezed_annotation/freezed_annotation.dart';

import '../hive/player.dart';

part 'playthrough_player.freezed.dart';

@freezed
class PlaythroughPlayer with _$PlaythroughPlayer {
  const factory PlaythroughPlayer({
    required Player player,
    @Default(false) bool isChecked,
  }) = _PlaythroughPlayer;
}
