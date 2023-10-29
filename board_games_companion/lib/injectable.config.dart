// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_analytics/firebase_analytics.dart' as _i8;
import 'package:get_it/get_it.dart' as _i1;
import 'package:hive/hive.dart' as _i9;
import 'package:injectable/injectable.dart' as _i2;

import 'pages/board_game_details/board_game_details_view_model.dart' as _i46;
import 'pages/collections/collection_search_result_view_model.dart' as _i33;
import 'pages/collections/collections_view_model.dart' as _i34;
import 'pages/create_board_game/create_board_game_view_model.dart' as _i35;
import 'pages/edit_playthrough/edit_playthrough_view_model.dart' as _i47;
import 'pages/edit_playthrough/playthrough_note_view_model.dart' as _i13;
import 'pages/home/home_view_model.dart' as _i48;
import 'pages/hot_board_games/hot_board_games_view_model.dart' as _i37;
import 'pages/player/player_view_model.dart' as _i28;
import 'pages/players/players_view_model.dart' as _i12;
import 'pages/plays/plays_view_model.dart' as _i38;
import 'pages/playthroughs/playthrough_migration_view_model.dart' as _i39;
import 'pages/playthroughs/playthrough_players_selection_view_model.dart'
    as _i14;
import 'pages/playthroughs/playthrough_statistics_view_model.dart' as _i40;
import 'pages/playthroughs/playthroughs_game_settings_view_model.dart' as _i41;
import 'pages/playthroughs/playthroughs_history_view_model.dart' as _i42;
import 'pages/playthroughs/playthroughs_log_game_view_model.dart' as _i43;
import 'pages/playthroughs/playthroughs_view_model.dart' as _i44;
import 'pages/settings/settings_view_model.dart' as _i45;
import 'services/analytics_service.dart' as _i23;
import 'services/board_games_filters_service.dart' as _i24;
import 'services/board_games_geek_service.dart' as _i4;
import 'services/board_games_search_service.dart' as _i26;
import 'services/board_games_service.dart' as _i27;
import 'services/environment_service.dart' as _i6;
import 'services/file_service.dart' as _i7;
import 'services/injectable_register_module.dart' as _i49;
import 'services/player_service.dart' as _i10;
import 'services/playthroughs_service.dart' as _i29;
import 'services/preferences_service.dart' as _i15;
import 'services/rate_and_review_service.dart' as _i16;
import 'services/score_service.dart' as _i17;
import 'services/search_service.dart' as _i19;
import 'services/user_service.dart' as _i21;
import 'stores/app_store.dart' as _i3;
import 'stores/board_games_filters_store.dart' as _i25;
import 'stores/board_games_store.dart' as _i32;
import 'stores/game_playthroughs_details_store.dart' as _i36;
import 'stores/players_store.dart' as _i11;
import 'stores/playthroughs_store.dart' as _i30;
import 'stores/scores_store.dart' as _i18;
import 'stores/search_store.dart' as _i20;
import 'stores/user_store.dart' as _i22;
import 'utilities/analytics_route_observer.dart' as _i31;
import 'utilities/custom_http_client_adapter.dart' as _i5;

// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  gh.singleton<_i3.AppStore>(_i3.AppStore());
  gh.singleton<_i4.BoardGamesGeekService>(registerModule.boardGameGeekService);
  gh.factory<_i5.CustomHttpClientAdapter>(() => _i5.CustomHttpClientAdapter());
  gh.singleton<_i6.EnvironmentService>(_i6.EnvironmentService());
  gh.singleton<_i7.FileService>(_i7.FileService());
  gh.singleton<_i8.FirebaseAnalytics>(registerModule.firebaseAnalytics);
  gh.singleton<_i8.FirebaseAnalyticsObserver>(
      registerModule.firebaseAnalyticsObserver);
  gh.factory<_i9.HiveInterface>(() => registerModule.hive);
  gh.singleton<_i10.PlayerService>(_i10.PlayerService(
    gh<_i9.HiveInterface>(),
    gh<_i7.FileService>(),
  ));
  gh.singleton<_i11.PlayersStore>(_i11.PlayersStore(gh<_i10.PlayerService>()));
  gh.factory<_i12.PlayersViewModel>(
      () => _i12.PlayersViewModel(gh<_i11.PlayersStore>()));
  gh.factory<_i13.PlaythroughNoteViewModel>(
      () => _i13.PlaythroughNoteViewModel());
  gh.factory<_i14.PlaythroughPlayersSelectionViewModel>(
      () => _i14.PlaythroughPlayersSelectionViewModel(gh<_i11.PlayersStore>()));
  gh.singleton<_i15.PreferencesService>(
      _i15.PreferencesService(gh<_i9.HiveInterface>()));
  gh.singleton<_i16.RateAndReviewService>(
      _i16.RateAndReviewService(gh<_i15.PreferencesService>()));
  gh.singleton<_i17.ScoreService>(_i17.ScoreService(gh<_i9.HiveInterface>()));
  gh.singleton<_i18.ScoresStore>(_i18.ScoresStore(gh<_i17.ScoreService>()));
  gh.singleton<_i19.SearchService>(_i19.SearchService(gh<_i9.HiveInterface>()));
  gh.singleton<_i20.SearchStore>(_i20.SearchStore(gh<_i19.SearchService>()));
  gh.singleton<_i21.UserService>(_i21.UserService(gh<_i9.HiveInterface>()));
  gh.singleton<_i22.UserStore>(_i22.UserStore(gh<_i21.UserService>()));
  gh.singleton<_i23.AnalyticsService>(_i23.AnalyticsService(
    gh<_i8.FirebaseAnalytics>(),
    gh<_i16.RateAndReviewService>(),
  ));
  gh.singleton<_i24.BoardGamesFiltersService>(
      _i24.BoardGamesFiltersService(gh<_i9.HiveInterface>()));
  gh.singleton<_i25.BoardGamesFiltersStore>(_i25.BoardGamesFiltersStore(
    gh<_i24.BoardGamesFiltersService>(),
    gh<_i23.AnalyticsService>(),
  ));
  gh.singleton<_i26.BoardGamesSearchService>(
      _i26.BoardGamesSearchService(gh<_i6.EnvironmentService>()));
  gh.singleton<_i27.BoardGamesService>(_i27.BoardGamesService(
    gh<_i9.HiveInterface>(),
    gh<_i4.BoardGamesGeekService>(),
  ));
  gh.factory<_i28.PlayerViewModel>(
      () => _i28.PlayerViewModel(gh<_i11.PlayersStore>()));
  gh.singleton<_i29.PlaythroughService>(_i29.PlaythroughService(
    gh<_i9.HiveInterface>(),
    gh<_i17.ScoreService>(),
  ));
  gh.singleton<_i30.PlaythroughsStore>(_i30.PlaythroughsStore(
    gh<_i29.PlaythroughService>(),
    gh<_i18.ScoresStore>(),
  ));
  gh.factory<_i31.AnalyticsRouteObserver>(
      () => _i31.AnalyticsRouteObserver(gh<_i23.AnalyticsService>()));
  gh.singleton<_i32.BoardGamesStore>(_i32.BoardGamesStore(
    gh<_i27.BoardGamesService>(),
    gh<_i29.PlaythroughService>(),
  ));
  gh.factory<_i33.CollectionSearchResultViewModel>(
      () => _i33.CollectionSearchResultViewModel(gh<_i32.BoardGamesStore>()));
  gh.factory<_i34.CollectionsViewModel>(() => _i34.CollectionsViewModel(
        gh<_i22.UserStore>(),
        gh<_i32.BoardGamesStore>(),
        gh<_i25.BoardGamesFiltersStore>(),
        gh<_i18.ScoresStore>(),
        gh<_i30.PlaythroughsStore>(),
        gh<_i11.PlayersStore>(),
      ));
  gh.factory<_i35.CreateBoardGameViewModel>(() => _i35.CreateBoardGameViewModel(
        gh<_i32.BoardGamesStore>(),
        gh<_i7.FileService>(),
      ));
  gh.singleton<_i36.GamePlaythroughsDetailsStore>(
      _i36.GamePlaythroughsDetailsStore(
    gh<_i30.PlaythroughsStore>(),
    gh<_i18.ScoresStore>(),
    gh<_i11.PlayersStore>(),
    gh<_i32.BoardGamesStore>(),
  ));
  gh.singleton<_i37.HotBoardGamesViewModel>(_i37.HotBoardGamesViewModel(
    gh<_i32.BoardGamesStore>(),
    gh<_i4.BoardGamesGeekService>(),
    gh<_i23.AnalyticsService>(),
  ));
  gh.factory<_i38.PlaysViewModel>(() => _i38.PlaysViewModel(
        gh<_i30.PlaythroughsStore>(),
        gh<_i32.BoardGamesStore>(),
        gh<_i11.PlayersStore>(),
        gh<_i18.ScoresStore>(),
        gh<_i23.AnalyticsService>(),
      ));
  gh.factory<_i39.PlaythroughMigrationViewModel>(() =>
      _i39.PlaythroughMigrationViewModel(
          gh<_i36.GamePlaythroughsDetailsStore>()));
  gh.singleton<_i40.PlaythroughStatisticsViewModel>(
      _i40.PlaythroughStatisticsViewModel(
    gh<_i10.PlayerService>(),
    gh<_i18.ScoresStore>(),
    gh<_i36.GamePlaythroughsDetailsStore>(),
  ));
  gh.factory<_i41.PlaythroughsGameSettingsViewModel>(
      () => _i41.PlaythroughsGameSettingsViewModel(
            gh<_i32.BoardGamesStore>(),
            gh<_i36.GamePlaythroughsDetailsStore>(),
          ));
  gh.factory<_i42.PlaythroughsHistoryViewModel>(() =>
      _i42.PlaythroughsHistoryViewModel(
          gh<_i36.GamePlaythroughsDetailsStore>()));
  gh.factory<_i43.PlaythroughsLogGameViewModel>(
      () => _i43.PlaythroughsLogGameViewModel(
            gh<_i11.PlayersStore>(),
            gh<_i36.GamePlaythroughsDetailsStore>(),
            gh<_i23.AnalyticsService>(),
          ));
  gh.factory<_i44.PlaythroughsViewModel>(() => _i44.PlaythroughsViewModel(
        gh<_i36.GamePlaythroughsDetailsStore>(),
        gh<_i11.PlayersStore>(),
        gh<_i23.AnalyticsService>(),
        gh<_i27.BoardGamesService>(),
        gh<_i22.UserStore>(),
      ));
  gh.singleton<_i45.SettingsViewModel>(_i45.SettingsViewModel(
    gh<_i7.FileService>(),
    gh<_i27.BoardGamesService>(),
    gh<_i24.BoardGamesFiltersService>(),
    gh<_i10.PlayerService>(),
    gh<_i21.UserService>(),
    gh<_i29.PlaythroughService>(),
    gh<_i17.ScoreService>(),
    gh<_i15.PreferencesService>(),
    gh<_i3.AppStore>(),
    gh<_i22.UserStore>(),
    gh<_i32.BoardGamesStore>(),
  ));
  gh.factory<_i46.BoardGameDetailsViewModel>(
      () => _i46.BoardGameDetailsViewModel(
            gh<_i32.BoardGamesStore>(),
            gh<_i23.AnalyticsService>(),
          ));
  gh.factory<_i47.EditPlaythoughViewModel>(() =>
      _i47.EditPlaythoughViewModel(gh<_i36.GamePlaythroughsDetailsStore>()));
  gh.factory<_i48.HomeViewModel>(() => _i48.HomeViewModel(
        gh<_i23.AnalyticsService>(),
        gh<_i16.RateAndReviewService>(),
        gh<_i12.PlayersViewModel>(),
        gh<_i25.BoardGamesFiltersStore>(),
        gh<_i34.CollectionsViewModel>(),
        gh<_i37.HotBoardGamesViewModel>(),
        gh<_i38.PlaysViewModel>(),
        gh<_i3.AppStore>(),
        gh<_i20.SearchStore>(),
        gh<_i32.BoardGamesStore>(),
        gh<_i26.BoardGamesSearchService>(),
      ));
  return getIt;
}

class _$RegisterModule extends _i49.RegisterModule {}
