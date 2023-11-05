import 'package:board_games_companion/common/enums/game_family.dart';
import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/models/hive/score_game_results.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const Score emptyScore = Score(boardGameId: '', id: '', playerId: '', value: '');

  setUp(() {});

  group('SortByScore', () {
    test(
        'GIVEN a collection of scores '
        'WHEN sorting by highest score '
        'AND comparing only old scores '
        'THEN scores should be sorted correctly ', () {
      final firstPlaceScore = emptyScore.copyWith(value: '10');
      final lastPlaceScore = emptyScore.copyWith(value: '2');
      final secondPlaceScore = emptyScore.copyWith(value: '7');
      final scores = [
        lastPlaceScore,
        firstPlaceScore,
        secondPlaceScore,
      ];

      final sortedScores = scores.sortByScore(GameFamily.HighestScore);

      expect(sortedScores, [firstPlaceScore, secondPlaceScore, lastPlaceScore]);
    });

    test(
        'GIVEN a collection of scores '
        'WHEN sorting by highest score '
        'AND comparing only old scores with null values '
        'THEN scores should be sorted correctly ', () {
      final firstPlaceScore = emptyScore.copyWith(value: '10');
      final nullValueScore = emptyScore.copyWith(value: null);
      final secondNullValueScore = emptyScore.copyWith(value: null);
      final secondPlaceScore = emptyScore.copyWith(value: '7');
      final scores = [
        nullValueScore,
        firstPlaceScore,
        secondNullValueScore,
        secondPlaceScore,
      ];

      final sortedScores = scores.sortByScore(GameFamily.HighestScore);

      expect(sortedScores, [
        firstPlaceScore,
        secondPlaceScore,
        nullValueScore,
        secondNullValueScore,
      ]);
    });

    test(
        'GIVEN a collection of scores '
        'WHEN sorting by lowest score '
        'AND comparing mix of old and new scores '
        'THEN scores should be sorted correctly ', () {
      final firstPlaceScore =
          emptyScore.copyWith(scoreGameResult: const ScoreGameResult(place: 1, points: 10));
      final nullValueScore = emptyScore.copyWith(value: null);
      final secondPlaceScore = emptyScore.copyWith(value: '7');
      final scores = [
        nullValueScore,
        firstPlaceScore,
        secondPlaceScore,
      ];

      final sortedScores = scores.sortByScore(GameFamily.LowestScore);

      expect(sortedScores, [
        secondPlaceScore,
        firstPlaceScore,
        nullValueScore,
      ]);
    });

    test(
        'GIVEN a collection of scores '
        'WHEN sorting by lowest score '
        'AND comparing mix of old and new scores '
        'AND have a completely empty scores '
        'THEN scores should be sorted correctly ', () {
      final firstPlaceScore =
          emptyScore.copyWith(scoreGameResult: const ScoreGameResult(place: 1, points: 10));
      final nullValueScore = emptyScore.copyWith(value: null, scoreGameResult: null);
      final secondNullValueScore = emptyScore.copyWith(value: null, scoreGameResult: null);
      final secondPlaceScore = emptyScore.copyWith(value: '7');
      final scores = [
        secondNullValueScore,
        secondPlaceScore,
        nullValueScore,
        firstPlaceScore,
      ];

      final sortedScores = scores.sortByScore(GameFamily.LowestScore);

      expect(sortedScores, [
        secondPlaceScore,
        firstPlaceScore,
        nullValueScore,
        secondNullValueScore,
      ]);
    });
  });

  test(
      'GIVEN a collection of scores '
      'WHEN a score has the result with the first place '
      'THEN that single score is a winner ', () {
    final firstPlaceScore =
        emptyScore.copyWith(scoreGameResult: const ScoreGameResult(place: 1, points: 10));
    final scores = [
      emptyScore.copyWith(scoreGameResult: const ScoreGameResult(place: 3, points: 7)),
      firstPlaceScore,
      emptyScore.copyWith(scoreGameResult: const ScoreGameResult(place: 2, points: 9)),
    ];

    // [GameFamily] doesn't matter in this instance because it's used only for the sake of old scores
    // without the [ScoreGameResult]
    final winners = scores.winners(GameFamily.HighestScore);

    expect(winners.length, 1);
    expect(winners, [firstPlaceScore]);
  });

  test(
      'GIVEN a collection of scores '
      'WHEN a victory is shared between scores '
      'THEN multiple score are winners ', () {
    final firstPlaceScore = emptyScore.copyWith(
      playerId: '1',
      scoreGameResult: const ScoreGameResult(place: 1, points: 10),
    );
    final alsoFirstPlaceScore = emptyScore.copyWith(
      playerId: '2',
      scoreGameResult: const ScoreGameResult(place: 1, points: 10),
    );
    final scores = [
      emptyScore.copyWith(scoreGameResult: const ScoreGameResult(place: 3, points: 7)),
      firstPlaceScore,
      alsoFirstPlaceScore,
    ];

    // [GameFamily] doesn't matter in this instance because it's used only for the sake of old scores
    // without the [ScoreGameResult]
    final winners = scores.winners(GameFamily.HighestScore);

    expect(winners.length, 2);
    expect(winners, [firstPlaceScore, alsoFirstPlaceScore]);
  });

  test(
      'GIVEN a collection of scores '
      'WHEN scores are old records, without game score defined '
      'AND the game family is highest score '
      'THEN the highest score value should be a winner based ', () {
    final highestScore = emptyScore.copyWith(playerId: '1', value: '20');
    final scores = [
      emptyScore.copyWith(value: '10'),
      highestScore,
      emptyScore.copyWith(value: '3'),
    ];

    final winners = scores.winners(GameFamily.HighestScore);

    expect(winners.length, 1);
    expect(winners, [highestScore]);
  });

  test(
      'GIVEN a collection of scores '
      'WHEN scores are old records, without game score defined '
      'AND the game family is lowest score '
      'THEN the lowest score value should be a winner based ', () {
    final lowestScore = emptyScore.copyWith(playerId: '1', value: '3');
    final scores = [
      emptyScore.copyWith(value: '20'),
      lowestScore,
      emptyScore.copyWith(value: '13'),
    ];

    final winners = scores.winners(GameFamily.LowestScore);

    expect(winners.length, 1);
    expect(winners, [lowestScore]);
  });
}
