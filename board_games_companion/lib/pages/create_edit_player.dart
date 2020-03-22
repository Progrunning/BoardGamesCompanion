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
      floatingActionButton: Opacity(
        opacity: _isEditMode ? Styles.opaqueOpacity : Styles.transparentOpacity,
        child: IconAndTextButton(
          title: 'Delete ',
          icon: Icons.delete,
          color: Colors.redAccent,
          onPressed: () {},
        ),
      ),
    );
  }
}
