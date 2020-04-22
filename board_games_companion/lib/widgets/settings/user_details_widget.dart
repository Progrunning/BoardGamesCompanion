import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/constants.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/stores/user_store.dart';

import 'package:board_games_companion/widgets/about/detail_item_widget.dart';
import 'package:board_games_companion/widgets/about/section_title_widget.dart';
import 'package:board_games_companion/widgets/common/icon_and_text_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetails extends StatelessWidget {
  const UserDetails({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserStore>(
      builder: (_, userStore, __) {
        if (userStore.user?.name?.isEmpty ?? true) {
          return Container();
        }
        return Column(
          children: <Widget>[
            SectionTitle(
              title: 'USER',
            ),
            DetailsItem(
              title: '${userStore?.user?.name}',
              subtitle: 'BGG profile page',
              uri:
                  '${Constants.BoardGameGeekBaseApiUrl}user/${userStore?.user?.name}',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.standardSpacing,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconAndTextButton(
                    title: 'Remove',
                    icon: Icons.remove_circle_outline,
                    backgroundColor: Colors.red,
                    onPressed: () async {
                      await _handleBggUserRemoval(context);
                    },
                  ),
                  Spacer(),
                  IconAndTextButton(
                    title: 'Change',
                    icon: Icons.edit,
                    backgroundColor: Colors.blue,
                  ),
                  SizedBox(
                    width: Dimensions.standardSpacing,
                  ),
                  IconAndTextButton(
                    title: 'Sync',
                    icon: Icons.sync,
                  ),
                ],
              ),
            ),
            Divider(
              color: AppTheme.accentColor,
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleBggUserRemoval(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              'Are you sure you want to remove your BGG user connection? This will delete your entire board games collection, including the history of gameplays'),
          elevation: 2,
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Remove'),
              color: Colors.red,
              onPressed: () async {
                final boardGameStore = Provider.of<BoardGamesStore>(
                  context,
                  listen: false,
                );

                await boardGameStore.removeAllBoardGames();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
