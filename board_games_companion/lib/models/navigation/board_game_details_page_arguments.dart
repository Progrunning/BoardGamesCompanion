import 'package:freezed_annotation/freezed_annotation.dart';

part 'board_game_details_page_arguments.freezed.dart';

@freezed
class BoardGameDetailsPageArguments with _$BoardGameDetailsPageArguments {
  const factory BoardGameDetailsPageArguments({
    required String boardGameId,
    required String boardGameName,
    required Type navigatingFromType,
    required String boardGameImageHeroId,
    String? boardGameImageUrl,
  }) = _BoardGameDetailsPageArguments;
}
