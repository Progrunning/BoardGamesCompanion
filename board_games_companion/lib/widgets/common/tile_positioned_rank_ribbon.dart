import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/dimensions.dart';
import 'rank_ribbon.dart';

class PositionedTileRankRibbon extends StatelessWidget {
  const PositionedTileRankRibbon({
    required this.rank,
    Key? key,
  }) : super(key: key);

  final num rank;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.only(
          right: Dimensions.halfStandardSpacing,
        ),
        child: RankRibbon(rank),
      ),
    );
  }
}
