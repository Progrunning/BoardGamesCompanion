import 'package:flutter/material.dart';

import '../../../common/app_colors.dart';
import '../../../common/app_theme.dart';
import '../../../common/dimensions.dart';

class ItemPropertyTitle extends StatelessWidget {
  const ItemPropertyTitle(
    this.title, {
    this.color = AppColors.secondaryTextColor,
    this.fontSize = Dimensions.extraSmallFontSize,
    Key? key,
  }) : super(key: key);

  final String title;
  final Color color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTheme.sectionHeaderTextStyle.copyWith(
        color: color,
        fontSize: fontSize,
      ),
    );
  }
}
