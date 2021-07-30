import 'package:flutter/material.dart';

import '../../models/hive/player.dart';
import '../../stores/players_store.dart';
import '../common/default_icon.dart';
import '../common/icon_and_text_button.dart';

class CreateOrUpdatePlayer extends StatelessWidget {
  const CreateOrUpdatePlayer({
    Key key,
    @required bool isEditMode,
    @required GlobalKey<FormState> formKey,
    @required Player player,
    @required TextEditingController nameController,
    @required PlayersStore playersStore,
  })  : _isEditMode = isEditMode,
        _formKey = formKey,
        _player = player,
        _nameController = nameController,
        _playersStore = playersStore,
        super(key: key);

  final bool _isEditMode;
  final GlobalKey<FormState> _formKey;
  final Player _player;
  final TextEditingController _nameController;
  final PlayersStore _playersStore;

  @override
  Widget build(BuildContext context) {
    return IconAndTextButton(
      title: _isEditMode ? 'Update' : 'Create',
      icon: const DefaultIcon(Icons.create),
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          _player.name = _nameController.text;          

          final addingOrUpdatingSucceeded =
              await _playersStore.addOrUpdatePlayer(_player);
          _handlePlayerUpdateResult(
              context, _player, addingOrUpdatingSucceeded);
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
            label: 'Ok',
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    }
  }
}
