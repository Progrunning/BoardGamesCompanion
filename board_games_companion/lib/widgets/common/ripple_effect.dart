import 'package:board_games_companion/common/styles.dart';
import 'package:flutter/material.dart';

class StackRippleEffect extends StatelessWidget {
  final GestureTapCallback onTap;

  const StackRippleEffect({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor:
            Theme.of(context).accentColor.withAlpha(Styles.opacity70Percent),
        onTap: onTap,
      ),
    );
  }
}
