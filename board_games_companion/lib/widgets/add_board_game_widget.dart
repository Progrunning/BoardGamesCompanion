import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:flutter/material.dart';

class AddBoardGameButton extends StatelessWidget {
  final GestureTapCallback onPressed;

  const AddBoardGameButton({@required this.onPressed, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: Theme.of(context).accentColor,
      splashColor:
          Theme.of(context).accentColor.withAlpha(Styles.opacity70Percent),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.doubleStandardSpacing,
          vertical: Dimensions.halfStandardSpacing,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.add,
              color: Colors.white,
            ),
            Divider(
              indent: Dimensions.halfStandardSpacing,
            ),
            Text(
              'Add Game',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      onPressed: onPressed,
      shape: const StadiumBorder(),
    );
  }
}
