import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/models/player_score.dart';
import 'package:board_games_companion/models/playthroughs/playthrough_details.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PlaythroughDetails playthroughDetails;

  const Player emptyPlayer = Player(id: '');
  const Score emptyScore = Score(boardGameId: '', id: '', playerId: '', value: '');
  const PlayerScore emptyPlayerScore = PlayerScore(
    player: emptyPlayer,
    score: emptyScore,
  );

  final Playthrough emptyPlaythrough = Playthrough(
    boardGameId: '',
    id: '',
    playerIds: [],
    scoreIds: [],
    startDate: clock.now(),
  );

  setUp(() {});

  test(
      'GIVEN playthrough details  '
      'WHEN there are scores with the same score '
      'THEN then the hasTies property should be true ', () {
    playthroughDetails = PlaythroughDetails(
      playthrough: emptyPlaythrough,
      playerScores: <PlayerScore>[
        emptyPlayerScore.copyWith(score: emptyScore.copyWith(value: '100')),
        emptyPlayerScore.copyWith(score: emptyScore.copyWith(value: '100')),
        emptyPlayerScore.copyWith(score: emptyScore.copyWith(value: '200')),
      ],
    );

    expect(playthroughDetails.hasTies, isTrue);
  });
}
