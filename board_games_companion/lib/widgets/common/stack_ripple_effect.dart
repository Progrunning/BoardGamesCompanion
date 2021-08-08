import 'package:flutter/material.dart';

import 'rippler_effect.dart';

class StackRippleEffect extends StatelessWidget {
  const StackRippleEffect({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return RippleEffect(
      onTap: onTap,
    );
  }
}
