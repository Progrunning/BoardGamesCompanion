import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common/enums/collection_type.dart';

part 'game_spinner_filters.freezed.dart';

@freezed
class GameSpinnerFilters with _$GameSpinnerFilters {
  const factory GameSpinnerFilters({
    required Set<CollectionType> collections,
    required bool includeExpansions,
  }) = _GameSpinnerFilters;

  const GameSpinnerFilters._();

  bool get hasOwnedCollection => collections.contains(CollectionType.owned);

  bool get hasFriendsCollection => collections.contains(CollectionType.friends);
}
