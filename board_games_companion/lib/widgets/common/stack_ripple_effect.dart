import 'package:board_games_companion/widgets/common/rippler_effect.dart';
import 'package:flutter/material.dart';

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
