import 'package:flutter/material.dart';

import '../../common/styles.dart';

class RippleEffect extends StatelessWidget {
  const RippleEffect({
    this.onTap,
    this.child,
    Key key,
  }) : super(key: key);

  final GestureTapCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Theme.of(context).accentColor.withAlpha(Styles.opacity70Percent),
        onTap: onTap,
        child: child,
      ),
    );
  }
}
