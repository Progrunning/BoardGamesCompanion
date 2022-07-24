import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/dimensions.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
    this.icon, {
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final Icon icon;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(
          Dimensions.halfStandardSpacing,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(AppStyles.defaultCornerRadius),
          ),
          child: Container(
            padding: const EdgeInsets.all(Dimensions.halfStandardSpacing),
            decoration: BoxDecoration(
              color: AppColors.accentColor.withAlpha(AppStyles.opacity70Percent),
            ),
            child: icon,
          ),
        ),
      ),
    );
  }
}
