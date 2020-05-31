import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/pages/board_game_details.dart';
import 'package:board_games_companion/stores/board_game_details_store.dart';
import 'package:board_games_companion/utilities/navigator_helper.dart';
import 'package:flutter/material.dart';

import 'board_game_details_section_header_widget.dart';

class BoardGameDetailsExpansions extends StatelessWidget {
  const BoardGameDetailsExpansions({
    Key key,
    @required BoardGameDetailsStore boardGameDetailsStore,
    @required double spacingBetweenSecions,
  })  : _boardGameDetailsStore = boardGameDetailsStore,
        _spacingBetweenSecions = spacingBetweenSecions,
        super(key: key);

  final double _spacingBetweenSecions;
  final BoardGameDetailsStore _boardGameDetailsStore;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: _spacingBetweenSecions,
        ),
        BoardGameDetailsSectionHeader(
          title: 'Expansions',
        ),
        ...List.generate(
            _boardGameDetailsStore.boardGameDetails.expansions.length, (index) {
          final expansion =
              _boardGameDetailsStore.boardGameDetails.expansions[index];
          return Material(
            color: Colors.transparent,
            child: InkWell(
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
                        expansion.name,
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
                await NavigatorHelper.navigateToBoardGameDetails(context,
                    expansion.id, expansion.name, BoardGamesDetailsPage);
              },
            ),
          );
        })
      ],
    );
  }
}
