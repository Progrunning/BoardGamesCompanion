import 'package:flutter/material.dart';

import '../common/app_colors.dart';

class BottomTabIcon extends StatelessWidget {
  const BottomTabIcon({
    required this.iconData,
    this.isActive = false,
    super.key,
  });

  final IconData iconData;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      color: isActive ? AppColors.activeBottomTabColor : AppColors.inactiveBottomTabColor,
    );
  }
}
