import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../common/app_colors.dart';

class BgcShimmer extends StatelessWidget {
  const BgcShimmer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.primaryColor,
      highlightColor: AppColors.accentColor,
      enabled: true,
      child: child,
    );
  }
}
