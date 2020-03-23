import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/hive_boxes.dart';
import 'package:board_games_companion/common/routes.dart';
import 'package:board_games_companion/models/player.dart';
import 'package:board_games_companion/services/player_service.dart';
import 'package:board_games_companion/widgets/icon_and_text_button.dart';
import 'package:board_games_companion/widgets/player_avatar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateEditPlayerPage extends StatefulWidget {
  const CreateEditPlayerPage({
    Key key,
  }) : super(key: key);

  @override
  _CreateEditPlayerPageState createState() => _CreateEditPlayerPageState();
}

class _CreateEditPlayerPageState extends State<CreateEditPlayerPage> {
  final PlayerService _playerService = PlayerService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  Player _player;

  @override
  Widget build(BuildContext context) {
    if (_player == null) {
      _player = ModalRoute.of(context).settings.arguments ?? Player();
    }

    final _isEditMode = _player.name?.isNotEmpty ?? false;

    _nameController.text = _player.name ?? '';

    List<Widget> _floatingActionButtons = [
      CreateOrUpdatePlayer(
          isEditMode: _isEditMode,
          formKey: _formKey,
          player: _player,
          nameController: _nameController,
          playerService: _playerService),
    ];

    if (_isEditMode) {
      _floatingActionButtons.addAll(
        [
          Divider(
            indent: Dimensions.standardSpacing,
          ),
          DeletePlayer(
            player: _player,
            playerService: _playerService,
          ),
        ],
      );
    }

    final _hasName = _nameController.text?.isNotEmpty ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(_hasName ? _nameController.text : 'New Player'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Dimensions.standardSpacing),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(children: <Widget>[
                Center(
                  child: SizedBox(
                    height: 220,
                    width: 190,
                    child: PlayerAvatar(
                      imageUri: _player?.imageUri,
                    ),
                  ),
                ),
                Positioned(
                  top: Dimensions.halfStandardSpacing,
                  right: Dimensions.halfStandardSpacing,
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        child: Icon(
                          Icons.filter,
                          size: 40,
                        ),
                        onTap: () async {
                          final avatarImage = await ImagePicker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {
                            _player.imageUri = avatarImage.path;
                          });
                        },
                      ),
                      Divider(
                        indent: Dimensions.halfStandardSpacing,
                      ),
                      InkWell(
                        child: Icon(
                          Icons.camera,
                          size: 40,
                        ),
                        onTap: () async {
                          final avatarImage = await ImagePicker.pickImage(
                              source: ImageSource.camera);
                          setState(() {
                            _player.imageUri = avatarImage.path;
                          });
                        },
                      ),
                    ],
                  ),
                )
              ]),
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
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: _floatingActionButtons,
      ),
    );
  }

  @override
  void dispose() {
    _playerService.closeBox(HiveBoxes.Players);
    super.dispose();
  }
}

class DeletePlayer extends StatelessWidget {
  const DeletePlayer({
    Key key,
    @required Player player,
    @required PlayerService playerService,
  })  : _player = player,
        _playerService = playerService,
        super(key: key);

  final Player _player;
  final PlayerService _playerService;

  @override
  Widget build(BuildContext context) {
    return IconAndTextButton(
      title: 'Delete',
      icon: Icons.delete,
      color: Colors.redAccent,
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Are you sure you want to delete ${_player?.name}?'),
              elevation: 2,
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Delete'),
                  color: Colors.red,
                  onPressed: () async {
                    var deletionSucceeded =
                        await _playerService.deletePlayer(_player.id);
                    if (deletionSucceeded) {
                      Navigator.popUntil(
                          context, ModalRoute.withName(Routes.home));
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class CreateOrUpdatePlayer extends StatelessWidget {
  const CreateOrUpdatePlayer({
    Key key,
    @required bool isEditMode,
    @required GlobalKey<FormState> formKey,
    @required Player player,
    @required TextEditingController nameController,
    @required PlayerService playerService,
  })  : _isEditMode = isEditMode,
        _formKey = formKey,
        _player = player,
        _nameController = nameController,
        _playerService = playerService,
        super(key: key);

  final bool _isEditMode;
  final GlobalKey<FormState> _formKey;
  final Player _player;
  final TextEditingController _nameController;
  final PlayerService _playerService;

  @override
  Widget build(BuildContext context) {
    return IconAndTextButton(
      title: _isEditMode ? 'Update' : 'Create',
      icon: Icons.create,
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          final playerToAddOrUpdate = _player ?? Player();
          playerToAddOrUpdate.name = _nameController.text;

          final addingOrUpdatingSucceeded =
              await _playerService.addOrUpdatePlayer(playerToAddOrUpdate);
          _handlePlayerUpdateResult(
              context, playerToAddOrUpdate, addingOrUpdatingSucceeded);
        }
      },
    );
  }

  void _handlePlayerUpdateResult(BuildContext context,
      Player playerToAddOrUpdate, bool addingOrUpdatingSucceeded) {
    if (addingOrUpdatingSucceeded) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Player ${playerToAddOrUpdate.name} has been updated successfully'),
          action: SnackBarAction(
            label: "Ok",
            onPressed: () async {},
          ),
        ),
      );
    }
  }
}
