import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/widgets/board_games/details/board_game_details_credits_item_widget.dart';
import 'package:flutter/material.dart';

class BoardGameDetailsCredits extends StatelessWidget {
  const BoardGameDetailsCredits({
    @required boardGameDetails,
    Key key,
  })  : _boardGameDetails = boardGameDetails,
        super(key: key);

  final BoardGameDetails _boardGameDetails;

  static const _spacingBetweenCredits = Dimensions.standardSpacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        BoardGameDetailsCreditsItem(
          title: 'Designer:',
          detail: _boardGameDetails?.desingers?.map((d) => d.name)?.join(', '),
        ),
        SizedBox(
          height: _spacingBetweenCredits,
        ),
        BoardGameDetailsCreditsItem(
          title: 'Artist:',
          detail: _boardGameDetails?.artists?.map((d) => d.name)?.join(', '),
        ),
        SizedBox(
          height: _spacingBetweenCredits,
        ),
        Container(
          child: BoardGameDetailsCreditsItem(
            title: 'Publisher:',
            detail:
                _boardGameDetails?.publishers?.map((d) => d.name)?.join(', '),
          ),
        ),
      ],
    );
  }
}
