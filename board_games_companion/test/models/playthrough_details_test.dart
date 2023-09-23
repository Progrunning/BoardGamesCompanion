import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/models/player_score.dart';
import 'package:board_games_companion/models/playthroughs/playthrough_details.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PlaythroughDetails playthroughDetails;

  setUp(() {});

  test(
      'GIVEN playthrough details  '
      'WHEN there are scores with ties '
      'THEN then the hasTies property should be true ', () {
    playthroughDetails = PlaythroughDetails(
      playthrough: Playthrough(
        boardGameId: '',
        id: '',
        playerIds: [],
        scoreIds: [],
        startDate: DateTime.now(),
      ),
      playerScores: <PlayerScore>[
        const PlayerScore(
          player: Player(id: ''),
          score: Score(boardGameId: '', id: '', playerId: '', value: '100'),
        ),
        const PlayerScore(
          player: Player(id: ''),
          score: Score(boardGameId: '', id: '', playerId: '', value: '100'),
        ),
      ],
    );

    expect(playthroughDetails.hasTies, isTrue);
  });
}
