import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common/enums/collection_type.dart';

part 'game_spinner_filters.freezed.dart';

@freezed
class GameSpinnerFilters with _$GameSpinnerFilters {
  const factory GameSpinnerFilters({
    required Set<CollectionType> collections,
    required bool includeExpansions,
    @Default(NumberOfPlayersFilter.any()) NumberOfPlayersFilter numberOfPlayersFilter,
    @Default(PlaytimeFilter.any()) PlaytimeFilter playtimeFilter,
  }) = _GameSpinnerFilters;

  const GameSpinnerFilters._();

  bool get hasOwnedCollection => collections.contains(CollectionType.owned);

  bool get hasFriendsCollection => collections.contains(CollectionType.friends);
}

@freezed
class NumberOfPlayersFilter with _$NumberOfPlayersFilter {
  const factory NumberOfPlayersFilter.any() = _numberOfPlayersAny;
  const factory NumberOfPlayersFilter.singlePlayerOnly() = _singlePlayerOnly;
  const factory NumberOfPlayersFilter.moreThan({required int moreThanNumberOfPlayers}) = _moreThan;
}

@freezed
class PlaytimeFilter with _$PlaytimeFilter {
  const factory PlaytimeFilter.any() = _playtimeAny;
  const factory PlaytimeFilter.lessThan({required int playtimeInMinutes}) = _lessThan;
}
