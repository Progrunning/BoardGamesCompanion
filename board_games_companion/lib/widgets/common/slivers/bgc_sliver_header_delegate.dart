import 'package:flutter/material.dart';

import '../../../common/app_theme.dart';
import '../../../common/dimensions.dart';

class BgcSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  BgcSliverHeaderDelegate({
    required this.title,
  }) : super();

  String title;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      elevation: 4,
      child: Container(
        color: AppTheme.primaryColor,
        padding: const EdgeInsets.all(Dimensions.standardSpacing),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(title, style: AppTheme.titleTextStyle, overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
