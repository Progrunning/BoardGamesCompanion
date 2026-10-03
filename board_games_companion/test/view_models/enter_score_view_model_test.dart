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

  void typeDigits(EnterScoreViewModel viewModel, String digits) {
    digits.split('').forEach(viewModel.appendDigit);
  }

  late EnterScoreViewModel viewModel;

  group('GIVEN a fresh view model with no score', () {
    setUp(() {
      viewModel = EnterScoreViewModel(emptyPlayerScore);
    });

    test('WHEN created THEN the score is 0 and the score entry is empty', () {
      expect(viewModel.score, 0);
      expect(viewModel.scoreEntry, '');
      expect(viewModel.canCommitScoreEntry, false);
      expect(viewModel.canUndo, false);
    });

    test('WHEN digits are typed THEN the score entry accumulates them', () {
      typeDigits(viewModel, '1350');

      expect(viewModel.scoreEntry, '1350');
      expect(viewModel.canCommitScoreEntry, true);
      expect(viewModel.score, 0);
    });

    test('WHEN a typed value is added THEN the total is exactly that value', () {
      typeDigits(viewModel, '1350');
      viewModel.commitAdd();

      expect(viewModel.score, 1350);
      expect(viewModel.partialScores, [1350]);
      expect(viewModel.scoreEntry, '');
    });

    test('WHEN subtract is pressed before a value is typed THEN the partial score is negative',
        () {
      viewModel.commitSubtract();
      typeDigits(viewModel, '247');
      viewModel.commitAdd();

      expect(viewModel.score, -247);
      expect(viewModel.partialScores, [-247]);
      expect(viewModel.scoreEntry, '');
    });

    test('WHEN a sign key is pressed THEN it commits the pending value and signs the next one',
        () {
      typeDigits(viewModel, '10');
      viewModel.commitSubtract();

      expect(viewModel.partialScores, [10]);
      expect(viewModel.pendingOperator, ScoreOperator.subtract);

      typeDigits(viewModel, '4');
      viewModel.commitAdd();

      expect(viewModel.partialScores, [10, -4]);
      expect(viewModel.pendingOperator, ScoreOperator.add);
      expect(viewModel.score, 6);
    });

    test('WHEN a sign key is pressed on an empty entry THEN it only changes the pending sign', () {
      viewModel.commitSubtract();
      expect(viewModel.pendingOperator, ScoreOperator.subtract);
      expect(viewModel.partialScores, isEmpty);

      viewModel.commitAdd();

      expect(viewModel.pendingOperator, ScoreOperator.add);
      expect(viewModel.partialScores, isEmpty);
    });

    test('WHEN the pending sign is subtract and the sheet is closed THEN the entry is subtracted',
        () {
      viewModel.commitSubtract();
      typeDigits(viewModel, '50');
      viewModel.close();

      expect(viewModel.score, -50);
      expect(viewModel.partialScores, [-50]);
    });

    test('WHEN a seventh digit is typed THEN it is rejected', () {
      typeDigits(viewModel, '999999');
      expect(viewModel.scoreEntry, '999999');

      viewModel.appendDigit('1');

      expect(viewModel.scoreEntry, '999999');
    });

    test('WHEN a leading zero is typed THEN the next digit replaces it', () {
      viewModel.appendDigit('0');
      expect(viewModel.scoreEntry, '0');

      viewModel.appendDigit('5');

      expect(viewModel.scoreEntry, '5');
    });

    test('WHEN only a zero is typed THEN it cannot be committed', () {
      viewModel.appendDigit('0');

      expect(viewModel.canCommitScoreEntry, false);

      viewModel.commitAdd();

      expect(viewModel.score, 0);
      expect(viewModel.partialScores, isEmpty);
    });

    test('WHEN an empty score entry is committed THEN nothing is added', () {
      viewModel.commitAdd();
      viewModel.commitSubtract();

      expect(viewModel.score, 0);
      expect(viewModel.partialScores, isEmpty);
    });

    test('WHEN scores are added one after another THEN each lands as a partial score', () {
      viewModel.updateScore(1);
      viewModel.updateScore(5);
      viewModel.updateScore(10);
      viewModel.updateScore(50);

      expect(viewModel.score, 66);
      expect(viewModel.partialScores, [1, 5, 10, 50]);
    });

    test('WHEN more is subtracted than was scored THEN the total goes negative', () {
      viewModel.updateScore(10);
      viewModel.commitSubtract();
      typeDigits(viewModel, '25');
      viewModel.close();

      expect(viewModel.score, -15);
      expect(viewModel.partialScores, [10, -25]);
    });

    test('WHEN closed with nothing entered THEN the score is 0', () {
      viewModel.close();

      expect(viewModel.score, 0);
      expect(viewModel.partialScores, isEmpty);
    });
  });

  group('GIVEN a view model with an existing score of 100', () {
    setUp(() {
      viewModel = EnterScoreViewModel(playerScoreWithPoints(100));
    });

    test('WHEN a typed value is added THEN it is added to the existing score', () {
      typeDigits(viewModel, '250');
      viewModel.commitAdd();

      expect(viewModel.score, 350);
      expect(viewModel.partialScores, [250]);
    });

    test('WHEN backspace is pressed THEN only the score entry changes', () {
      viewModel.updateScore(5);
      typeDigits(viewModel, '42');

      viewModel.backspace();

      expect(viewModel.scoreEntry, '4');
      expect(viewModel.score, 105);
      expect(viewModel.partialScores, [5]);
    });

    test('WHEN backspace is pressed on an empty score entry THEN nothing happens', () {
      viewModel.backspace();

      expect(viewModel.scoreEntry, '');
      expect(viewModel.score, 100);
    });

    test('WHEN undo is pressed THEN the last partial score is popped', () {
      viewModel.updateScore(5);
      typeDigits(viewModel, '50');
      viewModel.commitAdd();
      expect(viewModel.score, 155);

      viewModel.undo();

      expect(viewModel.score, 105);
      expect(viewModel.partialScores, [5]);
      expect(viewModel.canUndo, true);

      viewModel.undo();

      expect(viewModel.score, 100);
      expect(viewModel.canUndo, false);
    });

    test('WHEN undo is pressed THEN the score entry is left alone', () {
      viewModel.updateScore(5);
      typeDigits(viewModel, '42');

      viewModel.undo();

      expect(viewModel.scoreEntry, '42');
      expect(viewModel.score, 100);
      expect(viewModel.partialScores, isEmpty);
    });

    test('WHEN undo is pressed with nothing to undo THEN nothing happens', () {
      viewModel.undo();

      expect(viewModel.score, 100);
      expect(viewModel.partialScores, isEmpty);
    });

    test('WHEN closed with a pending score entry THEN it is committed as an addition', () {
      typeDigits(viewModel, '50');
      viewModel.close();

      expect(viewModel.score, 150);
      expect(viewModel.partialScores, [50]);
      expect(viewModel.scoreEntry, '');
    });

    test('WHEN closed with no pending score entry THEN the score is untouched', () {
      viewModel.close();

      expect(viewModel.score, 100);
      expect(viewModel.partialScores, isEmpty);
    });
  });

  group('GIVEN the score equation', () {
    setUp(() {
      viewModel = EnterScoreViewModel(playerScoreWithPoints(100));
    });

    test('WHEN nothing has been pressed THEN the equation is empty', () {
      expect(viewModel.scoreEquation, '');
    });

    test('WHEN a number is being typed THEN it reads as the trailing term', () {
      typeDigits(viewModel, '12');

      expect(viewModel.scoreEquation, '+ 12');
    });

    test('WHEN a sign key is waiting for its number THEN the equation ends on the operator', () {
      typeDigits(viewModel, '12');
      viewModel.commitSubtract();

      expect(viewModel.scoreEquation, '+ 12 −');
    });

    test('WHEN terms accumulate THEN they read as one equation', () {
      viewModel.updateScore(5);
      viewModel.commitSubtract();
      typeDigits(viewModel, '12');
      viewModel.commitAdd();
      typeDigits(viewModel, '40');

      expect(viewModel.scoreEquation, '+ 5 − 12 + 40');
    });

    test('WHEN a term is undone THEN it leaves the equation', () {
      viewModel.updateScore(5);
      viewModel.updateScore(10);

      viewModel.undo();

      expect(viewModel.scoreEquation, '+ 5');
    });
  });
}
