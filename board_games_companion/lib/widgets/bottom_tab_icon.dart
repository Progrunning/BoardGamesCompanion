import 'package:flutter/material.dart';

import '../common/app_theme.dart';

class BottomTabIcon extends StatelessWidget {
  const BottomTabIcon({
    required this.iconData,
    this.isActive = false,
    Key? key,
  }) : super(key: key);

  final IconData iconData;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      color: isActive ? AppTheme.activeBottomTabColor : AppTheme.inactiveBottomTabColor,
    );
  }
}