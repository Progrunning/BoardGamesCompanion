import 'package:board_games_companion/common/animation_tags.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/widgets/common/loading_indicator_widget.dart';
import 'package:board_games_companion/widgets/common/shadow_box_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BoardGameImage extends StatelessWidget {
  final double minImageHeight;
  final String heroTag;

  const BoardGameImage(
    BoardGameDetails boardGameDetails, {
    Key key,
    this.minImageHeight = 300,
    this.heroTag = AnimationTags.boardGameDetalsImageHeroTag,
  })  : _boardGameDetails = boardGameDetails,
        super(key: key);

  final BoardGameDetails _boardGameDetails;

  @override
  Widget build(BuildContext context) {
    if (_boardGameDetails == null) {
      return Container();
    }

    return Hero(
      tag: "$heroTag${_boardGameDetails.id}",
      child: CachedNetworkImage(
        imageUrl: _boardGameDetails?.imageUrl ?? '',
        imageBuilder: (context, imageProvider) => _wrapInShadowBox(
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        fit: BoxFit.fitWidth,
        placeholder: (context, url) => LoadingIndicator(),
        errorWidget: (context, url, error) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: minImageHeight),
            child: Image.asset(
              'assets/icons/logo.png',
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  Widget _wrapInShadowBox(Widget content) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minImageHeight),
      child: ShadowBox(
        child: content,
      ),
    );
  }
}
