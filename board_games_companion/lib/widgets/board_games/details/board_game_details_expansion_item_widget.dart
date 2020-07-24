import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/hive/board_game_expansion.dart';
import 'package:board_games_companion/pages/board_game_details.dart';
import 'package:board_games_companion/utilities/navigator_helper.dart';
import 'package:board_games_companion/widgets/common/expansions_banner_widget.dart';
import 'package:flutter/material.dart';

class BoardGameDetailsExpansionItem extends StatelessWidget {
  const BoardGameDetailsExpansionItem({
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
