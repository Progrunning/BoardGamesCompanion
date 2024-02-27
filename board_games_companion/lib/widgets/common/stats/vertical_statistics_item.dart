import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../common/app_colors.dart';
import '../../../common/dimensions.dart';
import '../text/item_property_title_widget.dart';

class VerticalStatisticsItem extends StatelessWidget {
  const VerticalStatisticsItem({
    super.key,
    required this.icon,
    required this.text,
    this.subtitle,
    this.iconColor,
    this.iconSize = 28,
    this.textStyle = const TextStyle(fontSize: Dimensions.largeFontSize),
  });

  final IconData icon;
  final double iconSize;
  final Color? iconColor;

  final String text;
  final TextStyle textStyle;

  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FaIcon(
              icon,
              color: iconColor ?? IconTheme.of(context).color,
              size: iconSize,
            ),
            const SizedBox(width: Dimensions.quarterStandardSpacing),
            Text(text, style: textStyle),
          ],
        ),
        const SizedBox(height: Dimensions.quarterStandardSpacing),
        if (subtitle.isNotNullOrBlank)
          ItemPropertyTitle(
            subtitle!,
            color: AppColors.defaultTextColor,
            fontSize: Dimensions.smallFontSize,
          ),
      ],
    );
  }
}
