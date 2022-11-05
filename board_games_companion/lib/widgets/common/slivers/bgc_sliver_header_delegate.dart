import 'package:basics/basics.dart';
import 'package:flutter/material.dart';

import '../../../common/app_colors.dart';
import '../../../common/app_theme.dart';
import '../../../common/dimensions.dart';

class BgcSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  BgcSliverHeaderDelegate({
    required this.primaryTitle,
    this.secondaryTitle,
  }) : super();

  String primaryTitle;
  String? secondaryTitle;

  static const double _size = 50;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      elevation: Dimensions.defaultElevation,
      color: AppColors.primaryColor,
      child: SizedBox(
        height: _size,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.standardSpacing),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(primaryTitle, style: AppTheme.titleTextStyle, overflow: TextOverflow.ellipsis),
              if (secondaryTitle.isNotNullOrBlank) ...[
                const Expanded(child: SizedBox.shrink()),
                Text(
                  secondaryTitle!,
                  style: AppTheme.titleTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ]
            ],
          ),
        ),
      ),
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
