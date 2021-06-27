import 'package:board_games_companion/stores/board_game_details_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../models/hive/board_game_expansion.dart';
import '../../utilities/navigator_helper.dart';
import '../../widgets/common/expansions_banner_widget.dart';
import 'board_game_details_page.dart';

class BoardGameDetailsExpansions extends StatefulWidget {
  const BoardGameDetailsExpansions({
    Key key,
    @required this.boardGameDetailsStore,
    @required this.spacingBetweenSecions,
  }) : super(key: key);

  final BoardGameDetailsStore boardGameDetailsStore;
  final double spacingBetweenSecions;

  @override
  _BoardGameDetailsExpansionsState createState() =>
      _BoardGameDetailsExpansionsState();
}

class _BoardGameDetailsExpansionsState
    extends State<BoardGameDetailsExpansions> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: widget.spacingBetweenSecions,
        ),
        Material(
          color: Colors.transparent,
          child: Theme(
            data: AppTheme.theme.copyWith(
              unselectedWidgetColor: AppTheme.accentColor,
            ),
            child: ExpansionTile(
              title: Text(
                'Expansions (${widget.boardGameDetailsStore.boardGameDetails.expansions.length})',
                style: TextStyle(
                  fontSize: Dimensions.standardFontSize,
                ),
              ),
              subtitle: Text(
                widget.boardGameDetailsStore.boardGameDetails.expansionsOwned ==
                        0
                    ? 'You don\'t own any expansions'
                    : 'You own ${widget.boardGameDetailsStore.boardGameDetails.expansionsOwned} expansion(s)',
                style: TextStyle(
                  color: AppTheme.defaultTextColor,
                  fontSize: Dimensions.smallFontSize,
                ),
              ),
              tilePadding: EdgeInsets.symmetric(
                horizontal: Dimensions.standardSpacing,
              ),
              children: [
                ...List.generate(
                  widget
                      .boardGameDetailsStore.boardGameDetails.expansions.length,
                  (index) {
                    final expansion = widget.boardGameDetailsStore
                        .boardGameDetails.expansions[index];

                    return ChangeNotifierProvider<BoardGamesExpansion>.value(
                      value: expansion,
                      child: Consumer<BoardGamesExpansion>(
                        builder: (_, store, __) {
                          return _ExpansionListItem(
                            boardGamesExpansion: expansion,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ExpansionListItem extends StatelessWidget {
  const _ExpansionListItem({
    Key key,
    @required BoardGamesExpansion boardGamesExpansion,
  })  : _boardGameExpansion = boardGamesExpansion,
        super(key: key);

  final BoardGamesExpansion _boardGameExpansion;

  @override
  Widget build(BuildContext context) {
    Widget expansionItemWidget = InkWell(
      splashColor: AppTheme.accentColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Dimensions.doubleStandardSpacing,
          horizontal: Dimensions.standardSpacing,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Text(
                _boardGameExpansion.name,
                style: AppTheme.theme.textTheme.headline3,
              ),
            ),
            Icon(
              Icons.navigate_next,
              color: AppTheme.accentColor,
            ),
          ],
        ),
      ),
      onTap: () async {
        await NavigatorHelper.navigateToBoardGameDetails(
          context,
          _boardGameExpansion.id,
          _boardGameExpansion.name,
          BoardGamesDetailsPage,
        );
      },
    );

    if (_boardGameExpansion.isInCollection ?? false) {
      expansionItemWidget = ClipRect(
        child: CustomPaint(
          foregroundPainter: ExpanionsBannerPainter(
            location: BannerLocation.topStart,
            color: AppTheme.accentColor,
            message: 'own',
          ),
          child: expansionItemWidget,
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: expansionItemWidget,
    );
  }
}
