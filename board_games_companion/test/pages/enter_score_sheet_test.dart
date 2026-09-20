import 'package:board_games_companion/common/app_text.dart';
import 'package:board_games_companion/mixins/enter_score_sheet.dart';
import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/models/hive/score_game_results.dart';
import 'package:board_games_companion/models/player_score.dart';
import 'package:board_games_companion/pages/enter_score/enter_score_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _SheetHost with EnterScoreSheetMixin {}

void main() {
  const Size phoneScreenSize = Size(390, 844);
  const String openSheetButtonText = 'Open';
  const String playerName = 'Alice';
  final String subtractKey = ScoreOperator.subtract.symbol;

  const PlayerScore playerScore = PlayerScore(
    player: Player(id: '1', name: playerName),
    score: Score(
      id: '',
      playerId: '',
      boardGameId: '',
      scoreGameResult: ScoreGameResult(points: 100),
    ),
  );

  late EnterScoreViewModel viewModel;

  setUp(() {
    viewModel = EnterScoreViewModel(playerScore);
  });

  Future<void> pumpEnterScoreSheet(WidgetTester tester) async {
    tester.view.physicalSize = phoneScreenSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => _SheetHost().showEnterScoreSheet(context, viewModel),
              child: const Text(openSheetButtonText),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text(openSheetButtonText));
    await tester.pumpAndSettle();
  }


  group('GIVEN the enter score sheet is open', () {
    testWidgets('THEN the header shows the player name and their current score',
        (WidgetTester tester) async {
      await pumpEnterScoreSheet(tester);

      expect(find.text('$playerName scored 100', findRichText: true), findsOneWidget);
    });

    testWidgets('THEN the keypad and the instant scores are the surface',
        (WidgetTester tester) async {
      await pumpEnterScoreSheet(tester);

      for (final digit in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) {
        expect(find.widgetWithText(InkWell, digit), findsOneWidget);
      }
      for (final instantScore in ['+1', '+5', '+10', '+50']) {
        expect(find.widgetWithText(InkWell, instantScore), findsOneWidget);
      }
    });

    testWidgets('WHEN a value is typed and added THEN it lands as a single partial score',
        (WidgetTester tester) async {
      await pumpEnterScoreSheet(tester);

      await tester.tap(find.widgetWithText(InkWell, '2'));
      await tester.tap(find.widgetWithText(InkWell, '5'));
      await tester.tap(find.widgetWithText(InkWell, '0'));
      await tester.pump();
      await tester.tap(find.widgetWithText(InkWell, '+'));
      await tester.pumpAndSettle();

      expect(viewModel.score, 350);
      expect(viewModel.partialScores, [250]);
    });

    testWidgets('WHEN digits are typed and Done is tapped THEN they are committed',
        (WidgetTester tester) async {
      await pumpEnterScoreSheet(tester);

      await tester.tap(find.widgetWithText(InkWell, '5'));
      await tester.tap(find.widgetWithText(InkWell, '0'));
      await tester.pump();
      await tester.tap(find.text(AppText.enterScoreSheetDoneButtonText));
      await tester.pumpAndSettle();

      expect(viewModel.score, 150);
      expect(viewModel.partialScores, [50]);
    });

    testWidgets('WHEN digits are typed and the sheet is dismissed THEN they are still committed',
        (WidgetTester tester) async {
      await pumpEnterScoreSheet(tester);

      await tester.tap(find.widgetWithText(InkWell, '5'));
      await tester.tap(find.widgetWithText(InkWell, '0'));
      await tester.pump();
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(viewModel.score, 150);
      expect(viewModel.partialScores, [50]);
    });

    testWidgets('WHEN digits are typed THEN they preview as a term and in the total',
        (WidgetTester tester) async {
      await pumpEnterScoreSheet(tester);

      await tester.tap(find.widgetWithText(InkWell, '1'));
      await tester.tap(find.widgetWithText(InkWell, '2'));
      await tester.pumpAndSettle();

      expect(find.text('$playerName scored 112', findRichText: true), findsOneWidget);
      expect(find.text('+ 12'), findsOneWidget);
      expect(viewModel.score, 100);
      expect(viewModel.partialScores, isEmpty);
    });

    testWidgets('WHEN subtract is pressed first THEN the next number is subtracted',
        (WidgetTester tester) async {
      await pumpEnterScoreSheet(tester);

      await tester.tap(find.widgetWithText(InkWell, subtractKey));
      await tester.tap(find.widgetWithText(InkWell, '1'));
      await tester.tap(find.widgetWithText(InkWell, '2'));
      await tester.pumpAndSettle();

      expect(find.text('$playerName scored 88', findRichText: true), findsOneWidget);
      expect(find.text('− 12'), findsOneWidget);
    });
  });

}
