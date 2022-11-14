import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'board_game_playthrough.freezed.dart';

@freezed
class BoardGamePlaythrough with _$BoardGamePlaythrough {
  const factory BoardGamePlaythrough({
    required Playthrough playthrough,
    required BoardGameDetails boardGameDetails,
  }) = _BoardGamePlaythrough;
}
