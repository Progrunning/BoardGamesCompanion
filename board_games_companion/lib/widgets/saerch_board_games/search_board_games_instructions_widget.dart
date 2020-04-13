import 'package:board_games_companion/common/dimensions.dart';
import 'package:flutter/cupertino.dart';

class SearchBoardGamesState extends SliverPersistentHeaderDelegate {
  Widget child;

  SearchBoardGamesState({
    @required this.child,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(
          Dimensions.doubleStandardSpacing,
        ),
        child: Center(
          child: child,
        ),
      ),
    );
  }

  @override
  double get maxExtent => 100;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
