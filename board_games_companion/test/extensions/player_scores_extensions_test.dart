import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/models/hive/score_game_results.dart';
import 'package:board_games_companion/models/player_score.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const PlayerScore samplePlayerScore = PlayerScore(
    player: Player(id: ''),
    score: Score(
      id: '',
      playerId: '',
      boardGameId: '',
      scoreGameResult: ScoreGameResult(points: 1),
    ),
  );

  setUp(() {});

  group('Filtering out tied scores ', () {
    void verifyTiedScores(
        List<PlayerScore> playerScores, List<PlayerScore> expectedTiedPlayerScores) {
      test(
          'GIVEN a collection of player scores '
          'WHEN filtering out tied scores '
          'THEN returned scores should only be tied  ', () async {
        final tiedPlayerScores = playerScores.onlyTiedScores();
        expect(tiedPlayerScores, expectedTiedPlayerScores);
      });
    }

    verifyTiedScores([], []);
    verifyTiedScores([samplePlayerScore], []);
    verifyTiedScores(
        [samplePlayerScore, samplePlayerScore.copyWith()], [samplePlayerScore, samplePlayerScore]);
    verifyTiedScores([
      samplePlayerScore,
      samplePlayerScore.copyWith(
        score: samplePlayerScore.score.copyWith(
          scoreGameResult: const ScoreGameResult(points: 2222),
        ),
      )
    ], []);
    verifyTiedScores([
      samplePlayerScore,
      samplePlayerScore.copyWith(),
      samplePlayerScore.copyWith(
        score: samplePlayerScore.score.copyWith(
          scoreGameResult: const ScoreGameResult(points: 231),
        ),
      )
    ], [
      samplePlayerScore,
      samplePlayerScore,
    ]);
    verifyTiedScores([
      samplePlayerScore,
      samplePlayerScore.copyWith(),
      samplePlayerScore.copyWith(
        score: samplePlayerScore.score.copyWith(
          scoreGameResult: const ScoreGameResult(points: 1),
        ),
      )
    ], [
      samplePlayerScore,
      samplePlayerScore,
      samplePlayerScore,
    ]);
  });
}
