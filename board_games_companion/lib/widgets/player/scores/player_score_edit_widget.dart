import 'package:board_games_companion/stores/playthrough_store.dart';
import 'package:board_games_companion/stores/playthroughs_store.dart';
import 'package:flutter/material.dart';
import 'package:board_games_companion/models/player_score.dart'
    as player_score_model;
import 'package:provider/provider.dart';

class PlayerScoreEdit extends StatelessWidget {
  final player_score_model.PlayerScore _playerScore;

  const PlayerScoreEdit({
    @required playerScore,
    Key key,
  })  : _playerScore = playerScore,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: TextFormField(
        initialValue: _playerScore.score?.value,
        autofocus: true,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Score',
        ),
        onFieldSubmitted: (value) async {
          await _updatePlayerScore(_playerScore, value, context);
        },
      ),
    );
  }
}

Future<void> _updatePlayerScore(player_score_model.PlayerScore store,
    String value, BuildContext context) async {
  if (!await store.updatePlayerScore(value)) {
    return;
  }

  final playthroughsStore = Provider.of<PlaythroughsStore>(
    context,
    listen: false,
  );
  final playthroughStore = Provider.of<PlaythroughStore>(
    context,
    listen: false,
  );

  await playthroughsStore.updatePlaythrough(playthroughStore.playthrough);
  Navigator.pop(context);
}
