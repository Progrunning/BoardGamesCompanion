import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/app_theme.dart';

class ShadowBox extends StatelessWidget {
  const ShadowBox({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(      
      decoration: const BoxDecoration(
        boxShadow: [AppTheme.defaultBoxShadow],                
      ),
      child: child,
    );
  }
}
