import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/board_game_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BoardGameWidget extends StatelessWidget {
  final BoardGameDetails boardGameDetails;

  BoardGameWidget({Key key, this.boardGameDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.standardSpacing),
      child: Card(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: 150,
              width: 150,
              child: CachedNetworkImage(
                imageUrl: boardGameDetails.imageUrl,
                imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.fill))),
                fit: BoxFit.fitWidth,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Padding(
                    padding: const EdgeInsets.all(Dimensions.standardSpacing),
                    child: Container(
                      child: Center(
                          child: Text(
                        boardGameDetails?.name ?? '',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: Dimensions.extraLargeFontSize),
                      )),
                    )),
              ),
            ),
            Expanded(
                child: Stack(
              children: <Widget>[Text(boardGameDetails?.name ?? '')],
            )),
          ],
        ),
      ),
    );
  }
}
