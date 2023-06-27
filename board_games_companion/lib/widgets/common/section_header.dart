import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader._({
    Key? key,
    required this.primaryWidget,
    this.secondaryWidget,
    this.height = Dimensions.sectionHeaderHeight,
    this.padding = const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
    this.borderRadius,
  }) : super(key: key);

  factory SectionHeader.title({
    required String title,
    double height = Dimensions.sectionHeaderHeight,
  }) =>
      SectionHeader._(
        primaryWidget: Text(
          title,
          style: AppTheme.titleTextStyle,
          overflow: TextOverflow.ellipsis,
        ),
        height: height,
      );

  factory SectionHeader.titles({
    required String primaryTitle,
    required String secondaryTitle,
    double height = Dimensions.sectionHeaderHeight,
  }) =>
      SectionHeader._(
        primaryWidget: Text(
          primaryTitle,
          style: AppTheme.titleTextStyle,
          overflow: TextOverflow.ellipsis,
        ),
        secondaryWidget: Text(
          secondaryTitle,
          style: AppTheme.titleTextStyle,
          overflow: TextOverflow.ellipsis,
        ),
        height: height,
      );

  factory SectionHeader.titleWithAction({
    required String title,
    required Widget action,
    double height = Dimensions.sectionHeaderHeight,
  }) =>
      SectionHeader._(
        primaryWidget: Text(
          title,
          style: AppTheme.titleTextStyle,
          overflow: TextOverflow.ellipsis,
        ),
        secondaryWidget: action,
        height: height,
        padding: const EdgeInsets.only(left: Dimensions.standardSpacing),
      );

  factory SectionHeader.titleWithIcon({
    required String title,
    required Widget icon,
    BorderRadius? borderRadius,
    double height = Dimensions.sectionHeaderHeight,
  }) =>
      SectionHeader._(
        primaryWidget: Row(
          children: [
            icon,
            const SizedBox(width: Dimensions.standardSpacing),
            Text(
              title,
              style: AppTheme.titleTextStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        height: height,
        padding: const EdgeInsets.only(left: Dimensions.standardSpacing),
        borderRadius: borderRadius,
      );

  final Widget primaryWidget;
  final Widget? secondaryWidget;
  final double height;
  final EdgeInsets padding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: Dimensions.defaultElevation,
      color: AppColors.primaryColor,
      borderRadius: borderRadius,
      child: SizedBox(
        height: height,
        child: Padding(
          padding: padding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              primaryWidget,
              if (secondaryWidget != null) ...[
                const Spacer(),
                secondaryWidget!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
