import 'package:flutter/material.dart';

import '../../../common/app_colors.dart';
import '../../../common/app_theme.dart';
import '../../../common/dimensions.dart';

class AppBarBottomTab extends StatelessWidget {
  const AppBarBottomTab(
    this.title,
    this.icon, {
    this.isSelected = true,
    Key? key,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Tab(
          icon: Icon(
            icon,
            color: isSelected ? AppColors.selectedTabIconColor : AppColors.deselectedTabIconColor,
          ),
          iconMargin: const EdgeInsets.only(bottom: Dimensions.halfStandardSpacing),
          child: Text(
            title,
            style: AppTheme.titleTextStyle.copyWith(
              fontSize: Dimensions.standardFontSize,
              color: isSelected ? AppColors.defaultTextColor : AppColors.deselectedTabIconColor,
            ),
          ),
        ),
      ],
    );
  }
}
