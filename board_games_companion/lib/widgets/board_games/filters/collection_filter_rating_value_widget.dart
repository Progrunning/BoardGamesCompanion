import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/stores/board_games_filters_store.dart';
import 'package:flutter/material.dart';

import '../board_game_rating_hexagon_widget.dart';
import 'colletion_filter_rating_value_container_widget.dart';

class CollectionFilterRatingValueWidget extends StatelessWidget {
  const CollectionFilterRatingValueWidget({
    Key key,
    @required double rating,
    @required BoardGamesFiltersStore boardGamesFiltersStore,
  })  : _rating = rating,
        _boardGamesFiltersStore = boardGamesFiltersStore,
        super(key: key);

  final double _rating;
  final BoardGamesFiltersStore _boardGamesFiltersStore;

  @override
  Widget build(BuildContext context) {
    final isSelected = _rating == _boardGamesFiltersStore?.filterByRating;
    final boardGameRatingHexagon = BoardGameRatingHexagon(
      width: Dimensions.collectionFilterHexagonSize,
      height: Dimensions.collectionFilterHexagonSize,
      rating: _rating,
      fontSize: Dimensions.smallFontSize,
      hexColor: isSelected ? AppTheme.primaryColor : AppTheme.accentColor,
    );
    final centeredBoardGameRatingHexagon = Center(
      child: boardGameRatingHexagon,
    );

    if (isSelected) {
      final selectionContainer = ColletionFilterRatingValueContainerWidget(
        child: centeredBoardGameRatingHexagon,
      );

      return Expanded(
        child: selectionContainer,
      );
    }

    return Expanded(
      child: InkWell(
        child: centeredBoardGameRatingHexagon,
        onTap: () {
          _boardGamesFiltersStore.updateFilterByRating(_rating);
        },
      ),
    );
  }
}
