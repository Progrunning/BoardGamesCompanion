import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/models/board_game.dart';
import 'package:flutter/material.dart';

class BoardGameSearchItemWidget extends StatefulWidget {
  final BoardGame boardGame;

  BoardGameSearchItemWidget({Key key, this.boardGame}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BoardGameSearchItemWidget();
}

class _BoardGameSearchItemWidget extends State<BoardGameSearchItemWidget> {
  ImageState thumbnailState = ImageState.None;

  Image thumbnail;

  @override
  void initState() {
    super.initState();

    if (!(widget.boardGame?.thumbnailUrl?.isEmpty ?? true)) {
      thumbnail = Image.network(widget.boardGame.thumbnailUrl);
      thumbnail.image.resolve(ImageConfiguration()).addListener(
              ImageStreamListener((ImageInfo image, bool synchronousCall) {
            thumbnailState = ImageState.Loaded;
            if (mounted) {
              setState(() {});
            }
          }, onError: ((dynamic asd, StackTrace stackTrace) {
            thumbnailState = ImageState.Error;
            if (mounted) {
              setState(() {});
            }
          })));
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget searchItemWidget;
    switch (thumbnailState) {
      case ImageState.None:
      case ImageState.Loading:
        searchItemWidget = Placeholder();
        break;
      case ImageState.Loaded:
        searchItemWidget = thumbnail;
        break;
      case ImageState.Error:
        searchItemWidget = Padding(
          padding: const EdgeInsets.all(Dimensions.standardSpacing ),
          child: Center(child: Text(widget.boardGame.name, textAlign: TextAlign.center)),
        );
        break;
      default:
    }

    return Card(child: searchItemWidget);
  }
}
