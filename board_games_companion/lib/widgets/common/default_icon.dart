import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/dimensions.dart';

class DefaultIcon extends StatelessWidget {
  const DefaultIcon(
    IconData icon, {
    Color color = AppColors.defaultTextColor,
    super.key,
  })  : _icon = icon,
        _color = color;

  final IconData _icon;
  final Color _color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      _icon,
      color: _color,
      size: Dimensions.defaultButtonIconSize,
    );
  }
}
