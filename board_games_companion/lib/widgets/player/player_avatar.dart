import 'dart:io';

import 'package:flutter/material.dart';

import '../../common/constants.dart';
import '../../common/enums/enums.dart';
import '../../common/styles.dart';

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
    if ((imageUri?.isEmpty ?? true) ||
        imageUri == Constants.DefaultAvatartAssetsPath) {
      avatarImage = Positioned.fill(
        child: Image.asset(
          Constants.DefaultAvatartAssetsPath,
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

    final List<Widget> stackChildren = [
      avatarImage,
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(Styles.defaultCornerRadius),
      child: Stack(children: stackChildren),
    );
  }
}
