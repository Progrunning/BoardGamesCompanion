import 'package:board_games_companion/common/app_theme.dart';
import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../elevated_container.dart';

class PanelContainer extends StatelessWidget {
  const PanelContainer({
    required this.child,
    this.borderRadius = AppStyles.defaultCornerRadius * 3,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ElevatedContainer(
      elevation: AppStyles.defaultElevation,
      borderRadius: AppTheme.defaultBoxRadius,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.5, 0),
            end: Alignment(0.5, 1),
            colors: [
              AppColors.startDefaultPageElementBackgroundColorGradient,
              AppColors.endDefaultPageElementBackgroundColorGradient,
            ],
          ),
          borderRadius: AppTheme.defaultBoxRadius,
        ),
        child: child,
      ),
    );
  }
}
