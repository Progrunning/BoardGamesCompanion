import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/stores/board_games_filters_store.dart';
import 'package:board_games_companion/widgets/board_games/collection_sort_by_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CollectionFilterPanel extends StatelessWidget {
  const CollectionFilterPanel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BoardGamesFiltersStore>(
      builder: (_, store, __) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.65,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: Dimensions.standardSpacing,
                top: Dimensions.doubleStandardSpacing,
                right: Dimensions.standardSpacing,
                bottom: Dimensions.standardSpacing,
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    'Sort by',
                    style: AppTheme.titleTextStyle,
                  ),
                  Wrap(
                    spacing: Dimensions.standardSpacing,
                    children: List<Widget>.generate(
                      store.sortBy.length,
                      (index) {
                        return SortByChip(
                          sortBy: store.sortBy[index],
                          boardGamesFiltersStore: store,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
