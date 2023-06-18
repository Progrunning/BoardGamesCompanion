import 'package:flutter/material.dart';

import '../../../common/app_colors.dart';
import '../../../common/app_styles.dart';
import '../../../common/dimensions.dart';
import '../../elevated_container.dart';

class BgcSegmentedButtonsContainer extends StatelessWidget {
  const BgcSegmentedButtonsContainer({
    super.key,
    required this.height,
    required this.child,
    this.backgroundColor = AppColors.primaryColor,
    this.width,
  });

  final double height;
  final double? width;
  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: height,
        width: width,
        child: ElevatedContainer(
          elevation: Dimensions.defaultElevation,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(AppStyles.toggleButtonsCornerRadius),
            ),
            child: child,
          ),
        ),
      );
}
