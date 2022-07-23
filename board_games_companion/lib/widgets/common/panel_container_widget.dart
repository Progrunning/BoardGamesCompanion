import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/app_theme.dart';
import '../../common/styles.dart';

class PanelContainer extends StatelessWidget {
  const PanelContainer({
    required this.child,
    this.borderRadius = Styles.defaultCornerRadius * 3,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            AppColors.startDefaultPageElementBackgroundColorGradient,
            AppColors.endDefaultPageElementBackgroundColorGradient,
          ],
        ),
        boxShadow: const [AppTheme.defaultBoxShadow],
        borderRadius: BorderRadius.circular(
          borderRadius,
        ),
      ),
      child: child,
    );
  }
}
