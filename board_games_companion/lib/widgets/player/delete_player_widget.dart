import 'package:flutter/material.dart';

import '../../common/dimensions.dart';
import '../../common/routes.dart';
import '../../common/strings.dart';
import '../../models/hive/player.dart';
import '../../stores/players_store.dart';
import '../common/default_icon.dart';
import '../common/icon_and_text_button.dart';

class DeletePlayer extends StatelessWidget {
  const DeletePlayer({
    Key key,
    @required Player player,
    @required PlayersStore playersStore,
  })  : _player = player,
        _playersStore = playersStore,
        super(key: key);

  final Player _player;
  final PlayersStore _playersStore;

  @override
  Widget build(BuildContext context) {
    return IconAndTextButton(
      title: 'Delete',
      icon: const DefaultIcon(Icons.delete),
      color: Colors.redAccent,
      onPressed: () async {
        await showDialog<AlertDialog>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Are you sure you want to delete ${_player?.name}?'),
              elevation: Dimensions.defaultElevation,
              actions: <Widget>[
                FlatButton(
                  child: const Text(Strings.Cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: const Text('Delete'),
                  color: Colors.red,
                  onPressed: () async {
                    final bool deletionSucceeded = await _playersStore.deletePlayer(_player.id);
                    if (deletionSucceeded) {
                      Navigator.popUntil(context, ModalRoute.withName(Routes.home));
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
