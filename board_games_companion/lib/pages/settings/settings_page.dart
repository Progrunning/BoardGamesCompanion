import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobx/mobx.dart';

import '../../common/app_colors.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../models/backup_file.dart';
import '../../widgets/about/detail_item.dart';
import '../../widgets/about/section_title.dart';
import '../../widgets/common/bgg_community_member_text_widget.dart';
import '../../widgets/common/bgg_community_member_user_name_text_field_widget.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/import_collections_button.dart';
import '../../widgets/common/loading_overlay.dart';
import '../../widgets/common/page_container.dart';
import 'settings_page_visual_states.dart';
import 'settings_view_model.dart';

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
    return Observer(
      builder: (_) {
        final scaffold = Scaffold(
          appBar:
              AppBar(title: const Text(AppText.settingsPageTitle, style: AppTheme.titleTextStyle)),
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
                            _UserDetailsPanel(viewModel: widget.viewModel),
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

        if (widget.viewModel.visualState == const SettingsPageVisualState.restoring()) {
          return LoadingOverlay(child: scaffold);
        }

        return scaffold;
      },
    );
  }
}

class _UserDetailsPanel extends StatefulWidget {
  const _UserDetailsPanel({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final SettingsViewModel viewModel;

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
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return widget.viewModel.userVisualState.when(
          user: () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SectionTitle(title: 'User'),
              DetailsItem(
                title: widget.viewModel.userName!,
                subtitle: 'BGG profile page',
                uri: '${Constants.boardGameGeekBaseApiUrl}user/${widget.viewModel.userName!}',
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
                      onPressed: () async {
                        final shouldRemoveUser = await _showRemoveBggUserDialog(context);
                        if (shouldRemoveUser ?? false) {
                          widget.viewModel.removeUser();
                        }
                      },
                    ),
                    const SizedBox(width: Dimensions.standardSpacing),
                    ImportCollectionsButton(usernameCallback: () => widget.viewModel.userName!),
                  ],
                ),
              ),
            ],
          ),
          noUser: () => Padding(
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
          ),
        );
      },
    );
  }

  Future<bool?> _showRemoveBggUserDialog(BuildContext context) async {
    return showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: const <Widget>[
              Text('Are you sure you want to remove your BGG user connection?'),
            ],
          ),
          content: const Text(
            'This will delete your imported board games collection, including the history of gameplays',
          ),
          elevation: Dimensions.defaultElevation,
          actions: <Widget>[
            TextButton(
              child: const Text(
                AppText.cancel,
                style: TextStyle(color: AppColors.accentColor),
              ),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: AppColors.redColor),
              onPressed: () => Navigator.of(context).pop(true),
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
  late ReactionDisposer _restoreSuccessReactionDisposer;

  @override
  void initState() {
    super.initState();

    _restoreSuccessReactionDisposer =
        reaction((_) => widget.viewModel.visualState, (SettingsPageVisualState visualState) {
      final messenger = ScaffoldMessenger.of(context);
      visualState.when(
          restoringFailure: (errorMessage) => _showRestoreFailureSnackbar(messenger),
          initial: () {},
          restoring: () {},
          restoringCancelled: () {},
          restoringSuccess: () => _showRestoreSuceededSnackbar(messenger));
    });

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
    _restoreSuccessReactionDisposer();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
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
            builder: (BuildContext context) {
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
                        _BackupFile(
                          backupFile: backupFile,
                          onDeleteBackup: (BackupFile backupFile) =>
                              widget.viewModel.deleteBackup(backupFile),
                          onShareBackup: (BackupFile backupFile) async =>
                              _shareBackup(context, backupFile),
                        ),
                    ],
                  );
                case FutureStatus.pending:
                case FutureStatus.rejected:
                  return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _shareBackup(BuildContext context, BackupFile backupFile) async {
    Rect? sharePositionOrigin;
    if (Platform.isIOS) {
      // MK https://pub.dev/packages/share_plus#known-issues
      final box = context.findRenderObject() as RenderBox?;
      if (box != null) {
        sharePositionOrigin = box.localToGlobal(Offset.zero) & box.size;
      }
    }

    await widget.viewModel.shareBackupFile(
      backupFile,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  Future<void> _showRestoreSuceededSnackbar(ScaffoldMessengerState messenger) async {
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: Dimensions.snackbarMargin,
        content: const Text(AppText.settingsPageRestoreSucceededMessage),
        action: SnackBarAction(
          label: AppText.ok,
          onPressed: () => messenger.hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss),
        ),
      ),
    );
  }

  Future<void> _showRestoreFailureSnackbar(ScaffoldMessengerState messenger) async {
    messenger.showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: Dimensions.snackbarMargin,
        content: Text(AppText.settingsPageRestoreFailedMessage),
        duration: Duration(seconds: 10),
      ),
    );
  }
}

class _BackupFile extends StatelessWidget {
  const _BackupFile({
    Key? key,
    required this.backupFile,
    required this.onDeleteBackup,
    required this.onShareBackup,
  }) : super(key: key);

  final BackupFile backupFile;
  final Function(BackupFile) onDeleteBackup;
  final Function(BackupFile) onShareBackup;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            icon: Icons.delete,
            onPressed: (_) => onDeleteBackup(backupFile),
            backgroundColor: AppColors.redColor,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
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
                  style: AppTheme.theme.textTheme.titleMedium,
                ),
              ],
            ),
            const Expanded(child: SizedBox.shrink()),
            IconButton(
              onPressed: () => onShareBackup(backupFile),
              icon: const Icon(Icons.share),
              color: AppColors.accentColor,
            ),
          ],
        ),
      ),
    );
  }
}
