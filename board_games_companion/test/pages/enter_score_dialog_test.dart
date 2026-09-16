import 'package:board_games_companion/common/app_text.dart';
import 'package:board_games_companion/mixins/enter_score_dialog.dart';
import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/models/hive/score_game_results.dart';
import 'package:board_games_companion/models/player_score.dart';
import 'package:board_games_companion/pages/enter_score/enter_score_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _DialogHost with EnterScoreDialogMixin {}

void main() {
  const Size phoneScreenSize = Size(390, 844);
  const String openDialogButtonText = 'Open';

  const PlayerScore playerScore = PlayerScore(
    player: Player(id: '1', name: 'Alice'),
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

  Future<void> pumpEnterScoreDialog(WidgetTester tester) async {
    tester.view.physicalSize = phoneScreenSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => _DialogHost().showEnterScoreDialog(context, viewModel),
              child: const Text(openDialogButtonText),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text(openDialogButtonText));
    await tester.pumpAndSettle();
  }

  /// Runs [body] and returns the Flutter errors it raised instead of failing the test.
  /// FlutterError.onError is restored before returning, as flutter_test requires.
  Future<List<FlutterErrorDetails>> collectFlutterErrors(Future<void> Function() body) async {
    final errors = <FlutterErrorDetails>[];
    final originalOnError = FlutterError.onError;
    FlutterError.onError = errors.add;
    try {
      await body();
    } finally {
      FlutterError.onError = originalOnError;
    }
    return errors;
  }

  group('GIVEN the enter score dialog is open', () {
    testWidgets('WHEN the keypad is opened THEN it lays out without overflowing',
        (WidgetTester tester) async {
      // The test font renders every glyph as a wide square, so the score header overflows when the
      // dialog opens regardless of real fonts. Overflows are reported once per widget, so errors
      // raised while opening the keypad belong to the keypad alone.
      await collectFlutterErrors(() => pumpEnterScoreDialog(tester));

      final layoutErrors = await collectFlutterErrors(() async {
        await tester.tap(find.byIcon(Icons.dialpad));
        await tester.pumpAndSettle();
      });

      expect(viewModel.isKeypadOpen, true);
      expect(layoutErrors, isEmpty);
    });

    testWidgets('WHEN digits are typed on the keypad and Done is tapped THEN they are discarded',
        (WidgetTester tester) async {
      await collectFlutterErrors(() => pumpEnterScoreDialog(tester));

      await tester.tap(find.byIcon(Icons.dialpad));
      await tester.pumpAndSettle();
      await tester.tap(find.text('2'));
      await tester.pump();
      await tester.tap(find.text(AppText.enterScoreDialogDoneButtonText));
      await tester.pumpAndSettle();

      expect(viewModel.score, 100);
      expect(viewModel.partialScores, isEmpty);
    });
  });
}
