// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_analytics/firebase_analytics.dart' as _i398;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive/hive.dart' as _i979;
import 'package:in_app_review/in_app_review.dart' as _i553;
import 'package:injectable/injectable.dart' as _i526;
import 'package:screenshot/screenshot.dart' as _i592;

import 'pages/board_game_details/board_game_details_view_model.dart' as _i42;
import 'pages/collections/collection_search_result_view_model.dart' as _i85;
import 'pages/collections/collections_view_model.dart' as _i130;
import 'pages/create_board_game/create_board_game_view_model.dart' as _i545;
import 'pages/edit_playthrough/edit_playthrough_view_model.dart' as _i368;
import 'pages/edit_playthrough/playthrough_note_view_model.dart' as _i181;
import 'pages/home/home_view_model.dart' as _i768;
import 'pages/hot_board_games/hot_board_games_view_model.dart' as _i24;
import 'pages/player/player_view_model.dart' as _i316;
import 'pages/players/players_view_model.dart' as _i441;
import 'pages/plays/plays_view_model.dart' as _i877;
import 'pages/playthroughs/playthrough_migration_view_model.dart' as _i272;
import 'pages/playthroughs/playthrough_players_selection_view_model.dart'
    as _i950;
import 'pages/playthroughs/playthrough_statistics_view_model.dart' as _i730;
import 'pages/playthroughs/playthroughs_game_settings_view_model.dart' as _i415;
import 'pages/playthroughs/playthroughs_history_view_model.dart' as _i416;
import 'pages/playthroughs/playthroughs_log_game_view_model.dart' as _i554;
import 'pages/playthroughs/playthroughs_view_model.dart' as _i164;
import 'pages/settings/settings_view_model.dart' as _i585;
import 'services/analytics_service.dart' as _i385;
import 'services/board_games_filters_service.dart' as _i212;
import 'services/board_games_geek_service.dart' as _i667;
import 'services/board_games_search_service.dart' as _i75;
import 'services/board_games_service.dart' as _i927;
import 'services/environment_service.dart' as _i566;
import 'services/file_service.dart' as _i207;
import 'services/injectable_register_module.dart' as _i837;
import 'services/player_service.dart' as _i29;
import 'services/playthroughs_service.dart' as _i934;
import 'services/preferences_service.dart' as _i701;
import 'services/rate_and_review_service.dart' as _i93;
import 'services/score_service.dart' as _i277;
import 'services/search_service.dart' as _i153;
import 'services/user_service.dart' as _i2;
import 'stores/app_store.dart' as _i947;
import 'stores/board_games_filters_store.dart' as _i981;
import 'stores/board_games_store.dart' as _i839;
import 'stores/game_playthroughs_details_store.dart' as _i791;
import 'stores/players_store.dart' as _i182;
import 'stores/playthroughs_store.dart' as _i85;
import 'stores/scores_store.dart' as _i145;
import 'stores/search_store.dart' as _i566;
import 'stores/user_store.dart' as _i78;
import 'utilities/analytics_route_observer.dart' as _i328;
import 'utilities/screenshot_generator.dart' as _i115;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  gh.factory<_i181.PlaythroughNoteViewModel>(
      () => _i181.PlaythroughNoteViewModel());
  gh.factory<_i979.HiveInterface>(() => registerModule.hive);
  gh.singleton<_i947.AppStore>(() => _i947.AppStore());
  gh.singleton<_i398.FirebaseAnalytics>(() => registerModule.firebaseAnalytics);
  gh.singleton<_i553.InAppReview>(() => registerModule.inAppReview);
  gh.singleton<_i398.FirebaseAnalyticsObserver>(
      () => registerModule.firebaseAnalyticsObserver);
  gh.singleton<_i566.EnvironmentService>(
      () => registerModule.environmentService);
  gh.singleton<_i667.BoardGamesGeekService>(
      () => registerModule.boardGameGeekService);
  gh.singleton<_i207.FileService>(() => _i207.FileService());
  gh.singleton<_i927.BoardGamesService>(() => _i927.BoardGamesService(
        gh<_i979.HiveInterface>(),
        gh<_i667.BoardGamesGeekService>(),
      ));
  gh.singleton<_i212.BoardGamesFiltersService>(
      () => _i212.BoardGamesFiltersService(gh<_i979.HiveInterface>()));
  gh.singleton<_i29.PlayerService>(() => _i29.PlayerService(
        gh<_i979.HiveInterface>(),
        gh<_i207.FileService>(),
      ));
  gh.singleton<_i75.BoardGamesSearchService>(
      () => _i75.BoardGamesSearchService(gh<_i566.EnvironmentService>()));
  gh.singleton<_i153.SearchService>(
      () => _i153.SearchService(gh<_i979.HiveInterface>()));
  gh.singleton<_i2.UserService>(
      () => _i2.UserService(gh<_i979.HiveInterface>()));
  gh.singleton<_i277.ScoreService>(
      () => _i277.ScoreService(gh<_i979.HiveInterface>()));
  gh.singleton<_i701.PreferencesService>(
      () => _i701.PreferencesService(gh<_i979.HiveInterface>()));
  gh.singleton<_i93.RateAndReviewService>(() => _i93.RateAndReviewService(
        gh<_i701.PreferencesService>(),
        gh<_i553.InAppReview>(),
      ));
  gh.singleton<_i182.PlayersStore>(
      () => _i182.PlayersStore(gh<_i29.PlayerService>()));
  gh.singleton<_i934.PlaythroughService>(() => _i934.PlaythroughService(
        gh<_i979.HiveInterface>(),
        gh<_i277.ScoreService>(),
      ));
  gh.singleton<_i78.UserStore>(() => _i78.UserStore(gh<_i2.UserService>()));
  gh.singleton<_i145.ScoresStore>(
      () => _i145.ScoresStore(gh<_i277.ScoreService>()));
  gh.singleton<_i566.SearchStore>(
      () => _i566.SearchStore(gh<_i153.SearchService>()));
  gh.singleton<_i85.PlaythroughsStore>(() => _i85.PlaythroughsStore(
        gh<_i934.PlaythroughService>(),
        gh<_i145.ScoresStore>(),
      ));
  gh.singleton<_i385.AnalyticsService>(() => _i385.AnalyticsService(
        gh<_i398.FirebaseAnalytics>(),
        gh<_i93.RateAndReviewService>(),
      ));
  gh.singleton<_i839.BoardGamesStore>(() => _i839.BoardGamesStore(
        gh<_i927.BoardGamesService>(),
        gh<_i934.PlaythroughService>(),
      ));
  gh.factory<_i877.PlaysViewModel>(() => _i877.PlaysViewModel(
        gh<_i85.PlaythroughsStore>(),
        gh<_i839.BoardGamesStore>(),
        gh<_i182.PlayersStore>(),
        gh<_i145.ScoresStore>(),
        gh<_i385.AnalyticsService>(),
      ));
  gh.factory<_i441.PlayersViewModel>(
      () => _i441.PlayersViewModel(gh<_i182.PlayersStore>()));
  gh.factory<_i950.PlaythroughPlayersSelectionViewModel>(() =>
      _i950.PlaythroughPlayersSelectionViewModel(gh<_i182.PlayersStore>()));
  gh.factory<_i316.PlayerViewModel>(
      () => _i316.PlayerViewModel(gh<_i182.PlayersStore>()));
  gh.singleton<_i585.SettingsViewModel>(() => _i585.SettingsViewModel(
        gh<_i207.FileService>(),
        gh<_i927.BoardGamesService>(),
        gh<_i212.BoardGamesFiltersService>(),
        gh<_i29.PlayerService>(),
        gh<_i2.UserService>(),
        gh<_i934.PlaythroughService>(),
        gh<_i277.ScoreService>(),
        gh<_i701.PreferencesService>(),
        gh<_i947.AppStore>(),
        gh<_i78.UserStore>(),
        gh<_i839.BoardGamesStore>(),
      ));
  gh.singleton<_i981.BoardGamesFiltersStore>(() => _i981.BoardGamesFiltersStore(
        gh<_i212.BoardGamesFiltersService>(),
        gh<_i385.AnalyticsService>(),
      ));
  gh.singleton<_i791.GamePlaythroughsDetailsStore>(
      () => _i791.GamePlaythroughsDetailsStore(
            gh<_i85.PlaythroughsStore>(),
            gh<_i145.ScoresStore>(),
            gh<_i182.PlayersStore>(),
            gh<_i839.BoardGamesStore>(),
          ));
  gh.factory<_i415.PlaythroughsGameSettingsViewModel>(
      () => _i415.PlaythroughsGameSettingsViewModel(
            gh<_i839.BoardGamesStore>(),
            gh<_i791.GamePlaythroughsDetailsStore>(),
          ));
  gh.factory<_i42.BoardGameDetailsViewModel>(
      () => _i42.BoardGameDetailsViewModel(
            gh<_i839.BoardGamesStore>(),
            gh<_i385.AnalyticsService>(),
          ));
  gh.singleton<_i24.HotBoardGamesViewModel>(() => _i24.HotBoardGamesViewModel(
        gh<_i839.BoardGamesStore>(),
        gh<_i667.BoardGamesGeekService>(),
        gh<_i385.AnalyticsService>(),
      ));
  gh.factory<_i554.PlaythroughsLogGameViewModel>(
      () => _i554.PlaythroughsLogGameViewModel(
            gh<_i182.PlayersStore>(),
            gh<_i791.GamePlaythroughsDetailsStore>(),
            gh<_i385.AnalyticsService>(),
          ));
  gh.factory<_i164.PlaythroughsViewModel>(() => _i164.PlaythroughsViewModel(
        gh<_i791.GamePlaythroughsDetailsStore>(),
        gh<_i182.PlayersStore>(),
        gh<_i385.AnalyticsService>(),
        gh<_i927.BoardGamesService>(),
        gh<_i78.UserStore>(),
      ));
  gh.factory<_i328.AnalyticsRouteObserver>(
      () => _i328.AnalyticsRouteObserver(gh<_i385.AnalyticsService>()));
  gh.factory<_i85.CollectionSearchResultViewModel>(
      () => _i85.CollectionSearchResultViewModel(gh<_i839.BoardGamesStore>()));
  gh.factory<_i545.CreateBoardGameViewModel>(
      () => _i545.CreateBoardGameViewModel(
            gh<_i839.BoardGamesStore>(),
            gh<_i207.FileService>(),
          ));
  gh.factory<_i130.CollectionsViewModel>(() => _i130.CollectionsViewModel(
        gh<_i78.UserStore>(),
        gh<_i839.BoardGamesStore>(),
        gh<_i981.BoardGamesFiltersStore>(),
        gh<_i145.ScoresStore>(),
        gh<_i85.PlaythroughsStore>(),
        gh<_i182.PlayersStore>(),
      ));
  gh.singleton<_i115.ScreenshotGenerator>(() => _i115.ScreenshotGenerator(
        screenshotController: gh<_i592.ScreenshotController>(),
        rateAndReviewService: gh<_i93.RateAndReviewService>(),
        analyticsService: gh<_i385.AnalyticsService>(),
      ));
  gh.factory<_i368.EditPlaythoughViewModel>(() =>
      _i368.EditPlaythoughViewModel(gh<_i791.GamePlaythroughsDetailsStore>()));
  gh.singleton<_i730.PlaythroughStatisticsViewModel>(
      () => _i730.PlaythroughStatisticsViewModel(
            gh<_i29.PlayerService>(),
            gh<_i145.ScoresStore>(),
            gh<_i791.GamePlaythroughsDetailsStore>(),
          ));
  gh.factory<_i768.HomeViewModel>(() => _i768.HomeViewModel(
        gh<_i385.AnalyticsService>(),
        gh<_i93.RateAndReviewService>(),
        gh<_i441.PlayersViewModel>(),
        gh<_i981.BoardGamesFiltersStore>(),
        gh<_i130.CollectionsViewModel>(),
        gh<_i24.HotBoardGamesViewModel>(),
        gh<_i877.PlaysViewModel>(),
        gh<_i947.AppStore>(),
        gh<_i566.SearchStore>(),
        gh<_i839.BoardGamesStore>(),
        gh<_i75.BoardGamesSearchService>(),
      ));
  gh.factory<_i416.PlaythroughsHistoryViewModel>(() =>
      _i416.PlaythroughsHistoryViewModel(
          gh<_i791.GamePlaythroughsDetailsStore>()));
  gh.factory<_i272.PlaythroughMigrationViewModel>(() =>
      _i272.PlaythroughMigrationViewModel(
          gh<_i791.GamePlaythroughsDetailsStore>()));
  return getIt;
}

class _$RegisterModule extends _i837.RegisterModule {}
