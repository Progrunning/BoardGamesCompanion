import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:flutter/cupertino.dart';

class HotBoardGamesHeader extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppTheme.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(
          Dimensions.standardSpacing,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Hot Board Games'),
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
