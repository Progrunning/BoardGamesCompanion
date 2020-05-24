import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/stores/board_games_filters_store.dart';
import 'package:flutter/material.dart';

import 'collection_filter_rating_value_widget.dart';
import 'collection_filter_rating_any_value_widget.dart';

class CollectionFilterPanelFilters extends StatelessWidget {
  const CollectionFilterPanelFilters({
    @required BoardGamesFiltersStore boardGamesFiltersStore,
    Key key,
  })  : _boardGamesFiltersStore = boardGamesFiltersStore,
        super(key: key);

  final BoardGamesFiltersStore _boardGamesFiltersStore;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
        SizedBox(
          height: Dimensions.standardSpacing,
        ),
        Container(
          height: Dimensions.collectionFilterHexagonSize +
              Dimensions.doubleStandardSpacing,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(
              Styles.defaultCornerRadius,
            ),
            boxShadow: [
              // TODO MK These numbers were based on the color comparison with the sort by chips and their shadow generated from the SDK
              BoxShadow(
                color: AppTheme.shadowColor.withAlpha(
                  Styles.opacity30Percent,
                ),
                blurRadius: 2,
                offset: const Offset(1.5, 1.5),
              ),
            ],
          ),
          child: Container(
            color: AppTheme.primaryColor.withAlpha(
              Styles.opacity80Percent,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CollectionFilterRatingAnyValueWidget(
                  boardGamesFiltersStore: _boardGamesFiltersStore,
                ),
                CollectionFilterRatingValueWidget(
                  rating: 6.5,
                  boardGamesFiltersStore: _boardGamesFiltersStore,
                ),
                CollectionFilterRatingValueWidget(
                  rating: 7.5,
                  boardGamesFiltersStore: _boardGamesFiltersStore,
                ),
                CollectionFilterRatingValueWidget(
                  rating: 8.0,
                  boardGamesFiltersStore: _boardGamesFiltersStore,
                ),
                CollectionFilterRatingValueWidget(
                  rating: 8.5,
                  boardGamesFiltersStore: _boardGamesFiltersStore,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
