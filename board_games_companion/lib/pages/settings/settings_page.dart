import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../mixins/sync_collection.dart';
import '../../stores/board_games_store.dart';
import '../../stores/user_store.dart';
import '../../utilities/navigator_transitions.dart';
import '../../widgets/about/detail_item_widget.dart';
import '../../widgets/about/section_title_widget.dart';
import '../../widgets/common/bgg_community_member_text_widget.dart';
import '../../widgets/common/bgg_community_member_user_name_text_field_widget.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/icon_and_text_button.dart';
import '../../widgets/common/rippler_effect.dart';
import '../../widgets/common/sync_collection_button.dart';
import '../about_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const <Widget>[
                  SizedBox(
                    height: Dimensions.standardFontSize,
                  ),
                  _UserDetailsPanel(),
                  _RateAndReviewTile(),
                  _AboutPageTile()
                ],
              ),
            ),
          ),
          const _VersionNumber(),
        ],
      ),
    );
  }
}

class _UserDetailsPanel extends StatelessWidget with SyncCollection {
  const _UserDetailsPanel({
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const BggCommunityMemberText(),
                BggCommunityMemberUserNameTextField(
                  controller: syncController,
                  onSubmit: () async {},
                ),
                const SizedBox(
                  height: Dimensions.standardSpacing,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: SyncButton(usernameCallback: () => syncController.text),
                ),
                const Divider(
                  color: AppTheme.accentColor,
                ),
              ],
            ),
          );
        }

        return Column(
          children: <Widget>[
            const SectionTitle(
              title: 'USER',
            ),
            DetailsItem(
              title: userStore?.user?.name ?? '',
              subtitle: 'BGG profile page',
              uri: '${Constants.BoardGameGeekBaseApiUrl}user/${userStore?.user?.name}',
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
                    icon: const DefaultIcon(
                      Icons.remove_circle_outline,
                    ),
                    backgroundColor: Colors.red,
                    onPressed: () async {
                      await _handleBggUserRemoval(
                        context,
                        userStore,
                      );
                    },
                  ),
                  const SizedBox(
                    width: Dimensions.standardSpacing,
                  ),
                  SyncButton(usernameCallback: () => userStore.user.name),
                ],
              ),
            ),
            const Divider(
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
    await showDialog<AlertDialog>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: const <Widget>[
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
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('Remove'),
              color: Colors.red,
              onPressed: () async {
                final boardGameStore = Provider.of<BoardGamesStore>(
                  context,
                  listen: false,
                );

                await userStore.removeUser(userStore.user);
                await boardGameStore.removeAllBggBoardGames();

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class _RateAndReviewTile extends StatelessWidget {
  const _RateAndReviewTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RippleEffect(
      child: Stack(
        children: <Widget>[
          DetailsItem(
            title: 'Rate & Review',
            subtitle: 'Store listing',
            onTap: () async {
              await InAppReview.instance.openStoreListing(
                appStoreId: Constants.AppleAppId,
              );
            },
          ),
          const Positioned.fill(
            right: Dimensions.standardSpacing,
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.star,
                color: AppTheme.accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutPageTile extends StatelessWidget {
  const _AboutPageTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RippleEffect(
      child: Stack(
        children: <Widget>[
          DetailsItem(
            title: 'About',
            subtitle: 'App information',
            onTap: () async {
              await Navigator.push<AboutPage>(
                context,
                NavigatorTransitions.fadeThrough(
                  (_, __, ___) {
                    return const AboutPage();
                  },
                ),
              );
            },
          ),
          const Positioned.fill(
            right: Dimensions.standardSpacing,
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.navigate_next,
                color: AppTheme.accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VersionNumber extends StatelessWidget {
  const _VersionNumber({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data is PackageInfo) {
          return Padding(
            padding: const EdgeInsets.all(
              Dimensions.halfStandardSpacing,
            ),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'v${(snapshot.data as PackageInfo).version}',
                style: AppTheme.subTitleTextStyle,
              ),
            ),
          );
        }

        return Container();
      },
    );
  }
}
