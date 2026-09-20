import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/dimensions.dart';

class BottomSheetHandle extends StatelessWidget {
  const BottomSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.accentColor,
          borderRadius: BorderRadius.circular(AppStyles.defaultCornerRadius),
        ),
        child: const SizedBox(
          height: Dimensions.halfStandardSpacing,
          width: Dimensions.trippleStandardSpacing,
        ),
      ),
    );
  }
}
