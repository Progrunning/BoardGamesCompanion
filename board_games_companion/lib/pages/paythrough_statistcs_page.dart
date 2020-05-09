import 'package:board_games_companion/common/animation_tags.dart';
import 'package:board_games_companion/common/constants.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/widgets/board_games/board_game_image_widget.dart';
import 'package:board_games_companion/widgets/board_games/playthrough_statistics_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaythroughStatistcsPage extends StatelessWidget {
  const PlaythroughStatistcsPage({
    @required boardGameDetails,
    Key key,
  })  : _boardGameDetails = boardGameDetails,
        super(key: key);

  final BoardGameDetails _boardGameDetails;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          automaticallyImplyLeading: false,
          floating: false,
          expandedHeight: Constants.BoardGameDetailsImageHeight,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            centerTitle: true,
            background: BoardGameImage(
              _boardGameDetails,
              minImageHeight: Constants.BoardGameDetailsImageHeight,
              heroTag: AnimationTags.boardGamePlaythroughImageHeroTag,
            ),
          ),
        ),
        SliverPadding(
          sliver: SliverToBoxAdapter(
            child: ChangeNotifierProvider.value(
              value: _boardGameDetails,
              child: PlaythroughStatisticsDetails(),
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: Dimensions.standardSpacing,
          ),
        )
      ],
    );
  }
}
