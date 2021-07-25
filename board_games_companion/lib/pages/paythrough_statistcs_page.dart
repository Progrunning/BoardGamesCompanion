import 'package:board_games_companion/common/animation_tags.dart';
import 'package:board_games_companion/common/constants.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/enums/collection_flag.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/widgets/board_games/board_game_image.dart';
import 'package:board_games_companion/widgets/board_games/playthrough_statistics_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaythroughStatistcsPage extends StatefulWidget {
  const PlaythroughStatistcsPage({
    @required this.boardGameDetails,
    @required this.collectionFlag,
    Key key,
  }) : super(key: key);

  final BoardGameDetails boardGameDetails;
  final CollectionFlag collectionFlag;

  @override
  _PlaythroughStatistcsPageState createState() => _PlaythroughStatistcsPageState();
}

class _PlaythroughStatistcsPageState extends State<PlaythroughStatistcsPage> {
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
              widget.boardGameDetails,
              minImageHeight: Constants.BoardGameDetailsImageHeight,
              heroTag: '${AnimationTags.boardGamePlaythroughImageHeroTag}_${widget.collectionFlag}',
            ),
          ),
        ),
        SliverPadding(
          sliver: SliverToBoxAdapter(
            child: ChangeNotifierProvider.value(
              value: widget.boardGameDetails,
              child: const PlaythroughStatisticsDetails(),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.standardSpacing,
          ),
        )
      ],
    );
  }
}
