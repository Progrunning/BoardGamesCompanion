import 'package:board_games_companion/models/hive/board_game_expansion.dart';
import 'package:board_games_companion/stores/board_game_details_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'board_game_details_expansion_item_widget.dart';
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
          _boardGameDetailsStore.boardGameDetails.expansions.length,
          (index) {
            final expansion =
                _boardGameDetailsStore.boardGameDetails.expansions[index];

            return ChangeNotifierProvider<BoardGamesExpansion>.value(
              value: expansion,
              child: Consumer<BoardGamesExpansion>(
                builder: (_, store, __) {
                  return BoardGameDetailsExpansionItem(
                    boardGamesExpansion: expansion,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
