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
      );

  final double height;
  final Widget primaryWidget;
  final Widget? secondaryWidget;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: Dimensions.defaultElevation,
      color: AppColors.primaryColor,
      child: SizedBox(
        height: height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
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
