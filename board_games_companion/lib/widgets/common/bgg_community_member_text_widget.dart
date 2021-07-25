import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../utilities/launcher_helper.dart';

class BggCommunityMemberText extends StatelessWidget {
  const BggCommunityMemberText({
    this.fontSize = Dimensions.mediumFontSize,
    Key key,
  }) : super(key: key);

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: "If you're a member of the ",
          ),
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
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontSize: fontSize,
      ),
    );
  }
}
