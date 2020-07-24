import 'package:board_games_companion/common/constants.dart';
import 'package:board_games_companion/utilities/launcher_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BggCommunityMemberText extends StatelessWidget {
  const BggCommunityMemberText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'If you\'re a member of the ',
          ),
          TextSpan(
            text: 'BoardGameGeek',
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                await LauncherHelper.launchUri(
                  context,
                  '${Constants.BoardGameGeekBaseApiUrl}',
                );
              },
          ),
          TextSpan(
            text: ' community, then please enter your ',
          ),
          TextSpan(
            text: 'user\'s name',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text:
                ' in the below box and hit the sync button to retrieve your collection.',
          ),
        ],
      ),
    );
  }
}
