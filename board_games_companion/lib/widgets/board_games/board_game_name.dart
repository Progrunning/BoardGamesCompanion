import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/dimensions.dart';

class BoardGameName extends StatelessWidget {
  const BoardGameName({
    super.key,
    required this.name,
    this.fontSize = Dimensions.smallFontSize,
  });

  final String name;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: Dimensions.standardSpacing,
        left: Dimensions.halfStandardSpacing,
        right: Dimensions.standardSpacing,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.accentColor.withAlpha(AppStyles.opacity70Percent),
          borderRadius: const BorderRadius.all(Radius.circular(AppStyles.defaultCornerRadius)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.halfStandardSpacing),
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.defaultTextColor,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
