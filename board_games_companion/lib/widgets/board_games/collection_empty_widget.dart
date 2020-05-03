import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/mixins/sync_collection.dart';
import 'package:board_games_companion/widgets/common/bgg_community_member_text_widget.dart';
import 'package:board_games_companion/widgets/common/bgg_community_member_user_name_text_field_widget.dart';
import 'package:board_games_companion/widgets/common/icon_and_text_button.dart';
import 'package:flutter/material.dart';

class CollectionEmpty extends StatelessWidget with SyncCollection {
  CollectionEmpty({
    Key key,
  }) : super(key: key);

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
            BggCommunityMemberText(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.doubleStandardSpacing * 2,
              ),
              child: BggCommunityMemberUserNameTextField(
                controller: _syncController,
                onSubmit: () async {
                  await syncCollection(
                    context,
                    _syncController.text,
                  );
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
                  await syncCollection(
                    context,
                    _syncController.text,
                  );
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
}
