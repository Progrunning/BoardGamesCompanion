import 'package:board_games_companion/common/animation_tags.dart';
import 'package:board_games_companion/common/constants.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/services/auth_service.dart';
import 'package:board_games_companion/widgets/common/icon_and_text_button.dart';
import 'package:board_games_companion/widgets/player/player_avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
// TODO MK Make it nicer and update the button UI
    final AuthService authService = Provider.of<AuthService>(
      context,
      listen: false,
    );

    return Column(
      children: <Widget>[
        SizedBox(
          height: Constants.PlayersAvatarHeight * 0.8,
          width: Constants.PlayersAvatarWidth * 0.8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Styles.defaultCornerRadius),
            child: Stack(
              children: <Widget>[
                Hero(
                  tag: '${AnimationTags.playerImageHeroTag}',
                  child: PlayerAvatar(
                    imageUri: null,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: Dimensions.standardSpacing,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconAndTextButton(
              title: 'Sign In',
              icon: Icons.person,
              onPressed: () async {
                await authService.signIn();
              },
            ),
            SizedBox(
              width: Dimensions.standardSpacing,
            ),
            // TODO MK Combine Sign In with Sign out (control with state)
            IconAndTextButton(
              title: 'Sign Out',
              icon: Icons.person,
              onPressed: () async {
                await authService.signOut();
              },
            ),
          ],
        ),
      ],
    );
  }
}
