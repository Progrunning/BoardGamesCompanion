import 'package:flutter/material.dart';

import '../../common/app_colors.dart';

class PageContainer extends StatelessWidget {
  const PageContainer({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            AppColors.startDefaultPageBackgroundColorGradient,
            AppColors.endDefaultPageBackgroundColorGradient,
          ],
          tileMode: TileMode.clamp,
        ),
      ),
      child: child,
    );
  }
}
