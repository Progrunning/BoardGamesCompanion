import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:flutter/material.dart';

import '../board_game_rating_hexagon_widget.dart';
import 'colletion_filter_rating_value_container_widget.dart';

class CollectionFilterRatingValueWidget extends StatelessWidget {
  const CollectionFilterRatingValueWidget({
    Key key,
    @required rating,
    isSelected = false,
  })  : _rating = rating,
        _isSelected = isSelected,
        super(key: key);

  final double _rating;
  final bool _isSelected;

  @override
  Widget build(BuildContext context) {
    final boardGameRatingHexagon = BoardGameRatingHexagon(
      width: Dimensions.collectionFilterHexagonSize,
      height: Dimensions.collectionFilterHexagonSize,
      rating: _rating,
      fontSize: Dimensions.smallFontSize,
      hexColor: _isSelected ? AppTheme.primaryColor : AppTheme.accentColor,
    );
    final centeredBoardGameRatingHexagon = Center(
      child: boardGameRatingHexagon,
    );

    if (_isSelected) {
      final selectionContainer = ColletionFilterRatingValueContainerWidget(
        child: centeredBoardGameRatingHexagon,
      );

      return Expanded(
        child: selectionContainer,
      );
    }

    return Expanded(
      child: centeredBoardGameRatingHexagon,
    );
  }
}
