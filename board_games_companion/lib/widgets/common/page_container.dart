import 'package:flutter/material.dart';

import '../../common/app_colors.dart';

class PageContainer extends StatelessWidget {
  const PageContainer({
    required this.child,
    this.borderRadius,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            AppColors.startDefaultPageBackgroundColorGradient,
            AppColors.endDefaultPageBackgroundColorGradient,
          ],
          tileMode: TileMode.clamp,
        ),
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}
