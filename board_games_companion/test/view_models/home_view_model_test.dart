import 'package:board_games_companion/pages/home/home_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/analytics_service_mock.dart';
import '../mocks/app_store_mock.dart';
import '../mocks/board_games_filters_store_mock.dart';
import '../mocks/board_games_search_service.dart';
import '../mocks/board_games_store_test.dart';
import '../mocks/collections_view_model_test.dart';
import '../mocks/hot_board_games_view_model_test.dart';
import '../mocks/players_view_model_mock.dart';
import '../mocks/plays_view_model_test.dart';
import '../mocks/rate_and_review_service_mock.dart';
import '../mocks/search_store_test.dart';

void main() {
  late final MockAnalyticsService mockAnalyticsService = MockAnalyticsService();
  late final MockRateAndReviewService mockRateAndReviewService = MockRateAndReviewService();
  late final MockPlayersViewModel mockPlayerViewModel = MockPlayersViewModel();
  late final MockBoardGamesFiltersStore mockBoardGamesFiltersStore = MockBoardGamesFiltersStore();
  late final MockCollectionsViewModel mockCollectionsViewModel = MockCollectionsViewModel();
  late final MockHotBoardGamesViewModel mockHotBoardGamesViewModel = MockHotBoardGamesViewModel();
  late final MockPlaysViewModel mockPlaysViewModel = MockPlaysViewModel();
  late final MockAppStore mockAppStore = MockAppStore();
  late final MockSearchStore mockSearchStore = MockSearchStore();
  late final MockBoardGamesStore mockBoardGamesStore = MockBoardGamesStore();
  late final MockBoardGamesSearchService mockBoardGamesSearchService =
      MockBoardGamesSearchService();

  late final HomeViewModel homeViewModel;

  setUp(() {
    homeViewModel = HomeViewModel(
      mockAnalyticsService,
      mockRateAndReviewService,
      mockPlayerViewModel,
      mockBoardGamesFiltersStore,
      mockCollectionsViewModel,
      mockHotBoardGamesViewModel,
      mockPlaysViewModel,
      mockAppStore,
      mockSearchStore,
      mockBoardGamesStore,
      mockBoardGamesSearchService,
    );
  });

  group('GIVEN searching for board games ', () {
    test(
        'WHEN bgg search query empty '
        'THEN search is not triggered ', () {
      homeViewModel.updateBggSearchQuery('');

      verifyNever(() => mockBoardGamesSearchService.search(any()));
    });
  });
}
