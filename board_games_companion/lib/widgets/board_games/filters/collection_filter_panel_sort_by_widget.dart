import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/stores/board_games_filters_store.dart';
import 'package:flutter/material.dart';

import 'collection_sort_by_chip_widget.dart';

class CollectionFilterPanelSortBy extends StatelessWidget {
  const CollectionFilterPanelSortBy({
    Key key,
    @required BoardGamesFiltersStore boardGamesFiltersStore,
  })  : _boardGamesFiltersStore = boardGamesFiltersStore,
        super(key: key);

  final BoardGamesFiltersStore _boardGamesFiltersStore;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Sort by',
          style: AppTheme.titleTextStyle,
        ),
        Wrap(
          spacing: Dimensions.standardSpacing,
          children: List<Widget>.generate(
            _boardGamesFiltersStore.sortBy.length,
            (index) {
              return SortByChip(
                sortBy: _boardGamesFiltersStore.sortBy[index],
                boardGamesFiltersStore: _boardGamesFiltersStore,
              );
            },
          ),
        ),
        SizedBox(
          height: Dimensions.doubleStandardSpacing,
        ),
        Text(
          'Filter by',
          style: AppTheme.titleTextStyle,
        ),
        SizedBox(
          height: Dimensions.standardSpacing,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Rating',
            style: AppTheme.sectionHeaderTextStyle,
          ),
        ),
      ],
    );
  }
}
