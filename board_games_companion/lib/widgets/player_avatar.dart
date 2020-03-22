import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/widgets/medal_widget.dart';
import 'package:flutter/material.dart';

class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar({
    Key key,
    this.medal,
    this.place,
    // this.avatarHeight = Dimensions.defaultPlayerAvatarHeight,
    // this.avatarWidth = Dimensions.defaultPlayerAvatarWidth,
  }) : super(key: key);

  final MedalEnum medal;
  final int place;
  // final double avatarWidth;
  // final double avatarHeight;

  @override
  Widget build(BuildContext context) {
    final _hasMedal = medal != null;
    List<Widget> stackChildren = [
      Image.network(
        'https://s3.amazonaws.com/37assets/svn/765-default-avatar.png',
        fit: BoxFit.cover,
      ),
    ];

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
