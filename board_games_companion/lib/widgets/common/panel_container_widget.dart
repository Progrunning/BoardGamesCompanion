import 'package:flutter/material.dart';

import '../../common/app_theme.dart';
import '../../common/styles.dart';

class PanelContainer extends StatelessWidget {
  final Widget _child;
  final double _borderRadius;

  const PanelContainer({
    @required child,
    borderRadius = Styles.defaultCornerRadius * 3,
    Key key,
  })  : _child = child,
        _borderRadius = borderRadius,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(          
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),          
          colors: [
            AppTheme.startDefaultPageElementBackgroundColorGradient,
            AppTheme.endDefaultPageElementBackgroundColorGradient,
          ],
        ),
        boxShadow: [
          AppTheme.defaultBoxShadow
        ],
        borderRadius: BorderRadius.circular(
          _borderRadius,
        ),
      ),
      child: _child,
    );
  }
}
