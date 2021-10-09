import 'package:flutter/material.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../common/styles.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
    this.icon, {
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final Icon icon;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(
          Dimensions.halfStandardSpacing,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(Styles.defaultCornerRadius),
          ),
          child: Container(
            padding: const EdgeInsets.all(Dimensions.halfStandardSpacing),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withAlpha(Styles.opacity70Percent),
            ),
            child: icon,
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
