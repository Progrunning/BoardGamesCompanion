import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../common/app_colors.dart';

class BgcShimmer extends StatelessWidget {
  factory BgcShimmer.fill({
    Color baseColor = AppColors.primaryColor,
    Color highlightColor = AppColors.primaryColorLight,
    BorderRadiusGeometry? borderRadius,
    double? elevation,
  }) =>
      BgcShimmer._(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Material(
          borderRadius: borderRadius,
          elevation: elevation ?? 0,
          child: Container(),
        ),
      );

  factory BgcShimmer.box({
    required double height,
    required double width,
    Color baseColor = AppColors.primaryColor,
    Color highlightColor = AppColors.primaryColorLight,
  }) =>
      BgcShimmer._(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: SizedBox(
          height: height,
          width: width,
          child: const Material(),
        ),
      );

  factory BgcShimmer.invertedColorsBox({
    required double height,
    required double width,
  }) =>
      BgcShimmer.box(
        height: height,
        width: width,
        baseColor: AppColors.primaryColorLight,
        highlightColor: AppColors.primaryColor,
      );

  factory BgcShimmer.custom({
    required Widget child,
    Color baseColor = AppColors.primaryColor,
    Color highlightColor = AppColors.primaryColorLight,
  }) =>
      BgcShimmer._(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: child,
      );

  const BgcShimmer._({
    required this.child,
    required this.baseColor,
    required this.highlightColor,
  });

  final Widget child;
  final Color baseColor;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      enabled: true,
      child: child,
    );
  }
}
