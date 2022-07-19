import 'package:board_games_companion/widgets/common/page_container_widget.dart';
import 'package:flutter/material.dart';
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

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();

  static const String pageRoute = '/settings';
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppText.settingsPageTitle, style: AppTheme.titleTextStyle)),
      body: SafeArea(
        child: PageContainer(
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const <Widget>[
                      SizedBox(height: Dimensions.standardFontSize),
                      _UserDetailsPanel(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
                  const SectionTitle(title: 'BGG Username', padding: EdgeInsets.zero),
                  const SizedBox(height: Dimensions.standardSpacing),
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
                      usernameCallback: () => _bggUserNameController.text,
                      triggerImport: _triggerImport ?? false,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SectionTitle(title: 'User'),
              DetailsItem(
                title: userStore.user?.name ?? '',
                subtitle: 'BGG profile page',
                uri: '${Constants.boardGameGeekBaseApiUrl}user/${userStore.user?.name}',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ElevatedIconButton(
                      title: 'Remove',
                      icon: const DefaultIcon(Icons.remove_circle_outline),
                      color: AppTheme.redColor,
                      onPressed: () async => _showRemoveBggUserDialog(context, userStore),
                    ),
                    const SizedBox(width: Dimensions.standardSpacing),
                    ImportCollectionsButton(usernameCallback: () => userStore.user!.name),
                  ],
                ),
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
                AppText.cancel,
                style: TextStyle(color: AppTheme.accentColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: AppTheme.redColor),
              onPressed: () async {
                final boardGameStore = Provider.of<BoardGamesStore>(
                  context,
                  listen: false,
                );

                await userStore.removeUser(userStore.user!);
                await boardGameStore.removeAllBggBoardGames();

                if (!mounted) {
                  return;
                }

                Navigator.of(context).pop();
              },
              child: const Text(
                'Remove',
                style: TextStyle(color: AppTheme.defaultTextColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
