import 'package:flutter/material.dart';

import '../../common/app_theme.dart';
import '../../common/styles.dart';

class RippleEffect extends StatelessWidget {
  const RippleEffect({
    required this.onTap,
    this.child,
    this.backgroundColor = Colors.transparent,
    this.splashColor,
    this.highlightColor = Colors.transparent,
    this.borderRadius,
    this.elevation,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onTap;
  final Widget? child;
  final Color backgroundColor;
  final Color? splashColor;
  final Color highlightColor;
  final BorderRadius? borderRadius;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: borderRadius,
      elevation: elevation ?? 0,
      child: InkWell(
        highlightColor: highlightColor,
        splashColor: splashColor ?? AppTheme.accentColor.withAlpha(Styles.opacity70Percent),
        borderRadius: borderRadius,
        onTap: onTap,
        child: child,
      ),
    );
  }
}
