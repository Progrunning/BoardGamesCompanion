import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/pages/board_game_details.dart';
import 'package:board_games_companion/stores/board_game_details_store.dart';
import 'package:board_games_companion/utilities/navigator_transitions.dart';
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
                ),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        expansion.name,
                        style: AppTheme.theme.textTheme.headline3,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.navigate_next,
                        color: AppTheme.accentColor,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () async {
                await Navigator.push(
                  context,
                  NavigatorTransitions.fadeThrough(
                    (_, __, ___) {
                      return BoardGamesDetailsPage(
                        _boardGameDetailsStore,
                        expansion.id,
                        expansion.name,
                      );
                    },
                  ),
                );
              },
            ),
          );
        })
      ],
    );
  }
}
