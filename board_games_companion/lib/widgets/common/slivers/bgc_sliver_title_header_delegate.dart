import 'package:basics/basics.dart';
import 'package:flutter/material.dart';

import '../../../common/dimensions.dart';
import '../section_header.dart';

class BgcSliverTitleHeaderDelegate extends SliverPersistentHeaderDelegate {
  BgcSliverTitleHeaderDelegate({
    required this.primaryTitle,
    this.secondaryTitle,
    this.action,
  }) : super();

  factory BgcSliverTitleHeaderDelegate.title({
    required String primaryTitle,
  }) =>
      BgcSliverTitleHeaderDelegate(primaryTitle: primaryTitle);

  factory BgcSliverTitleHeaderDelegate.titles({
    required String primaryTitle,
    required String secondaryTitle,
  }) =>
      BgcSliverTitleHeaderDelegate(primaryTitle: primaryTitle, secondaryTitle: secondaryTitle);

  factory BgcSliverTitleHeaderDelegate.action({
    required String primaryTitle,
    required Widget action,
  }) =>
      BgcSliverTitleHeaderDelegate(primaryTitle: primaryTitle, action: action);

  String primaryTitle;
  String? secondaryTitle;
  Widget? action;

  static const double _size = Dimensions.sectionHeaderHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    if (action != null) {
      return SectionHeader.titleWithAction(title: primaryTitle, action: action!);
    }

    if (secondaryTitle.isNullOrBlank) {
      return SectionHeader.title(height: _size, title: primaryTitle);
    }

    return SectionHeader.titles(
      height: _size,
      primaryTitle: primaryTitle,
      secondaryTitle: secondaryTitle!,
    );
  }

  @override
  double get maxExtent => _size;

  @override
  double get minExtent => _size;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
