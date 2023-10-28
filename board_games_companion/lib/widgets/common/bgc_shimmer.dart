import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../common/app_colors.dart';

class BgcShimmer extends StatelessWidget {
  factory BgcShimmer.box({
    BorderRadiusGeometry? borderRadius,
    double? elevation,
    Color? color = AppColors.primaryColor,
  }) =>
      BgcShimmer._(
        child: Material(
          borderRadius: borderRadius,
          color: color,
          elevation: elevation ?? 0,
          child: Container(),
        ),
      );

  factory BgcShimmer.custom({
    required Widget child,
  }) =>
      BgcShimmer._(child: child);

  const BgcShimmer._({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.primaryColor,
      highlightColor: AppColors.primaryColorLight,
      enabled: true,
      child: child,
    );
  }
}
