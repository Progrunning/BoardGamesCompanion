import 'package:basics/basics.dart';
import 'package:board_games_companion/widgets/elevated_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';

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
import '../../widgets/player/player_image.dart';
import '../base_page_state.dart';
import '../home/home_page.dart';
import 'player_view_model.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

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
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async => _handleOnWillPop(context),
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
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.standardSpacing),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Observer(
                        builder: (_) {
                          return _PlayerAvatar(
                            playerWorkingCopy: widget.viewModel.playerWorkingCopy!,
                            onPickImage: (imageSource) async =>
                                _handlePickingAndSavingAvatar(imageSource),
                          );
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: AppText.playerPagePlayerNameTitle,
                          labelStyle: AppTheme.defaultTextFieldLabelStyle,
                        ),
                        style: AppTheme.defaultTextFieldStyle,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Player needs to have a name';
                          }

                          return null;
                        },
                        controller: nameController,
                        focusNode: nameFocusNode,
                      ),
                      if (widget.viewModel.playerWorkingCopy!.bggName.isNotNullOrBlank) ...[
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
                      const Expanded(child: SizedBox.shrink()),
                      Observer(
                        builder: (_) {
                          return _ActionButtons(
                            isEditMode: widget.viewModel.isEditMode,
                            onCreate: (BuildContext context) => _createOrUpdatePlayer(context),
                            onUpdate: (BuildContext context) => _createOrUpdatePlayer(context),
                            onDelete: (BuildContext context) => _showDeletePlayerDialog(context),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

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

  Future<bool> _handleOnWillPop(BuildContext context) async {
    if (widget.viewModel.hasUnsavedChanges) {
      await showDialog<AlertDialog>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("You didn't save your changes."),
              content: const Text('Are you sure you want to navigate away?'),
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
                  onPressed: () {
                    // MK Pop the dialog
                    Navigator.of(context).pop();
                    // MK Go back
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Navigate away',
                    style: TextStyle(color: AppColors.defaultTextColor),
                  ),
                ),
              ],
            );
          });

      return false;
    }

    return true;
  }

  Future<void> _createOrUpdatePlayer(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    widget.viewModel.playerWorkingCopy =
        widget.viewModel.playerWorkingCopy!.copyWith(name: nameController.text);

    final playerUpdatedSuccess =
        await widget.viewModel.createOrUpdatePlayer(widget.viewModel.playerWorkingCopy!);
    if (playerUpdatedSuccess) {
      if (!mounted) {
        return;
      }

      _showPlayerUpdatedSnackbar(
        context,
        widget.viewModel.playerWorkingCopy!,
        isEditMode: widget.viewModel.isEditMode,
      );
      nameFocusNode.unfocus();
    }
  }

  Future<void> _showDeletePlayerDialog(BuildContext context) async {
    await showDialog<AlertDialog>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete ${widget.viewModel.playerWorkingCopy!.name}'),
          content: const Text('Are you sure you want to delete this player?'),
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
                if (!mounted) {
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
}

class _PlayerAvatar extends StatelessWidget {
  const _PlayerAvatar({
    required this.playerWorkingCopy,
    required this.onPickImage,
    Key? key,
  }) : super(key: key);

  final Player playerWorkingCopy;
  final void Function(ImageSource) onPickImage;

  @override
  Widget build(BuildContext context) => Center(
        child: SizedBox(
          height: 220,
          width: 190,
          child: ElevatedContainer(
            elevation: AppStyles.defaultElevation,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppStyles.defaultCornerRadius),
              child: Stack(
                children: <Widget>[
                  Hero(
                    tag: '${AnimationTags.playerImageHeroTag}${playerWorkingCopy.id}',
                    child: PlayerImage(imageUri: playerWorkingCopy.avatarImageUri),
                  ),
                  Positioned(
                    bottom: Dimensions.halfStandardSpacing,
                    right: Dimensions.halfStandardSpacing,
                    child: Row(
                      children: <Widget>[
                        CustomIconButton(
                          const Icon(Icons.filter, color: AppColors.defaultTextColor),
                          onTap: () => onPickImage(ImageSource.gallery),
                        ),
                        const Divider(indent: Dimensions.halfStandardSpacing),
                        CustomIconButton(
                          const Icon(Icons.camera, color: AppColors.defaultTextColor),
                          onTap: () => onPickImage(ImageSource.camera),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.isEditMode,
    required this.onCreate,
    required this.onUpdate,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  final bool isEditMode;
  final Function(BuildContext) onCreate;
  final Function(BuildContext) onUpdate;
  final Function(BuildContext) onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isEditMode) ...[
          ElevatedIconButton(
            title: AppText.delete,
            icon: const DefaultIcon(Icons.delete),
            color: Colors.redAccent,
            onPressed: () => onDelete(context),
          ),
          const SizedBox(width: Dimensions.standardSpacing),
        ],
        ElevatedIconButton(
          title: isEditMode ? 'Update' : 'Create',
          icon: const DefaultIcon(Icons.create),
          onPressed: () => isEditMode ? onUpdate(context) : onCreate(context),
        ),
      ],
    );
  }
}
