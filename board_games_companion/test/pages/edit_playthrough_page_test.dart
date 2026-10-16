import 'package:board_games_companion/common/app_text.dart';
import 'package:board_games_companion/common/enums/game_classification.dart';
import 'package:board_games_companion/common/enums/game_family.dart';
import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/models/player_score.dart';
import 'package:board_games_companion/models/playthroughs/playthrough_details.dart';
import 'package:board_games_companion/pages/edit_playthrough/edit_playthrough_page.dart';
import 'package:board_games_companion/pages/edit_playthrough/edit_playthrough_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' show ObservableList;
import 'package:mocktail/mocktail.dart';

import '../mocks/game_playthroughs_details_store_mock.dart';

void main() {
  final mockStore = MockGamePlaythroughsDetailsStore();
  const playthroughId = '1';
  const backRoute = '/back';

  late EditPlaythoughViewModel viewModel;

  setUp(() {
    final details = PlaythroughDetails(
      playerScores: const [
        PlayerScore(
          player: Player(id: 'p1'),
          score: Score(boardGameId: '', id: 's1', playerId: 'p1'),
        ),
      ],
      playthrough: Playthrough(
        id: playthroughId,
        boardGameId: '',
        playerIds: [],
        scoreIds: [],
        startDate: DateTime(2024, 1, 1),
      ),
    );
    when(() => mockStore.playthroughsDetails).thenReturn(ObservableList.of([details]));
    when(() => mockStore.gameClassification).thenReturn(GameClassification.Score);
    when(() => mockStore.gameGameFamily).thenReturn(GameFamily.HighestScore);

    viewModel = EditPlaythoughViewModel(mockStore)..setPlaythroughId(playthroughId);
    viewModel.updateStartDate(DateTime(2024, 1, 2));
  });

  tearDown(() => reset(mockStore));

  Future<void> pumpPage(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      initialRoute: '/edit',
      onGenerateRoute: (_) => null,
      onGenerateInitialRoutes: (_) => [
        MaterialPageRoute<void>(
          settings: const RouteSettings(name: backRoute),
          builder: (_) => const Scaffold(body: Text('back')),
        ),
        MaterialPageRoute<void>(
          settings: const RouteSettings(name: '/edit'),
          builder: (_) => EditPlaythroughPage(viewModel: viewModel, goBackPageRoute: backRoute),
        ),
      ],
    ));
    await tester.pump();
  }

  testWidgets(
    'GIVEN unsaved changes on iOS '
    'WHEN the close dialog is cancelled and then opened again '
    'THEN the dialog stays open until the user interacts with it',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      try {
        await pumpPage(tester);

        await tester.tap(find.byIcon(Icons.close).first);
        await tester.pumpAndSettle();
        expect(find.text(AppText.editPlaythroughPageUnsavedChangesDialogTitle), findsOneWidget);

        await tester.tap(find.text(AppText.cancel));
        await tester.pumpAndSettle();
        expect(find.text(AppText.editPlaythroughPageUnsavedChangesDialogTitle), findsNothing);

        await tester.tap(find.byIcon(Icons.close).first);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();
        expect(find.text(AppText.editPlaythroughPageUnsavedChangesDialogTitle), findsOneWidget);
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    },
  );

  testWidgets(
    'GIVEN unsaved changes on iOS '
    'WHEN the close dialog is dismissed via the barrier and opened again '
    'THEN the dialog stays open until the user interacts with it',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      try {
        await pumpPage(tester);
        const title = AppText.editPlaythroughPageUnsavedChangesDialogTitle;

        await tester.tap(find.byIcon(Icons.close).first);
        await tester.pumpAndSettle();
        expect(find.text(title), findsOneWidget);

        await tester.tapAt(const Offset(5, 5));
        await tester.pumpAndSettle();
        expect(find.text(title), findsNothing);

        await tester.tap(find.byIcon(Icons.close).first);
        await tester.pumpAndSettle();
        expect(find.text(title), findsOneWidget);
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    },
  );
}
