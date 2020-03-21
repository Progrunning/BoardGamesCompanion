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
      decoration: BoxDecoration(color: Colors.red),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                child: Image.network(
                  'https://s3.amazonaws.com/37assets/svn/765-default-avatar.png',
                  height: _avatarHeight,
                  width: _avatarWidth,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
