import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:flutter/material.dart';

import 'collection_filter_rating_value_widget.dart';
import 'colletion_filter_rating_value_container_widget.dart';

class CollectionFilterPanelFilters extends StatelessWidget {
  const CollectionFilterPanelFilters({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimensions.collectionFilterHexagonSize + Dimensions.doubleStandardSpacing,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withAlpha(
          Styles.opacity80Percent,
        ),
        borderRadius: BorderRadius.circular(
          Styles.defaultCornerRadius,
        ),
        boxShadow: [AppTheme.defaultBoxShadow],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ColletionFilterRatingValueContainerWidget(
              child: Center(
                child: Text('Any'),
              ),
            ),
          ),
          CollectionFilterRatingValueWidget(
            rating: 6.5,
          ),
          CollectionFilterRatingValueWidget(
            rating: 7.5,
          ),
          CollectionFilterRatingValueWidget(
            rating: 8.0,
          ),
          CollectionFilterRatingValueWidget(
            rating: 8.5,
            isSelected: true,
          ),
        ],
      ),
    );
  }
}
