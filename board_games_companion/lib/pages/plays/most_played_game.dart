import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/hive/board_game_details.dart';

part 'most_played_game.freezed.dart';

@freezed
class MostPlayedGame with _$MostPlayedGame {
  const factory MostPlayedGame({
    required BoardGameDetails boardGameDetails,
    required int totalNumberOfPlays,
    required int totalTimePlayedInSeconds,
  }) = _MostPlayedGame;

  const MostPlayedGame._();
}
