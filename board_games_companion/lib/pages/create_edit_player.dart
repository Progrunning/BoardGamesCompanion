import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../common/animation_tags.dart';
import '../common/app_theme.dart';
import '../common/dimensions.dart';
import '../common/styles.dart';
import '../models/hive/player.dart';
import '../stores/players_store.dart';
import '../widgets/common/custom_icon_button.dart';
import '../widgets/common/page_container_widget.dart';
import '../widgets/player/create_edit_player.dart';
import '../widgets/player/delete_player_widget.dart';
import '../widgets/player/player_avatar.dart';
import 'base_page_state.dart';

class CreateEditPlayerPage extends StatefulWidget {
  const CreateEditPlayerPage(
    this._playersStore, {
    Key key,
  }) : super(key: key);

  final PlayersStore _playersStore;

  @override
  _CreateEditPlayerPageState createState() => _CreateEditPlayerPageState();
}

class _CreateEditPlayerPageState extends BasePageState<CreateEditPlayerPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imagePicker = ImagePicker();

  Player _player;
  bool _isEditMode;

  @override
  void initState() {
    super.initState();

    _player = Player();
    _player.id = widget._playersStore.playerToCreateOrEdit.id;
    _player.name = widget._playersStore.playerToCreateOrEdit.name;
    _player.avatarFileName = widget._playersStore.playerToCreateOrEdit.avatarFileName;
    _player.avatarImageUri = widget._playersStore.playerToCreateOrEdit.avatarImageUri;

    _isEditMode = _player.name?.isNotEmpty ?? false;

    _nameController.text = _player.name ?? '';
    _nameController.addListener(() {
      _player.name = _nameController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _floatingActionButtons = [
      CreateOrUpdatePlayer(
          isEditMode: _isEditMode,
          formKey: _formKey,
          player: _player,
          nameController: _nameController,
          playersStore: widget._playersStore),
    ];

    if (_isEditMode) {
      _floatingActionButtons.addAll(
        [
          const Divider(
            indent: Dimensions.standardSpacing,
          ),
          DeletePlayer(
            player: _player,
            playersStore: widget._playersStore,
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
              return _handleOnWillPop(
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
                            decoration: const BoxDecoration(
                              boxShadow: [
                                AppTheme.defaultBoxShadow,
                              ],
                            ),
                            child: SizedBox(
                              height: 220,
                              width: 190,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(Styles.defaultCornerRadius),
                                child: Stack(
                                  children: <Widget>[
                                    Hero(
                                      tag: '${AnimationTags.playerImageHeroTag}${player?.id}',
                                      child: PlayerAvatar(
                                        imageUri: player?.avatarImageUri,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: Dimensions.halfStandardSpacing,
                                      right: Dimensions.halfStandardSpacing,
                                      child: Row(
                                        children: <Widget>[
                                          CustomIconButton(
                                            const Icon(
                                              Icons.filter,
                                              color: AppTheme.defaultTextColor,
                                            ),
                                            onTap: () => _handleImagePicking(player),
                                          ),
                                          const Divider(
                                            indent: Dimensions.halfStandardSpacing,
                                          ),
                                          CustomIconButton(
                                            const Icon(
                                              Icons.camera,
                                              color: AppTheme.defaultTextColor,
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
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future _handleTakingPicture(Player player) async {
    await _handlePickingAndSavingAvatar(player, ImageSource.camera);
  }

  Future _handleImagePicking(Player player) async {
    await _handlePickingAndSavingAvatar(player, ImageSource.gallery);
  }

  Future _handlePickingAndSavingAvatar(Player player, ImageSource imageSource) async {
    player.avatarFileToSave = await _imagePicker.getImage(source: imageSource);
    if (player.avatarFileToSave?.path?.isEmpty ?? true) {
      return;
    }

    // MK Temporarily assign direct path to the file, until user saves the changes for the player and saves the image into the Documents storage.
    player.avatarImageUri = player.avatarFileToSave.path;
  }

  Future<bool> _handleOnWillPop(BuildContext context, Player player) async {
    if (widget._playersStore.playerToCreateOrEdit.avatarImageUri != player.avatarImageUri ||
        widget._playersStore.playerToCreateOrEdit.name != player.name) {
      await showDialog<AlertDialog>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                  "You didn't save your changes. Are you sure you want to navigate away?"),
              elevation: Dimensions.defaultElevation,
              actions: <Widget>[
                FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: const Text('Navigate away'),
                  color: Colors.red,
                  onPressed: () async {
                    widget._playersStore.playerToCreateOrEdit.avatarImageUri =
                        widget._playersStore.playerToCreateOrEdit.avatarImageUri;
                    widget._playersStore.playerToCreateOrEdit.name =
                        widget._playersStore.playerToCreateOrEdit.name;
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
