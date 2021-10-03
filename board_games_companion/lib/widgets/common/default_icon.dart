import 'package:flutter/material.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';

class DefaultIcon extends StatelessWidget {
  const DefaultIcon(
    IconData icon, {
    Key? key,
  })  : _icon = icon,
        super(key: key);

  final IconData _icon;

  @override
  Widget build(BuildContext context) {
    return Icon(
      _icon,
      color: AppTheme.defaultTextColor,
      size: Dimensions.defaultButtonIconSize,
    );
  }
}
