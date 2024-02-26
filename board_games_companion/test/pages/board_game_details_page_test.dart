import 'dart:async';

import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/pages/board_game_details/board_game_details_page.dart';
import 'package:board_games_companion/pages/board_game_details/board_game_details_view_model.dart';
import 'package:board_games_companion/pages/hot_board_games/hot_board_games_page.dart';
import 'package:board_games_companion/services/rate_and_review_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart' show ObservableMap;
import 'package:mocktail/mocktail.dart';

import '../mocks/analytics_service_mock.dart';
import '../mocks/board_games_store_mock.dart';
import '../mocks/preference_service_mock.dart';
import '../mocks/rate_and_review_service_mock.dart';

void main() {
  final MockAnalyticsService mockAnalyticsService = MockAnalyticsService();
  final MockBoardGamesStore mockBoardGamesStore = MockBoardGamesStore();
  final MockPreferencesService mockPreferencesService = MockPreferencesService();
  final MockRateAndReviewService mockRateAndReviewService = MockRateAndReviewService();

  const Type mockNavigationType = HotBoardGamesPage;
  const String mockBoardGameId = '1';
  const BoardGameDetails mockBoardGame = BoardGameDetails(id: mockBoardGameId, name: 'Scythe');

  late final BoardGameDetailsViewModel viewModel;

  setUp(() {
    when(() => mockRateAndReviewService.showRateAndReviewDialog).thenReturn(false);
    when(() => mockBoardGamesStore.allBoardGamesMap).thenReturn(ObservableMap.of({
      mockBoardGameId: mockBoardGame,
    }));

    GetIt.instance.registerSingleton<RateAndReviewService>(mockRateAndReviewService);

    viewModel = BoardGameDetailsViewModel(mockBoardGamesStore, mockAnalyticsService);
    viewModel.setBoardGameId(mockBoardGameId);
    viewModel.setBoardGameImageHeroId(mockBoardGameId);
  });

  tearDown(() {
    GetIt.instance.reset();

    reset(mockAnalyticsService);
    reset(mockPreferencesService);
    reset(mockBoardGamesStore);
  });

  testWidgets(
    'GIVEN board game details page '
    'WHEN game details are loading '
    'THEN the loading shimmer should be shown ',
    (WidgetTester tester) async {
      final refreshBoardGameDetailsCompleter = Completer<void>();
      when(() => mockBoardGamesStore.refreshBoardGameDetails(mockBoardGameId))
          .thenAnswer((_) => refreshBoardGameDetailsCompleter.future);

      await tester.pumpWidget(
        MaterialApp(
          home: BoardGamesDetailsPage(
            viewModel: viewModel,
            navigatingFromType: mockNavigationType,
            preferencesService: mockPreferencesService,
          ),
        ),
      );

      expect(find.byKey(const Key('loadingShimmer')), findsOneWidget);
    },
  );
}
