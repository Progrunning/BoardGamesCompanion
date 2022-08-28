import 'package:board_games_companion/pages/settings/settings_view_model.dart';
import 'package:board_games_companion/widgets/common/page_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../common/app_colors.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../injectable.dart';
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
  const SettingsPage({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final SettingsViewModel viewModel;

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
                  child: Theme(
                    data: AppTheme.theme.copyWith(
                      dividerTheme: AppTheme.theme.dividerTheme.copyWith(
                        space: Dimensions.doubleStandardSpacing,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(height: Dimensions.standardFontSize),
                        const _UserDetailsPanel(),
                        const Divider(color: AppColors.accentColor),
                        _BackupSection(viewModel: widget.viewModel),
                      ],
                    ),
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
                      color: AppColors.redColor,
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
                style: TextStyle(color: AppColors.accentColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: AppColors.redColor),
              onPressed: () async {
                final boardGameStore = getIt<BoardGamesStore>();

                await userStore.removeUser(userStore.user!);
                await boardGameStore.removeAllBggBoardGames();

                if (!mounted) {
                  return;
                }

                Navigator.of(context).pop();
              },
              child: const Text(
                'Remove',
                style: TextStyle(color: AppColors.defaultTextColor),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BackupSection extends StatefulWidget {
  const _BackupSection({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final SettingsViewModel viewModel;

  @override
  State<_BackupSection> createState() => _BackupSectionState();
}

class _BackupSectionState extends State<_BackupSection> with TickerProviderStateMixin {
  late AnimationController _fadeInAnimationController;
  late AnimationController _sizeAnimationController;

  @override
  void initState() {
    super.initState();

    widget.viewModel.loadBackups();

    _fadeInAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 500),
    );
    _sizeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      value: 1,
    );
  }

  @override
  void dispose() {
    _fadeInAnimationController.dispose();
    _sizeAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                title: AppText.settingsPageBackupAndRestoreSectionTitle,
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: Dimensions.standardSpacing),
              const Text(
                AppText.settingsPageBackupAndRestoreSectionBody,
                style: TextStyle(fontSize: Dimensions.mediumFontSize),
              ),
              const SizedBox(height: Dimensions.standardSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedIconButton(
                    icon: const Icon(Icons.settings_backup_restore),
                    title: AppText.settingsPageRestireButtonText,
                    onPressed: () async => widget.viewModel.restoreAppData(),
                  ),
                  const SizedBox(width: Dimensions.standardSpacing),
                  AnimatedButton(
                    text: AppText.settingsPageBackupButtonText,
                    icon: const DefaultIcon(Icons.archive),
                    sizeAnimationController: _sizeAnimationController,
                    fadeInAnimationController: _fadeInAnimationController,
                    onPressed: () async {
                      await widget.viewModel.backupAppsData();
                      if (mounted) {
                        _sizeAnimationController.forward();
                        _fadeInAnimationController.reverse();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Observer(
          builder: (_) {
            switch (widget.viewModel.futureLoadBackups?.status ?? FutureStatus.pending) {
              case FutureStatus.fulfilled:
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.viewModel.hasAnyBackupFiles) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
                        child: Text(
                          AppText.settingsPageBackupsListTitle,
                          style: AppTheme.sectionHeaderTextStyle,
                        ),
                      ),
                      const SizedBox(height: Dimensions.halfStandardSpacing),
                    ],
                    for (final backupFile in widget.viewModel.backupFiles)
                      Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              icon: Icons.delete,
                              onPressed: (_) => widget.viewModel.deleteBackup(backupFile),
                              backgroundColor: AppColors.redColor,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
                          child: Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.boxArchive,
                                color: AppColors.whiteColor,
                              ),
                              const SizedBox(width: Dimensions.standardSpacing),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    backupFile.name,
                                    style: const TextStyle(color: AppColors.whiteColor),
                                  ),
                                  const SizedBox(height: Dimensions.halfStandardSpacing),
                                  Text(
                                    backupFile.readableFileSize,
                                    style: AppTheme.theme.textTheme.subtitle1,
                                  ),
                                ],
                              ),
                              const Expanded(child: SizedBox.shrink()),
                              IconButton(
                                onPressed: () => widget.viewModel.shareBackupFile(backupFile),
                                icon: const Icon(Icons.share),
                                color: AppColors.accentColor,
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                );
              case FutureStatus.pending:
              case FutureStatus.rejected:
                return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}
