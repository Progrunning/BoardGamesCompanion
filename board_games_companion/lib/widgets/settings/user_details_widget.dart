import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/constants.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/mixins/sync_collection.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/stores/user_store.dart';

import 'package:board_games_companion/widgets/about/detail_item_widget.dart';
import 'package:board_games_companion/widgets/about/section_title_widget.dart';
import 'package:board_games_companion/widgets/common/bgg_community_member_text_widget.dart';
import 'package:board_games_companion/widgets/common/bgg_community_member_user_name_text_field_widget.dart';
import 'package:board_games_companion/widgets/common/icon_and_text_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetails extends StatelessWidget with SyncCollection {
  const UserDetails({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final syncController = TextEditingController();

    return Consumer<UserStore>(
      builder: (_, userStore, __) {
        if (userStore.user?.name?.isEmpty ?? true) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.standardSpacing,
            ),
            child: Column(
              children: <Widget>[
                BggCommunityMemberText(),
                BggCommunityMemberUserNameTextField(
                  controller: syncController,
                  onSubmit: () async {},
                ),
                SizedBox(
                  height: Dimensions.standardSpacing,
                ),
                Container(
                  height: 40,
                  child: userStore?.isSyncing ?? false
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: CircularProgressIndicator(),
                        )
                      : Align(
                          alignment: Alignment.centerRight,
                          child: IconAndTextButton(
                            title: 'Sync',
                            icon: Icons.sync,
                            onPressed: () async {
                              await syncCollection(
                                context,
                                syncController.text,
                              );
                            },
                          ),
                        ),
                ),
                Divider(
                  color: AppTheme.accentColor,
                ),
              ],
            ),
          );
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconAndTextButton(
                    title: 'Remove',
                    icon: Icons.remove_circle_outline,
                    backgroundColor: Colors.red,
                    onPressed: () async {
                      await _handleBggUserRemoval(
                        context,
                        userStore,
                      );
                    },
                  ),
                  SizedBox(
                    width: Dimensions.standardSpacing,
                  ),
                  IconAndTextButton(
                    title: 'Sync',
                    icon: Icons.sync,
                    onPressed: () async {
                      await syncCollection(
                        context,
                        userStore.user.name,
                      );
                    },
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

  Future<void> _handleBggUserRemoval(
    BuildContext context,
    UserStore userStore,
  ) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: <Widget>[
              Text('Are you sure you want to remove your BGG user connection?'),
              SizedBox(
                height: Dimensions.standardSpacing,
              ),
              Text(
                'This will delete your entire board games collection, including the history of gameplays',
                style: AppTheme.subTitleTextStyle,
              ),
            ],
          ),
          elevation: Dimensions.defaultElevation,
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

                await userStore.removeUser(userStore.user);
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
