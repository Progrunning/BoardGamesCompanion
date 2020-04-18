import 'package:board_games_companion/common/dimensions.dart';
import 'package:flutter/cupertino.dart';

class SearchBoardGamesState extends SliverPersistentHeaderDelegate {
  static const double defaultHeight = 100;

  const SearchBoardGamesState({
    @required this.child,
    this.height = defaultHeight,
  });

  final Widget child;
  final double height;

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
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
