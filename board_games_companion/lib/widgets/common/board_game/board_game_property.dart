import 'package:flutter/material.dart';

import '../../../common/app_colors.dart';
import '../../../common/app_theme.dart';
import '../../../common/dimensions.dart';

class BoardGameProperty extends StatelessWidget {
  const BoardGameProperty({
    super.key,
    required this.icon,
    required this.iconWidth,
    required this.propertyName,
    this.fontSize = Dimensions.standardFontSize,
  });

  final Widget icon;
  final String propertyName;
  final double fontSize;

  /// Reuquired to specify because widget can be anything and might not behave as an icon (e.g. [RatingHexagon])
  final double iconWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: iconWidth, child: Center(child: icon)),
        const SizedBox(width: Dimensions.standardSpacing),
        Text(
          propertyName,
          overflow: TextOverflow.ellipsis,
          style: AppTheme.subTitleTextStyle.copyWith(
            color: AppColors.whiteColor,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}
