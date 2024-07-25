import 'package:board_games_companion/pages/player/player_visual_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sprintf/sprintf.dart';

import '../../common/animation_tags.dart';
import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../models/hive/player.dart';
import '../../widgets/common/custom_icon_button.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/page_container.dart';
import '../../widgets/common/ripple_effect.dart';
import '../../widgets/elevated_container.dart';
import '../../widgets/player/player_image.dart';
import '../base_page_state.dart';
import '../home/home_page.dart';
import 'player_view_model.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({
    required this.viewModel,
    super.key,
  });

  static const String pageRoute = '/player';

  final PlayerViewModel viewModel;

  @override
  PlayerPageState createState() => PlayerPageState();
}

class PlayerPageState extends BasePageState<PlayerPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final nameFocusNode = FocusNode();
  final imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();

    nameController.text = widget.viewModel.playerWorkingCopy?.name ?? '';
    nameController.addListener(() {
      widget.viewModel.updatePlayerWorkingCopy(
        widget.viewModel.playerWorkingCopy!.copyWith(name: nameController.text),
      );
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        onPopInvoked: (didPop) async => _handleWillPop(context, didPop: didPop),
        child: Scaffold(
          appBar: AppBar(
            title: Observer(
              builder: (_) {
                return Text(
                  widget.viewModel.playerHasName
                      ? widget.viewModel.playerName!
                      : AppText.newPlayerPageTitle,
                  style: AppTheme.titleTextStyle,
                );
              },
            ),
          ),
          body: SafeArea(
            child: PageContainer(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Observer(
                      builder: (_) {
                        return switch (widget.viewModel.visualState) {
                          Deleted() => const _DeletedPlayerBanner(),
                          _ => const SizedBox.shrink()
                        };
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(Dimensions.standardSpacing),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Observer(
                            builder: (_) => _PlayerAvatar(
                              playerWorkingCopy: widget.viewModel.playerWorkingCopy!,
                              onPickImage: switch (widget.viewModel.visualState) {
                                Deleted() => null,
                                _ => (imageSource) async =>
                                    _handlePickingAndSavingAvatar(imageSource),
                              },
                            ),
                          ),
                          Observer(
                            builder: (_) {
                              return TextFormField(
                                decoration: const InputDecoration(
                                  labelText: AppText.playerPagePlayerNameTitle,
                                  labelStyle: AppTheme.defaultTextFieldLabelStyle,
                                ),
                                style: AppTheme.defaultTextFieldStyle,
                                validator: (value) => _validatePlayerName(value),
                                controller: nameController,
                                focusNode: nameFocusNode,
                                readOnly: widget.viewModel.visualState.isDeleted,
                              );
                            },
                          ),
                          if (widget.viewModel.isBggUser) ...[
                            const SizedBox(height: Dimensions.doubleStandardSpacing),
                            Text(
                              AppText.playerPagePlayerBggNameTitle,
                              style: AppTheme.defaultTextFieldLabelStyle.copyWith(
                                fontSize: Dimensions.extraSmallFontSize,
                              ),
                            ),
                            Text(
                              widget.viewModel.playerWorkingCopy!.bggName!,
                              style: AppTheme.defaultTextFieldStyle,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const Expanded(child: SizedBox.shrink()),
                    Padding(
                      padding: const EdgeInsets.all(Dimensions.standardSpacing),
                      child: Observer(
                        builder: (_) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              switch (widget.viewModel.visualState) {
                                Create() => ElevatedIconButton(
                                    title: AppText.playerPageCreatePlayerButtonText,
                                    icon: const DefaultIcon(Icons.create),
                                    onPressed: () => _createOrUpdatePlayer(context),
                                  ),
                                Edit() || Restored() => Row(
                                    children: [
                                      ElevatedIconButton(
                                        title: AppText.delete,
                                        icon: const DefaultIcon(Icons.delete),
                                        color: AppColors.redColor,
                                        onPressed: () => _showDeletePlayerDialog(context),
                                      ),
                                      const SizedBox(width: Dimensions.standardSpacing),
                                      ElevatedIconButton(
                                        title: AppText.playerPageUpdatePlayerButtonText,
                                        icon: const DefaultIcon(Icons.create),
                                        onPressed: () => _createOrUpdatePlayer(context),
                                      ),
                                    ],
                                  ),
                                Deleted() => ElevatedIconButton(
                                    title: AppText.restore,
                                    icon: const DefaultIcon(Icons.restore_from_trash),
                                    color: AppColors.greenColor,
                                    onPressed: () => _restorePlayer(context),
                                  ),
                                _ => const SizedBox.shrink()
                              },
                            ],
                          );
                          // // TODO Move the restore out of the action button
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  String? _validatePlayerName(String? value) {
    if (value!.isEmpty) {
      return AppText.playerPageNavigateAway;
    }

    return null;
  }

  Future<void> _handlePickingAndSavingAvatar(ImageSource imageSource) async {
    final avatarFile = await imagePicker.pickImage(source: imageSource);
    if (avatarFile?.path.isEmpty ?? true) {
      return;
    }

    widget.viewModel.updatePlayerWorkingCopy(
      widget.viewModel.playerWorkingCopy!.copyWith(
        avatarFileToSave: avatarFile,
        // MK Temporarily assign direct path to the file, until user saves the changes for the player and saves the image into the Documents storage.
        avatarImageUri: avatarFile!.path,
      ),
    );
  }

  Future<void> _handleWillPop(BuildContext context, {required bool didPop}) async {
    if (didPop) {
      return;
    }

    if (!widget.viewModel.hasUnsavedChanges) {
      Navigator.of(context).pop();
      return;
    }

    await showDialog<AlertDialog>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppText.playerPageGoBackUnsavedChangesTitle),
          content: const Text(AppText.playerPageNavigateAway),
          elevation: Dimensions.defaultElevation,
          actions: <Widget>[
            TextButton(
              child: const Text(AppText.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: AppColors.redColor),
              onPressed: () => Navigator.of(context).popUntil(
                ModalRoute.withName(HomePage.pageRoute),
              ),
              child: const Text(
                AppText.playerPageNavigateAway,
                style: TextStyle(color: AppColors.defaultTextColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _createOrUpdatePlayer(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    widget.viewModel.playerWorkingCopy =
        widget.viewModel.playerWorkingCopy!.copyWith(name: nameController.text);

    final operationSucceeded =
        await widget.viewModel.createPlayer(widget.viewModel.playerWorkingCopy!);
    if (!operationSucceeded || !context.mounted) {
      return;
    }

    _showPlayerUpdatedSnackbar(
      context,
      widget.viewModel.playerWorkingCopy!,
      isEditMode: widget.viewModel.visualState.isEditMode,
    );
    nameFocusNode.unfocus();
  }

  Future<void> _showDeletePlayerDialog(BuildContext context) async {
    await showDialog<AlertDialog>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            sprintf(
              AppText.playerPageGoBackUnsavedChangesTitle,
              [widget.viewModel.playerWorkingCopy!.name],
            ),
          ),
          content: const Text(AppText.playerPageDeleteConfirmationContent),
          elevation: Dimensions.defaultElevation,
          actions: <Widget>[
            TextButton(
              child: const Text(AppText.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: AppColors.redColor),
              onPressed: () async {
                await widget.viewModel.deletePlayer();
                if (!context.mounted) {
                  return;
                }

                Navigator.popUntil(context, ModalRoute.withName(HomePage.pageRoute));
              },
              child: const Text(
                AppText.delete,
                style: TextStyle(color: AppColors.defaultTextColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPlayerUpdatedSnackbar(
    BuildContext context,
    Player playerToAddOrUpdate, {
    required bool isEditMode,
  }) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Player '),
                TextSpan(
                  text: '${playerToAddOrUpdate.name} ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: 'has been ${isEditMode ? 'updated' : 'created'} successfully'),
              ],
            ),
          ),
          action: SnackBarAction(
            label: AppText.goBack,
            onPressed: () {
              if (!context.mounted) {
                return;
              }

              Navigator.of(context).pop();
            },
          ),
        ),
      );

  Future<void> _restorePlayer(BuildContext context) async {
    final operationSucceeded = await widget.viewModel.restorePlayer();
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: Dimensions.snackbarMargin,
        behavior: SnackBarBehavior.floating,
        content: Text(
          operationSucceeded
              ? AppText.playerPagePlayerRestoreSuccessfully
              : AppText.playerPagePlayerRestoreFailure,
        ),
        backgroundColor: operationSucceeded ? AppColors.greenColor : AppColors.redColor,
      ),
    );
  }
}

class _DeletedPlayerBanner extends StatelessWidget {
  const _DeletedPlayerBanner();

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: Container(
                color: AppColors.redColor,
                child: const Center(
                  child: Text(AppText.playerPagePlayerDeletedBanner),
                ),
              ),
            ),
          ),
        ],
      );
}

class _PlayerAvatar extends StatelessWidget {
  const _PlayerAvatar({
    required this.playerWorkingCopy,
    required this.onPickImage,
  });

  final Player playerWorkingCopy;
  final void Function(ImageSource imageSource)? onPickImage;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 220,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 190,
              child: ElevatedContainer(
                elevation: AppStyles.defaultElevation,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppStyles.defaultCornerRadius),
                  child: Hero(
                    tag: '${AnimationTags.playerImageHeroTag}${playerWorkingCopy.id}',
                    child: PlayerImage(imageUri: playerWorkingCopy.avatarImageUri),
                  ),
                ),
              ),
            ),
            const SizedBox(width: Dimensions.halfStandardSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TODO RippleEffect needs to be replaced by a proper button, to allow for disabled state
                  RippleEffect(
                    onTap: () => onPickImage != null ? onPickImage!(ImageSource.gallery) : null,
                    child: const Padding(
                      padding: EdgeInsets.all(Dimensions.halfStandardSpacing),
                      child: Row(
                        children: [
                          CustomIconButton(
                            Icon(
                              Icons.filter,
                              color: AppColors.defaultTextColor,
                            ),
                          ),
                          SizedBox(width: Dimensions.standardSpacing),
                          Text(AppText.playerPagePickPhoto),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.standardSpacing),
                  RippleEffect(
                    onTap: () => onPickImage != null ? onPickImage!(ImageSource.camera) : null,
                    child: const Padding(
                      padding: EdgeInsets.all(Dimensions.halfStandardSpacing),
                      child: Row(
                        children: [
                          CustomIconButton(
                            Icon(Icons.camera, color: AppColors.defaultTextColor),
                          ),
                          SizedBox(width: Dimensions.standardSpacing),
                          Text(AppText.playerPageTakePhoto),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
