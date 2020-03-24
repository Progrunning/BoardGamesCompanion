import 'dart:io';

import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/widgets/medal_widget.dart';
import 'package:flutter/material.dart';

class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar({
    Key key,
    this.medal,
    this.place,
    this.imageUri,
  }) : super(key: key);

  final String imageUri;
  final MedalEnum medal;
  final int place;

  @override
  Widget build(BuildContext context) {
    final _hasMedal = medal != null;
    Widget avatarImage;
    if (imageUri?.isEmpty ?? true) {
      avatarImage = Positioned.fill(
        child: Image(
          image: AssetImage('assets/default_avatar.png'),
          fit: BoxFit.cover,
        ),
      );
    } else {
      avatarImage = Positioned.fill(
        child: Image.file(
          File(imageUri),
          fit: BoxFit.cover,
        ),
      );
    }

    List<Widget> stackChildren = [avatarImage, Container(decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),)];

    if (_hasMedal) {
      stackChildren.add(
        Positioned(
          right: Dimensions.halfStandardSpacing,
          bottom: Dimensions.halfStandardSpacing,
          child: Medal(medal),
        ),
      );
    }

    return Stack(children: stackChildren);
  }
}
