import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/app_theme.dart';
import '../../../common/dimensions.dart';
import '../../../models/hive/board_game_expansion.dart';
import '../../../stores/board_game_details_store.dart';
import 'board_game_details_expansion_item_widget.dart';

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
                          return BoardGameDetailsExpansionItem(
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
