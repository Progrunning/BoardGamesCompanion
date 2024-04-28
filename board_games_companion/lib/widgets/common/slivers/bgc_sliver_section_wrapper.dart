import 'package:flutter/material.dart';

import '../../../common/dimensions.dart';

class SliverSectionWrapper extends StatelessWidget {
  const SliverSectionWrapper({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.only(
      left: Dimensions.standardSpacing,
      top: Dimensions.standardSpacing,
      right: Dimensions.standardSpacing,
      bottom: Dimensions.doubleStandardSpacing,
    ),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding,
      sliver: SliverToBoxAdapter(child: child),
    );
  }
}
