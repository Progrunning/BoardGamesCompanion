import 'package:board_games_companion/common/animation_tags.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/widgets/common/loading_indicator_widget.dart';
import 'package:board_games_companion/widgets/common/shadow_box_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BoardGameCollectionItemImage extends StatelessWidget {
  const BoardGameCollectionItemImage({
    Key key,
    @required this.boardGameDetails,
  }) : super(key: key);

  final BoardGameDetails boardGameDetails;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "${AnimationTags.boardGameImageHeroTag}${boardGameDetails.id}",
      child: ShadowBox(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Styles.defaultCornerRadius),
          child: CachedNetworkImage(
            imageUrl: boardGameDetails.imageUrl,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => LoadingIndicator(),
            errorWidget: (context, url, error) => Container(
              child: Center(
                child: Text(
                  boardGameDetails.name ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: Dimensions.extraLargeFontSize),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
