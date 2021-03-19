import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../common/animation_tags.dart';
import '../common/app_theme.dart';
import '../common/constants.dart';
import '../common/dimensions.dart';
import '../common/styles.dart';
import '../models/hive/player.dart';
import '../stores/players_store.dart';
import '../widgets/common/custom_icon_button.dart';
import '../widgets/common/page_container_widget.dart';
import '../widgets/player/create_edit_player.dart';
import '../widgets/player/delete_player_widget.dart';
import '../widgets/player/player_avatar.dart';


class CreateEditPlayerPage extends StatelessWidget {
  final PlayersStore _playersStore;

  CreateEditPlayerPage(this._playersStore);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final _player = new Player();
    _player.id = _playersStore.playerToCreateOrEdit.id;
    _player.name = _playersStore.playerToCreateOrEdit.name;    
    _player.imageUri = _playersStore.playerToCreateOrEdit.imageUri;

    final bool _isEditMode = _player.name?.isNotEmpty ?? false;

    _nameController.text = _player.name ?? '';
    _nameController.addListener(() {
      _player.name = _nameController.text;
    });

    List<Widget> _floatingActionButtons = [
      CreateOrUpdatePlayer(
          isEditMode: _isEditMode,
          formKey: _formKey,
          player: _player,
          nameController: _nameController,
          playersStore: _playersStore),
    ];

    if (_isEditMode) {
      _floatingActionButtons.addAll(
        [
          Divider(
            indent: Dimensions.standardSpacing,
          ),
          DeletePlayer(
            player: _player,
            playersStore: _playersStore,
          ),
        ],
      );
    }

    return ChangeNotifierProvider.value(
      value: _player,
      child: Consumer<Player>(
        builder: (_, player, __) {
          final _hasName = _nameController.text?.isNotEmpty ?? false;

          return WillPopScope(
            onWillPop: () async {
              return await _handleOnWillPop(
                context,
                player,
              );
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(_hasName ? player.name : 'New Player'),
              ),
              body: PageContainer(
                child: Padding(
                  padding: const EdgeInsets.all(
                    Dimensions.standardSpacing,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                AppTheme.defaultBoxShadow,
                              ],
                            ),
                            child: SizedBox(
                              height: 220,
                              width: 190,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    Styles.defaultCornerRadius),
                                child: Stack(
                                  children: <Widget>[
                                    Hero(
                                      tag:
                                          '${AnimationTags.playerImageHeroTag}${player?.id}',
                                      child: PlayerAvatar(
                                        imageUri: player?.imageUri,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: Dimensions.halfStandardSpacing,
                                      right: Dimensions.halfStandardSpacing,
                                      child: Row(
                                        children: <Widget>[
                                          CustomIconButton(
                                            Icon(
                                              Icons.filter,
                                              color: AppTheme.defaultTextColor,
                                            ),
                                            onTap: () =>
                                                _handleImagePicking(player),
                                          ),
                                          Divider(
                                            indent:
                                                Dimensions.halfStandardSpacing,
                                          ),
                                          CustomIconButton(
                                            Icon(
                                              Icons.camera,
                                              color: AppTheme.defaultTextColor,
                                            ),
                                            onTap: () =>
                                                _handleTakingPicture(player),
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
                          decoration: InputDecoration(
                            labelText: 'Name',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Player needs to have a name';
                            }

                            return null;
                          },
                          controller: _nameController,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: Row(
                mainAxisSize: MainAxisSize.min,
                children: _floatingActionButtons,
              ),
            ),
          );
        },
      ),
    );
  }

  Future _handleTakingPicture(Player player) async {
    await _handlePickingAndSavingAvatar(player, ImageSource.camera);
  }

  Future _handleImagePicking(Player player) async {
    await _handlePickingAndSavingAvatar(player, ImageSource.gallery);
  }

  Future _handlePickingAndSavingAvatar(
      Player player, ImageSource imageSource) async {
    player.avatarFileToSave = await _imagePicker.getImage(source: imageSource);
    if (player.avatarFileToSave?.path?.isEmpty ?? true) {
      return;
    }

    player.imageUri = player.avatarFileToSave.path;
  }

  Future<bool> _handleOnWillPop(BuildContext context, Player player) async {
    if (_playersStore.playerToCreateOrEdit.imageUri != player.imageUri ||
        _playersStore.playerToCreateOrEdit.name != player.name) {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                  'You didn\'t save your changes. Are you sure you want to navigate away?'),
              elevation: Dimensions.defaultElevation,
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Navigate away'),
                  color: Colors.red,
                  onPressed: () async {
                    _playersStore.playerToCreateOrEdit.imageUri =
                        _playersStore.currentPlayerAvatarImageUri;
                    _playersStore.playerToCreateOrEdit.name =
                        _playersStore.currentPlayerName;
                    // MK Pop the dialog
                    Navigator.of(context).pop();
                    // MK Go back
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });

      return false;
    }

    return true;
  }
}
