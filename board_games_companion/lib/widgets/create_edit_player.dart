import 'package:board_games_companion/models/player.dart';
import 'package:board_games_companion/services/player_service.dart';
import 'package:board_games_companion/widgets/icon_and_text_button.dart';
import 'package:flutter/material.dart';

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
