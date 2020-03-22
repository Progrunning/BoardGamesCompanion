import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/player.dart';
import 'package:board_games_companion/widgets/icon_and_text_button.dart';
import 'package:flutter/material.dart';

class CreateEditPlayerPage extends StatelessWidget {
  final Player player;

  const CreateEditPlayerPage({
    Key key,
    this.player,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _isEditMode = player?.name?.isNotEmpty ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? player.name : 'New Player'),
      ),
      body: Container(),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconAndTextButton(
            title: _isEditMode ? 'Update' : 'Create',
            icon: Icons.create,
            onPressed: () {},
          ),
          Divider(
            indent: Dimensions.standardSpacing,
          ),
          Opacity(
            opacity: true ? Styles.opaqueOpacity : Styles.transparentOpacity,
            child: IconAndTextButton(
              title: 'Delete',
              icon: Icons.delete,
              color: Colors.redAccent,
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                          'Are you sure you want to delete ${player?.name}?'),
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
                          onPressed: () {},
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
