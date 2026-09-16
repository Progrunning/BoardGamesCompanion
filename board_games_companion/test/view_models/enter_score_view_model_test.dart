import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/models/hive/score_game_results.dart';
import 'package:board_games_companion/models/player_score.dart';
import 'package:board_games_companion/pages/enter_score/enter_score_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const emptyScore = Score(id: '', playerId: '', boardGameId: '');
  const emptyPlayerScore = PlayerScore(
    player: Player(id: '1', name: 'Alice'),
    score: emptyScore,
  );

  PlayerScore playerScoreWithPoints(double points) {
    return emptyPlayerScore.copyWith(
      score: emptyScore.copyWith(
        scoreGameResult: ScoreGameResult(points: points),
      ),
    );
  }

  late EnterScoreViewModel viewModel;

  group('GIVEN a fresh view model with no score', () {
    setUp(() {
      viewModel = EnterScoreViewModel(emptyPlayerScore);
    });

    test('WHEN created THEN score is 0 and keypad is closed', () {
      expect(viewModel.score, 0);
      expect(viewModel.isKeypadOpen, false);
      expect(viewModel.keypadDigits, '');
      expect(viewModel.canCommitKeypad, false);
    });

    group('WHEN keypad is opened', () {
      setUp(() {
        viewModel.openKeypad();
      });

      test('WHEN nothing is typed THEN isKeypadOpen is true and digits are empty', () {
        expect(viewModel.isKeypadOpen, true);
        expect(viewModel.keypadDigits, '');
        expect(viewModel.canCommitKeypad, false);
      });

      test('WHEN digits are typed THEN keypadDigits accumulates them', () {
        viewModel.keypadAppendDigit('1');
        viewModel.keypadAppendDigit('3');
        viewModel.keypadAppendDigit('5');
        viewModel.keypadAppendDigit('0');
        expect(viewModel.keypadDigits, '1350');
        expect(viewModel.canCommitKeypad, true);
      });

      test('WHEN committed THEN score equals the typed value and keypad closes', () {
        viewModel.keypadAppendDigit('1');
        viewModel.keypadAppendDigit('3');
        viewModel.keypadAppendDigit('5');
        viewModel.keypadAppendDigit('0');
        viewModel.keypadCommit();

        expect(viewModel.score, 1350);
        expect(viewModel.isKeypadOpen, false);
        expect(viewModel.keypadDigits, '');
        expect(viewModel.partialScores.length, 1);
        expect(viewModel.partialScores[0], 1350);
      });

      test(
          'WHEN operation is subtract and committed '
          'THEN score is negative and partial is negative', () {
        viewModel.updateOperation(EnterScoreOperation.subtract);
        viewModel.keypadAppendDigit('2');
        viewModel.keypadAppendDigit('4');
        viewModel.keypadAppendDigit('7');
        viewModel.keypadCommit();

        expect(viewModel.score, -247);
        expect(viewModel.partialScores[0], -247);
      });

      test(
          'WHEN 6 digits are typed and a 7th is attempted '
          'THEN the 7th digit is rejected', () {
        ['9', '9', '9', '9', '9', '9'].forEach(viewModel.keypadAppendDigit);
        expect(viewModel.keypadDigits, '999999');

        viewModel.keypadAppendDigit('1');
        expect(viewModel.keypadDigits, '999999');
      });

      test('WHEN backspace is pressed THEN the last digit is removed', () {
        viewModel.keypadAppendDigit('4');
        viewModel.keypadAppendDigit('2');
        viewModel.keypadBackspace();
        expect(viewModel.keypadDigits, '4');
      });

      test('WHEN backspace on empty digits THEN nothing happens', () {
        viewModel.keypadBackspace();
        expect(viewModel.keypadDigits, '');
      });

      test('WHEN leading zero is typed THEN it is replaced by next digit', () {
        viewModel.keypadAppendDigit('0');
        expect(viewModel.keypadDigits, '0');
        viewModel.keypadAppendDigit('5');
        expect(viewModel.keypadDigits, '5');
      });

      test(
          'WHEN only 0 is typed and committed '
          'THEN it cannot be committed and nothing is added', () {
        viewModel.keypadAppendDigit('0');
        expect(viewModel.canCommitKeypad, false);

        viewModel.keypadCommit();

        expect(viewModel.isKeypadOpen, true);
        expect(viewModel.score, 0);
        expect(viewModel.partialScores, isEmpty);
      });

      test(
          'WHEN openKeypad is called again while already open '
          'THEN typed digits are preserved', () {
        viewModel.keypadAppendDigit('1');
        viewModel.keypadAppendDigit('2');
        viewModel.openKeypad();
        expect(viewModel.keypadDigits, '12');
        expect(viewModel.isKeypadOpen, true);
      });

      test('WHEN cancelled THEN keypad closes and score is unchanged', () {
        viewModel.keypadAppendDigit('5');
        viewModel.keypadAppendDigit('0');
        viewModel.keypadCancel();

        expect(viewModel.isKeypadOpen, false);
        expect(viewModel.keypadDigits, '');
        expect(viewModel.score, 0);
        expect(viewModel.partialScores, isEmpty);
      });

      test(
          'WHEN committed with empty digits '
          'THEN nothing happens and keypad stays open', () {
        viewModel.keypadCommit();

        expect(viewModel.isKeypadOpen, true);
        expect(viewModel.score, 0);
        expect(viewModel.partialScores, isEmpty);
      });
    });
  });

  group('GIVEN a view model with an existing score of 100', () {
    setUp(() {
      viewModel = EnterScoreViewModel(playerScoreWithPoints(100));
    });

    test(
        'WHEN keypad types 250 and commits '
        'THEN score is 350 (100 + 250)', () {
      viewModel.openKeypad();
      viewModel.keypadAppendDigit('2');
      viewModel.keypadAppendDigit('5');
      viewModel.keypadAppendDigit('0');
      viewModel.keypadCommit();

      expect(viewModel.score, 350);
      expect(viewModel.partialScores.length, 1);
      expect(viewModel.partialScores[0], 250);
    });

    test(
        'WHEN keypad commits then undo '
        'THEN score returns to initial', () {
      viewModel.openKeypad();
      viewModel.keypadAppendDigit('5');
      viewModel.keypadAppendDigit('0');
      viewModel.keypadCommit();

      expect(viewModel.score, 150);
      expect(viewModel.canUndo, true);

      viewModel.undo();
      expect(viewModel.score, 100);
      expect(viewModel.canUndo, false);
    });

    test(
        'WHEN digits are typed on the keypad but not committed and done '
        'THEN the typed digits are discarded', () {
      viewModel.openKeypad();
      viewModel.keypadAppendDigit('5');
      viewModel.keypadAppendDigit('0');
      viewModel.done();

      expect(viewModel.score, 100);
      expect(viewModel.partialScores, isEmpty);
      expect(viewModel.keypadDigits, '');
      expect(viewModel.isKeypadOpen, false);
    });
  });

  group('GIVEN existing tile-based scoring still works', () {
    setUp(() {
      viewModel = EnterScoreViewModel(emptyPlayerScore);
    });

    test('WHEN +1, +5, +10 tiles are tapped THEN score accumulates', () {
      viewModel.addInstantScore(1);
      viewModel.addInstantScore(5);
      viewModel.addInstantScore(10);
      expect(viewModel.score, 16);
      expect(viewModel.partialScores.length, 3);
    });

    test('WHEN operation is subtract and the 5 tile is tapped THEN 5 is subtracted', () {
      viewModel.updateOperation(EnterScoreOperation.subtract);
      viewModel.addInstantScore(5);
      expect(viewModel.score, -5);
      expect(viewModel.partialScores, [-5]);
    });

    test('WHEN the dial is spun back to -3 THEN the score goes down by 3', () {
      viewModel.updateScore(-3);
      expect(viewModel.score, -3);
      expect(viewModel.partialScores, [-3]);
    });

    test('WHEN a keypad value is committed into the empty score THEN it can be undone', () {
      viewModel.openKeypad();
      viewModel.keypadAppendDigit('7');
      viewModel.keypadCommit();
      expect(viewModel.score, 7);
      expect(viewModel.canUndo, true);

      viewModel.undo();
      expect(viewModel.score, 0);
      expect(viewModel.canUndo, false);
    });

    test('WHEN undo is called THEN last partial is removed', () {
      viewModel.updateScore(5);
      viewModel.updateScore(10);
      viewModel.undo();
      expect(viewModel.score, 5);
    });

    test('WHEN done with nothing entered THEN score is 0', () {
      viewModel.done();
      expect(viewModel.score, 0);
      expect(viewModel.partialScores, isEmpty);
    });

    test(
        'WHEN tiles are used then keypad is used '
        'THEN both partials appear in history', () {
      viewModel.updateScore(10);
      viewModel.openKeypad();
      viewModel.keypadAppendDigit('5');
      viewModel.keypadAppendDigit('0');
      viewModel.keypadCommit();

      expect(viewModel.score, 60);
      expect(viewModel.partialScores.length, 2);
      expect(viewModel.partialScores[0], 10);
      expect(viewModel.partialScores[1], 50);
    });
  });
}
