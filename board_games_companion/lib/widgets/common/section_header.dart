import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    Key? key,
    required this.primaryWidget,
    this.secondaryWidget,
    this.height = Dimensions.sectionHeaderHeight,
    this.padding = const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
  }) : super(key: key);

  factory SectionHeader.title({
    required String primaryTitle,
    double height = Dimensions.sectionHeaderHeight,
  }) =>
      SectionHeader(
        primaryWidget: Text(
          primaryTitle,
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
      SectionHeader(
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

  factory SectionHeader.customAction({
    required String primaryTitle,
    required Widget action,
    double height = Dimensions.sectionHeaderHeight,
  }) =>
      SectionHeader(
        primaryWidget: Text(
          primaryTitle,
          style: AppTheme.titleTextStyle,
          overflow: TextOverflow.ellipsis,
        ),
        secondaryWidget: action,
        height: height,
        padding: const EdgeInsets.only(left: Dimensions.standardSpacing),
      );

  final Widget primaryWidget;
  final Widget? secondaryWidget;
  final double height;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: Dimensions.defaultElevation,
      color: AppColors.primaryColor,
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
