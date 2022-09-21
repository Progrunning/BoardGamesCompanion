import 'package:basics/basics.dart';
import 'package:board_games_companion/widgets/elevated_container.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
import '../../widgets/common/page_container_widget.dart';
import '../../widgets/player/player_image.dart';
import '../base_page_state.dart';
import '../home/home_page.dart';
import 'players_view_model.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({
    required this.playersViewModel,
    Key? key,
  }) : super(key: key);

  static const String pageRoute = '/player';

  final PlayersViewModel playersViewModel;

  @override
  PlayerPageState createState() => PlayerPageState();
}

class PlayerPageState extends BasePageState<PlayerPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final nameFocusNode = FocusNode();
  final imagePicker = ImagePicker();

  late Player player;
  late bool isEditMode;

  @override
  void initState() {
    super.initState();

    _setPlayerData();

    nameController.text = player.name ?? '';
    nameController.addListener(() {
      player.name = nameController.text;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: player,
      child: Consumer<Player>(
        builder: (_, player, __) {
          final hasName = nameController.text.isNotEmpty;

          return WillPopScope(
            onWillPop: () async => _handleOnWillPop(context, player),
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  hasName ? nameController.text : AppText.newPlayerPageTitle,
                  style: AppTheme.titleTextStyle,
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
                          Center(
                            child: SizedBox(
                              height: 220,
                              width: 190,
                              child: ElevatedContainer(
                                elevation: AppStyles.defaultElevation,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(AppStyles.defaultCornerRadius),
                                  child: Stack(
                                    children: <Widget>[
                                      Hero(
                                        tag: '${AnimationTags.playerImageHeroTag}${player.id}',
                                        child: PlayerImage(imageUri: player.avatarImageUri),
                                      ),
                                      Positioned(
                                        bottom: Dimensions.halfStandardSpacing,
                                        right: Dimensions.halfStandardSpacing,
                                        child: Row(
                                          children: <Widget>[
                                            CustomIconButton(
                                              const Icon(
                                                Icons.filter,
                                                color: AppColors.defaultTextColor,
                                              ),
                                              onTap: () => _handleImagePicking(player),
                                            ),
                                            const Divider(indent: Dimensions.halfStandardSpacing),
                                            CustomIconButton(
                                              const Icon(
                                                Icons.camera,
                                                color: AppColors.defaultTextColor,
                                              ),
                                              onTap: () => _handleTakingPicture(player),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
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
                          if (player.bggName?.isNotBlank ?? false) ...[
                            const SizedBox(height: Dimensions.doubleStandardSpacing),
                            Text(
                              AppText.playerPagePlayerBggNameTitle,
                              style: AppTheme.defaultTextFieldLabelStyle.copyWith(
                                fontSize: Dimensions.extraSmallFontSize,
                              ),
                            ),
                            Text(
                              player.bggName!,
                              style: AppTheme.defaultTextFieldStyle,
                            ),
                          ],
                          const Expanded(child: SizedBox.shrink()),
                          _ActionButtons(
                            isEditMode: isEditMode,
                            onCreate: (BuildContext context) => _createOrUpdatePlayer(context),
                            onUpdate: (BuildContext context) => _createOrUpdatePlayer(context),
                            onDelete: (BuildContext context) => _showDeletePlayerDialog(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _setPlayerData() {
    player = Player(
      id: widget.playersViewModel.player!.id,
    );

    player.name = widget.playersViewModel.player?.name;
    player.avatarFileName = widget.playersViewModel.player?.avatarFileName;
    player.avatarImageUri = widget.playersViewModel.player?.avatarImageUri;
    player.bggName = widget.playersViewModel.player?.bggName;

    isEditMode = player.name?.isNotEmpty ?? false;
  }

  Future _handleTakingPicture(Player player) async {
    await _handlePickingAndSavingAvatar(player, ImageSource.camera);
  }

  Future _handleImagePicking(Player player) async {
    await _handlePickingAndSavingAvatar(player, ImageSource.gallery);
  }

  Future _handlePickingAndSavingAvatar(Player player, ImageSource imageSource) async {
    player.avatarFileToSave = await imagePicker.pickImage(source: imageSource);
    if (player.avatarFileToSave?.path.isEmpty ?? true) {
      return;
    }

    // MK Temporarily assign direct path to the file, until user saves the changes for the player and saves the image into the Documents storage.
    player.avatarImageUri = player.avatarFileToSave!.path;
  }

  Future<bool> _handleOnWillPop(BuildContext context, Player player) async {
    if (widget.playersViewModel.player!.avatarImageUri != player.avatarImageUri ||
        widget.playersViewModel.player!.name != player.name) {
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
                  onPressed: () async {
                    widget.playersViewModel.player!.avatarImageUri =
                        widget.playersViewModel.player!.avatarImageUri;
                    widget.playersViewModel.player!.name = widget.playersViewModel.player!.name;
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

    player.name = nameController.text;

    final playerUpdatedSuccess = await widget.playersViewModel.createOrUpdatePlayer(player);
    if (playerUpdatedSuccess) {
      if (!mounted) {
        return;
      }

      _showPlayerUpdatedSnackbar(context, player, isEditMode: isEditMode);
      nameFocusNode.unfocus();
      setState(() {
        _setPlayerData();
      });
    }
  }

  Future<void> _showDeletePlayerDialog(BuildContext context) async {
    await showDialog<AlertDialog>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete ${player.name}'),
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
                await widget.playersViewModel.deletePlayers([player.id]);
                if (!mounted) {
                  return;
                }

                Navigator.popUntil(context, ModalRoute.withName(HomePage.pageRoute));
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: AppColors.defaultTextColor),
              ),
            ),
          ],
        );
      },
    );
  }
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
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );

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
            title: 'Delete',
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
