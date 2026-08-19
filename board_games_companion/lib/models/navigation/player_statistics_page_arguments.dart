import 'package:freezed_annotation/freezed_annotation.dart';

import '../hive/player.dart';

part 'player_statistics_page_arguments.freezed.dart';

@freezed
class PlayerStatisticsPageArguments with _$PlayerStatisticsPageArguments {
  const factory PlayerStatisticsPageArguments({
    required Player player,
  }) = _PlayerStatisticsPageArguments;
}
