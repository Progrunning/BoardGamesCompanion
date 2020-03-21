import 'package:board_games_companion/common/dimensions.dart';
import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  const Player({
    Key key,
  }) : super(key: key);

  final double _avatarWidth = 80;
  final double _avatarHeight = 110;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        height: _avatarHeight,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Image.network(
                  'https://s3.amazonaws.com/37assets/svn/765-default-avatar.png',
                  height: _avatarHeight,
                  width: _avatarWidth,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  right: Dimensions.halfStandardSpacing,
                  bottom: Dimensions.halfStandardSpacing,
                  child: Icon(
                    Icons.star,
                    size: 28,
                    color: Colors.yellow,
                  ),
                )
              ],
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
                            fontWeight: FontWeight.bold,
                            fontSize: 56
                          ),
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
