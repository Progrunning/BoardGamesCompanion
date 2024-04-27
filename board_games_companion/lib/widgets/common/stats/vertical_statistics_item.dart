import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../common/app_colors.dart';
import '../../../common/dimensions.dart';
import '../text/item_property_title_widget.dart';

class VerticalStatisticsItem extends StatelessWidget {
  factory VerticalStatisticsItem.withMaterialIcon({
    required IconData icon,
    required String text,
    String? subtitle,
    Color? iconColor,
    double iconSize = Dimensions.defaultStatsIconSize,
    TextStyle textStyle = const TextStyle(fontSize: Dimensions.largeFontSize),
    double spacing = Dimensions.quarterStandardSpacing,
  }) =>
      VerticalStatisticsItem._(
        icon: Icon(icon, color: iconColor, size: iconSize),
        text: text,
        iconColor: iconColor,
        iconSize: iconSize,
        spacing: spacing,
        subtitle: subtitle,
        textStyle: textStyle,
      );

  factory VerticalStatisticsItem.withFontAwesomeIcon({
    required IconData icon,
    required String text,
    String? subtitle,
    Color? iconColor,
    double iconSize = Dimensions.defaultFontAwesomeStatsIconSize,
    TextStyle textStyle = const TextStyle(fontSize: Dimensions.largeFontSize),
    double spacing = Dimensions.halfStandardSpacing,
  }) =>
      VerticalStatisticsItem._(
        icon: FaIcon(icon, color: iconColor, size: iconSize),
        text: text,
        iconColor: iconColor,
        iconSize: iconSize,
        spacing: spacing,
        subtitle: subtitle,
        textStyle: textStyle,
      );

  const VerticalStatisticsItem._({
    required this.icon,
    required this.text,
    this.subtitle,
    this.iconColor,
    this.iconSize = 28,
    this.textStyle = const TextStyle(fontSize: Dimensions.largeFontSize),
    this.spacing = Dimensions.quarterStandardSpacing,
  });

  final Widget icon;
  final double spacing;
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
            icon,
            // FaIcon(
            //   icon,
            //   color: iconColor ?? IconTheme.of(context).color,
            //   size: iconSize,
            // ),
            // const SizedBox(width: Dimensions.quarterStandardSpacing),
            SizedBox(width: spacing),
            Text(text, style: textStyle),
          ],
        ),
        SizedBox(height: spacing),
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
