import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/stores/board_games_filters_store.dart';
import 'package:flutter/material.dart';

import 'colletion_filter_rating_value_container_widget.dart';

class CollectionFilterRatingAnyValueWidget extends StatelessWidget {
  const CollectionFilterRatingAnyValueWidget({
    Key key,
    @required BoardGamesFiltersStore boardGamesFiltersStore,
  })  : _boardGamesFiltersStore = boardGamesFiltersStore,
        super(key: key);

  final BoardGamesFiltersStore _boardGamesFiltersStore;

  @override
  Widget build(BuildContext context) {
    final isSelected = _boardGamesFiltersStore?.filterByRating == null;
    final anyRating = Center(
      child: Text(
        'Any',
        style: TextStyle(
          color: isSelected
              ? AppTheme.defaultTextColor
              : AppTheme.secondaryTextColor,
        ),
      ),
    );

    if (isSelected) {
      return Expanded(
        child: ColletionFilterRatingValueContainerWidget(
          child: anyRating,
        ),
      );
    }
    return Expanded(
      child: InkWell(
        child: anyRating,
        onTap: () {
          _boardGamesFiltersStore.updateFilterByRating(null);
        },
      ),
    );
  }
}
