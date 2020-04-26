import 'dart:io';

import 'package:board_games_companion/common/enums/enums.dart';
import 'package:board_games_companion/common/styles.dart';
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

    List<Widget> stackChildren = [
      avatarImage,
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(Styles.defaultCornerRadius),
      child: Stack(children: stackChildren),
    );
  }
}
