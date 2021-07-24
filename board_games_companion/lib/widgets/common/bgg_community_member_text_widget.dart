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
          const TextSpan(
            text: "If you're a member of the ",
          ),
          TextSpan(
            text: 'BoardGameGeek',
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                await LauncherHelper.launchUri(
                  context,
                  Constants.BoardGameGeekBaseApiUrl,
                );
              },
          ),
          const TextSpan(
            text: ' community, then please enter your ',
          ),
          const TextSpan(
            text: "user's name",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const TextSpan(
            text: ' in the below box and hit the sync button to retrieve your collection.',
          ),
        ],
      ),
    );
  }
}
