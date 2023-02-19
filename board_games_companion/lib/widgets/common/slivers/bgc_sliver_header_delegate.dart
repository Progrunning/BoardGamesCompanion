import 'package:board_games_companion/common/dimensions.dart';
import 'package:flutter/material.dart';

import '../section_header.dart';

class BgcSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  BgcSliverHeaderDelegate({
    required this.primaryTitle,
    this.secondaryTitle,
  }) : super();

  String primaryTitle;
  String? secondaryTitle;

  static const double _size = Dimensions.sectionHeaderHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) =>
      SectionHeader(height: _size, primaryTitle: primaryTitle, secondaryTitle: secondaryTitle);

  @override
  double get maxExtent => _size;

  @override
  double get minExtent => _size;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
