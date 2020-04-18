import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/widgets/board_games/details/board_game_details_info_panel_widget.dart';
import 'package:flutter/material.dart';

class BoardGameDetailsSecondRowInfoPanels extends StatelessWidget {
  const BoardGameDetailsSecondRowInfoPanels({
    @required boardGameDetails,
    Key key,
  })  : _boardGameDetails = boardGameDetails,
        super(key: key);

  final BoardGameDetails _boardGameDetails;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Flexible(
            child: BoardGameDetailsInfoPanel(
              title: 'Age: ${_boardGameDetails.minAge}+',
            ),
          ),
          SizedBox(
            width: Dimensions.standardSpacing,
          ),
          Flexible(
            child: BoardGameDetailsInfoPanel(
              title: 'Weight: ${_boardGameDetails.avgWeight?.toStringAsFixed(2)} / 5',
              subtitle: 'Complexity Rating',
            ),
          ),
        ],
      ),
    );
  }
}
