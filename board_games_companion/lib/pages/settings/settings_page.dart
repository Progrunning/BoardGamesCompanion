import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../stores/board_games_store.dart';
import '../../stores/user_store.dart';
import '../../widgets/about/detail_item.dart';
import '../../widgets/about/section_title.dart';
import '../../widgets/common/bgg_community_member_text_widget.dart';
import '../../widgets/common/bgg_community_member_user_name_text_field_widget.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/import_collections_button.dart';
import '../about_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

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
                  _AboutPageTile(),
                ],
              ),
            ),
          ),
          const _VersionNumber(),
          const SizedBox(height: Dimensions.bottomTabTopHeight),
        ],
      ),
    );
  }
}

class _UserDetailsPanel extends StatefulWidget {
  const _UserDetailsPanel({
    Key? key,
  }) : super(key: key);

  @override
  State<_UserDetailsPanel> createState() => _UserDetailsPanelState();
}

class _UserDetailsPanelState extends State<_UserDetailsPanel> {
  late TextEditingController _bggUserNameController;

  bool? _triggerImport;

  @override
  void initState() {
    super.initState();
    _bggUserNameController = TextEditingController();
  }

  @override
  void dispose() {
    _bggUserNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Consumer<UserStore>(
        builder: (_, userStore, __) {
          if (userStore.user?.name.isEmpty ?? true) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const BggCommunityMemberText(),
                  BggCommunityMemberUserNameTextField(
                    controller: _bggUserNameController,
                    onSubmit: () => setState(() {
                      _triggerImport = true;
                    }),
                  ),
                  const SizedBox(height: Dimensions.standardSpacing),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ImportCollectionsButton(
                      bggUserName: _bggUserNameController.text,
                      triggerImport: _triggerImport ?? false,
                    ),
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
                title: 'User',
              ),
              DetailsItem(
                title: userStore.user?.name ?? '',
                subtitle: 'BGG profile page',
                uri: '${Constants.BoardGameGeekBaseApiUrl}user/${userStore.user?.name}',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ElevatedIconButton(
                      title: 'Remove',
                      icon: const DefaultIcon(
                        Icons.remove_circle_outline,
                      ),
                      color: AppTheme.redColor,
                      onPressed: () async => _showRemoveBggUserDialog(context, userStore),
                    ),
                    const SizedBox(width: Dimensions.standardSpacing),
                    ImportCollectionsButton(bggUserName: userStore.user!.name),
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

  Future<void> _showRemoveBggUserDialog(BuildContext context, UserStore userStore) async {
    await showDialog<AlertDialog>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: const <Widget>[
              Text('Are you sure you want to remove your BGG user connection?'),
            ],
          ),
          content: const Text(
            'This will delete your synchronized board games collection, including the history of gameplays',
          ),
          elevation: Dimensions.defaultElevation,
          actions: <Widget>[
            TextButton(
              child: const Text(
                AppText.Cancel,
                style: TextStyle(color: AppTheme.accentColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Remove',
                style: TextStyle(color: AppTheme.defaultTextColor),
              ),
              style: TextButton.styleFrom(backgroundColor: AppTheme.redColor),
              onPressed: () async {
                final boardGameStore = Provider.of<BoardGamesStore>(
                  context,
                  listen: false,
                );

                await userStore.removeUser(userStore.user!);
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
  const _RateAndReviewTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
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
    );
  }
}

class _AboutPageTile extends StatelessWidget {
  const _AboutPageTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        DetailsItem(
          title: 'About',
          subtitle: 'App information',
          onTap: () async => _navigateToAboutPage(context),
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
    );
  }

  Future<void> _navigateToAboutPage(BuildContext context) async {
    await Navigator.pushNamed(context, AboutPage.pageRoute);
  }
}

class _VersionNumber extends StatelessWidget {
  const _VersionNumber({
    Key? key,
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
