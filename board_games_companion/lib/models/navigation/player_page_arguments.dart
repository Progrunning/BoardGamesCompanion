import 'package:freezed_annotation/freezed_annotation.dart';

import '../hive/player.dart';

part 'player_page_arguments.freezed.dart';

@freezed
class PlayerPageArguments with _$PlayerPageArguments {
  const factory PlayerPageArguments({
    Player? player,
  }) = _PlayerPageArguments;
}
