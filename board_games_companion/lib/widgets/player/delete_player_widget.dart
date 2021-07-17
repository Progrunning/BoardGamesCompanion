import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/routes.dart';
import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/stores/players_store.dart';
import 'package:board_games_companion/widgets/common/icon_and_text_button.dart';
import 'package:flutter/material.dart';

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
      icon: Icons.delete,
      backgroundColor: Colors.redAccent,
      onPressed: () async {
        await showDialog<AlertDialog>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Are you sure you want to delete ${_player?.name}?'),
              elevation: Dimensions.defaultElevation,
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
                        await _playersStore.deletePlayer(_player.id);
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
