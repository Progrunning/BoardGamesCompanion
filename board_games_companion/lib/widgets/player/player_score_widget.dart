import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/widgets/player/player_avatar.dart';
import 'package:flutter/material.dart';

class PlayerScore extends StatelessWidget {
  final MedalEnum medal;

  const PlayerScore({
    Key key,
    @required this.medal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        height: Dimensions.defaultPlayerAvatarHeight,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PlayerAvatar(
              medal: medal,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.standardSpacing),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          'Name',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Divider(
                          indent: Dimensions.halfStandardSpacing,
                        ),
                        Text(
                          'Miko',
                          style: TextStyle(
                            fontSize: Dimensions.largeFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Score',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '34',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 56),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
