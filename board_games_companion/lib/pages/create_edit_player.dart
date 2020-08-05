import 'package:board_games_companion/common/animation_tags.dart';
import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/constants.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/stores/players_store.dart';
import 'package:board_games_companion/widgets/common/custom_icon_button.dart';
import 'package:board_games_companion/widgets/common/page_container_widget.dart';
import 'package:board_games_companion/widgets/player/create_edit_player.dart';
import 'package:board_games_companion/widgets/player/delete_player_widget.dart';
import 'package:board_games_companion/widgets/player/player_avatar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateEditPlayerPage extends StatelessWidget {
  final PlayersStore _playersStore;

  CreateEditPlayerPage(this._playersStore);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Player _player = _playersStore.playerToCreateOrEdit;
    final _isEditMode = _player.name?.isNotEmpty ?? false;

    _nameController.text = _player.name ?? '';

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

          return Scaffold(
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
                            height: Constants.PlayersAvatarHeight,
                            width: Constants.PlayersAvatarWidth,
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
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Row(
              mainAxisSize: MainAxisSize.min,
              children: _floatingActionButtons,
            ),
          );
        },
      ),
    );
  }

  Future _handleTakingPicture(Player player) async {
    final avatarImage = await ImagePicker.pickImage(source: ImageSource.camera);
    if (avatarImage?.path?.isEmpty ?? true) {
      return;
    }

    player.imageUri = avatarImage.path;
  }

  Future _handleImagePicking(Player player) async {
    final avatarImage =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    if (avatarImage?.path?.isEmpty ?? true) {
      return;
    }

    player.imageUri = avatarImage.path;
  }
}
