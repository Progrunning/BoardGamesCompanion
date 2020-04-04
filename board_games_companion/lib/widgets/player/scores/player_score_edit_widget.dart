import 'package:flutter/material.dart';
import 'package:board_games_companion/models/player_score.dart'
    as player_score_model;

class PlayerScoreEdit extends StatelessWidget {
  final TextEditingController _controller;
  final player_score_model.PlayerScore _playerScore;
  final void Function(String) _onSubmit;

  const PlayerScoreEdit({
    @required controller,
    @required playerScore,
    @required onSubmit,
    Key key,
  })  : _controller = controller,
        _playerScore = playerScore,
        _onSubmit = onSubmit,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: TextFormField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Score',
          fillColor: Colors.red,
        ),
        onFieldSubmitted: (value) async {
          _onSubmit(value);
        },
      ),
    );
  }
}
