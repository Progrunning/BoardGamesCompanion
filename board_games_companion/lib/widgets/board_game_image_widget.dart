import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/board_game_details.dart';
import 'package:board_games_companion/widgets/shadow_box_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BoardGameImage extends StatelessWidget {
  const BoardGameImage({
    Key key,
    @required BoardGameDetails boardGameDetails,
  })  : _boardGameDetails = boardGameDetails,
        super(key: key);

  final BoardGameDetails _boardGameDetails;
  final double _minImageHeight = 300;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: _boardGameDetails.imageUrl,
      imageBuilder: (context, imageProvider) => _wrapInShadowBox(
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
      ),
      fit: BoxFit.fitWidth,
      placeholder: (context, url) =>
          _wrapInShadowBox(Center(child: CircularProgressIndicator())),
      errorWidget: (context, url, error) => _wrapInShadowBox(
        Padding(
          padding: const EdgeInsets.all(Dimensions.standardSpacing),
          child: Container(
            child: Center(
                child: Text(
              _boardGameDetails?.name ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: Dimensions.extraLargeFontSize),
            )),
          ),
        ),
      ),
    );
  }

  Widget _wrapInShadowBox(Widget content) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: _minImageHeight),
      child: ShadowBox(content),
    );
  }
}
