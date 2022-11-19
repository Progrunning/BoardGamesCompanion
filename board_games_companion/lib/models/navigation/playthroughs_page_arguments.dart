import 'package:freezed_annotation/freezed_annotation.dart';

import '../hive/board_game_details.dart';

part 'playthroughs_page_arguments.freezed.dart';

@freezed
class PlaythroughsPageArguments with _$PlaythroughsPageArguments {
  const factory PlaythroughsPageArguments({
    required BoardGameDetails boardGameDetails,
    required String boardGameImageHeroId,
  }) = _PlaythroughsPageArguments;
}
