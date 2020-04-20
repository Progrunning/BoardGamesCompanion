import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/constants.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/models/hive/user.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/stores/user_store.dart';
import 'package:board_games_companion/utilities/launcher_helper.dart';
import 'package:board_games_companion/widgets/common/icon_and_text_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CollectionEmpty extends StatelessWidget {
  CollectionEmpty({
    @required boardGamesStore,
    @required userStore,
    Key key,
  })  : _boardGamesStore = boardGamesStore,
        _userStore = userStore,
        super(key: key);

  final BoardGamesStore _boardGamesStore;
  final UserStore _userStore;
  final _syncController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(
          Dimensions.doubleStandardSpacing,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'It looks like you don\'t have any games in your collection yet.',
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.standardSpacing,
            ),
            Text.rich(
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.doubleStandardSpacing * 2,
              ),
              child: TextField(
                controller: _syncController,
                decoration: AppTheme.defaultTextFieldInputDecoration.copyWith(
                  hintText: 'Enter your BGG user\'s name',
                ),
                onSubmitted: (username) async {
                  await _syncCollection(context);
                },
              ),
            ),
            SizedBox(
              height: Dimensions.standardSpacing,
            ),
            Center(
              child: IconAndTextButton(
                title: 'Sync',
                icon: Icons.sync,
                onPressed: () async {
                  await _syncCollection(context);
                },
              ),
            ),
            SizedBox(
              height: Dimensions.standardSpacing,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                    'Otherwise, just use the button on the bottom to search for games and then add them to your collection.'),
              ),
            ),
            SizedBox(
              height: Dimensions.floatingActionButtonBottomSpacing,
            ),
          ],
        ),
      ),
    );
  }

  Future _syncCollection(BuildContext context) async {
    final username = _syncController.text;
    final syncResult = await _boardGamesStore.syncCollection(username);
    if (syncResult?.isSuccess ?? false) {
      final user = User();
      user.name = username;
      await _userStore?.addOrUpdateUser(user);
    }
  }
}
