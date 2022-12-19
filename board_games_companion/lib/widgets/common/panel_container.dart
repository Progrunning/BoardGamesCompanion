import 'package:board_games_companion/common/app_theme.dart';
import 'package:flutter/material.dart';

import '../../common/app_styles.dart';
import '../elevated_container.dart';

class PanelContainer extends StatelessWidget {
  const PanelContainer({
    required this.child,
    this.borderRadius = AppStyles.panelContainerCornerRadius,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ElevatedContainer(
      elevation: AppStyles.defaultElevation,
      borderRadius: AppTheme.defaultBorderRadius,
      child: Container(
        decoration: AppStyles.tileGradientBoxDecoration,
        child: Material(
          color: Colors.transparent,
          child: child,
        ),
      ),
    );
  }
}
