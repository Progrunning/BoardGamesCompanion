import 'dart:io';

import 'package:flutter/material.dart';

import '../../common/constants.dart';
import '../../common/enums/enums.dart';
import '../../common/styles.dart';

class PlayerImage extends StatelessWidget {
  const PlayerImage({
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(Styles.defaultCornerRadius),
      child: Stack(
        children: [
          Builder(
            builder: (_) {
              if ((imageUri?.isEmpty ?? true) || imageUri == Constants.DefaultAvatartAssetsPath) {
                return Positioned.fill(
                  child: Image.asset(
                    Constants.DefaultAvatartAssetsPath,
                    fit: BoxFit.cover,
                  ),
                );
              }
              return Positioned.fill(
                child: Image.file(
                  File(imageUri),
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
