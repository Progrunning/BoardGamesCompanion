import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final Icon icon;
  final GestureTapCallback onTap;

  const CustomIconButton(
    this.icon, {
    @required this.onTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(
          Dimensions.halfStandardSpacing,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(Styles.defaultCornerRadius),
          ),
          child: Container(
            padding: const EdgeInsets.all(Dimensions.halfStandardSpacing),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .accentColor
                  .withAlpha(Styles.opacity70Percent),
            ),
            child: icon,
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
