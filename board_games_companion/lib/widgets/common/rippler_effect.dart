import 'package:board_games_companion/common/styles.dart';
import 'package:flutter/material.dart';

class RippleEffect extends StatelessWidget {
  final GestureTapCallback onTap;
  final Widget child;

  const RippleEffect({
    this.onTap,
    this.child,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor:
            Theme.of(context).accentColor.withAlpha(Styles.opacity70Percent),
        onTap: onTap,
        child: child,
      ),
    );
  }
}
