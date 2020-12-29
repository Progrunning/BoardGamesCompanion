import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/stores/board_games_filters_store.dart';
import 'package:flutter/material.dart';

import 'collection_filter_number_of_players_slider_widget.dart';
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
        SizedBox(
          height: Dimensions.collectionFilterHexagonSize +
              Dimensions.doubleStandardSpacing,
          child: Material(
            shadowColor: AppTheme.shadowColor,
            elevation: Dimensions.defaultElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                Styles.defaultCornerRadius,
              ),
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
        ),
        SizedBox(
          height: Dimensions.doubleStandardSpacing,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Number of players',
            style: AppTheme.sectionHeaderTextStyle,
          ),
        ),        
        CollectionFilterNumberOfPlayersSliderWidget(
          boardGamesFiltersStore: _boardGamesFiltersStore,
        ),
      ],
    );
  }
}
