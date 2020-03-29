import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/utilities/navigator_helper.dart';
import 'package:flutter/material.dart';

class BoardGameCollectionItemDetailsIconButton extends StatelessWidget {
  const BoardGameCollectionItemDetailsIconButton({
    Key key,
    @required this.boardGameDetails,
    @required double infoIconSize,
  })  : _infoIconSize = infoIconSize,
        super(key: key);

  final double _infoIconSize;
  final BoardGameDetails boardGameDetails;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(
            Dimensions.halfStandardSpacing,
          ),
          child: InkWell(
            child: Icon(
              Icons.info,
              size: _infoIconSize,
              color: Theme.of(context).accentColor,
            ),
            onTap: () => _navigateToBoardGameDetails(
              context,
              boardGameDetails,
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _navigateToBoardGameDetails(
    BuildContext context, BoardGameDetails boardGameDetails) async {
  await NavigatorHelper.navigateToBoardGameDetails(
    context,
    boardGameDetails,
  );
}
