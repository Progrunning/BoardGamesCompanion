import 'package:board_games_companion/common/dimensions.dart';
import 'package:flutter/cupertino.dart';

class SearchBoardGamesInstructions extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(
          Dimensions.doubleStandardSpacing,
        ),
        child: Center(
          child: Text(
              'To search for board games, please type a board game title in the above field.'),
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
