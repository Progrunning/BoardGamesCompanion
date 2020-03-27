import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/utilities/navigator_helper.dart';
import 'package:board_games_companion/widgets/common/icon_and_text_button.dart';
import 'package:flutter/material.dart';

class PlaythroughNoPlayers extends StatelessWidget {
  const PlaythroughNoPlayers({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(Dimensions.standardSpacing),
            child: Center(
              child: Column(
                children: <Widget>[
                  Text('It looks empty here, try adding a new player'),
                  Divider(
                    height: Dimensions.halfStandardSpacing,
                  ),
                  IconAndTextButton(
                    title: 'Add Player',
                    icon: Icons.add,
                    onPressed: () async {
                      await NavigatorHelper.navigateToCreatePlayerPage(
                        context,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
