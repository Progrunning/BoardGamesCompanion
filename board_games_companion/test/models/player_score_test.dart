import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/models/hive/score_game_results.dart';
import 'package:board_games_companion/models/player_score.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const Player emptyPlayer = Player(id: '');
  const Score emptyScore = Score(boardGameId: '', id: '', playerId: '', value: '');
  const PlayerScore emptyPlayerScore = PlayerScore(
    player: emptyPlayer,
    score: emptyScore,
  );

  setUp(() {});

  test(
      'GIVEN player scores with different tiebrekers '
      'WHEN they are compared '
      'THEN they should not be equal ', () {
    final placeTiebreakerScore = emptyPlayerScore.copyWith(
        score: emptyPlayerScore.score.copyWith(
      scoreGameResult: const ScoreGameResult(tiebreakerType: ScoreTiebreakerType.place),
    ));
    final sharedTiebreakerScore = placeTiebreakerScore.copyWith(
        score: emptyPlayerScore.score.copyWith(
      scoreGameResult: const ScoreGameResult(tiebreakerType: ScoreTiebreakerType.shared),
    ));

    expect(placeTiebreakerScore, isNot(equals(sharedTiebreakerScore)));
  });
}
