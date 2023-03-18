import 'package:flutter/material.dart';

import '../../../common/app_colors.dart';
import '../../../common/app_styles.dart';
import '../../../common/dimensions.dart';

class FilterToggleButtonsContainer extends StatelessWidget {
  const FilterToggleButtonsContainer({
    super.key,
    required this.height,
    required this.child,
  });

  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: height,
        child: Material(
          shadowColor: AppColors.shadowColor,
          elevation: Dimensions.defaultElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyles.defaultCornerRadius),
          ),
          child: Container(
            color: AppColors.primaryColor.withAlpha(AppStyles.opacity80Percent),
            child: child,
          ),
        ),
      );
}
