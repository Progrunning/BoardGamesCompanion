import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../common/animation_tags.dart';
import '../../models/hive/board_game_details.dart';
import '../common/loading_indicator_widget.dart';

class BoardGameImage extends StatelessWidget {
  const BoardGameImage(
    BoardGameDetails? boardGameDetails, {
    Key? key,
    this.minImageHeight = 300,
    this.heroTag = AnimationTags.boardGameHeroTag,
  })  : _boardGameDetails = boardGameDetails,
        super(key: key);

  final double minImageHeight;
  final String heroTag;

  final BoardGameDetails? _boardGameDetails;

  @override
  Widget build(BuildContext context) {
    if (_boardGameDetails == null) {
      return Container();
    }

    return Hero(
      tag: '$heroTag${_boardGameDetails!.id}',
      child: CachedNetworkImage(
        imageUrl: _boardGameDetails!.imageUrl ?? '',
        imageBuilder: (context, imageProvider) => ConstrainedBox(
          constraints: BoxConstraints(minHeight: minImageHeight),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
        ),
        fit: BoxFit.fitWidth,
        placeholder: (context, url) => const LoadingIndicator(),
        errorWidget: (context, url, dynamic error) {
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
}
