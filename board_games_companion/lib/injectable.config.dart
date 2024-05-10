// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_analytics/firebase_analytics.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:hive/hive.dart' as _i4;
import 'package:injectable/injectable.dart' as _i2;

import 'pages/board_game_details/board_game_details_view_model.dart' as _i36;
import 'pages/collections/collection_search_result_view_model.dart' as _i40;
import 'pages/collections/collections_view_model.dart' as _i42;
import 'pages/create_board_game/create_board_game_view_model.dart' as _i41;
import 'pages/edit_playthrough/edit_playthrough_view_model.dart' as _i43;
import 'pages/edit_playthrough/playthrough_note_view_model.dart' as _i3;
import 'pages/home/home_view_model.dart' as _i45;
import 'pages/hot_board_games/hot_board_games_view_model.dart' as _i37;
import 'pages/player/player_view_model.dart' as _i30;
import 'pages/players/players_view_model.dart' as _i31;
import 'pages/plays/plays_view_model.dart' as _i29;
import 'pages/playthroughs/playthrough_migration_view_model.dart' as _i47;
import 'pages/playthroughs/playthrough_players_selection_view_model.dart'
    as _i32;
import 'pages/playthroughs/playthrough_statistics_view_model.dart' as _i44;
import 'pages/playthroughs/playthroughs_game_settings_view_model.dart' as _i35;
import 'pages/playthroughs/playthroughs_history_view_model.dart' as _i46;
import 'pages/playthroughs/playthroughs_log_game_view_model.dart' as _i38;
import 'pages/playthroughs/playthroughs_view_model.dart' as _i39;
import 'pages/settings/settings_view_model.dart' as _i33;
import 'services/analytics_service.dart' as _i19;
import 'services/board_games_filters_service.dart' as _i11;
import 'services/board_games_geek_service.dart' as _i8;
import 'services/board_games_search_service.dart' as _i13;
import 'services/board_games_service.dart' as _i10;
import 'services/environment_service.dart' as _i5;
import 'services/file_service.dart' as _i6;
import 'services/injectable_register_module.dart' as _i48;
import 'services/player_service.dart' as _i12;
import 'services/playthroughs_service.dart' as _i21;
import 'services/preferences_service.dart' as _i14;
import 'services/rate_and_review_service.dart' as _i18;
import 'services/score_service.dart' as _i15;
import 'services/search_service.dart' as _i16;
import 'services/user_service.dart' as _i17;
import 'stores/app_store.dart' as _i9;
import 'stores/board_games_filters_store.dart' as _i22;
import 'stores/board_games_store.dart' as _i28;
import 'stores/game_playthroughs_details_store.dart' as _i34;
import 'stores/players_store.dart' as _i20;
import 'stores/playthroughs_store.dart' as _i26;
import 'stores/scores_store.dart' as _i24;
import 'stores/search_store.dart' as _i25;
import 'stores/user_store.dart' as _i23;
import 'utilities/analytics_route_observer.dart' as _i27;

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
  gh.factory<_i3.PlaythroughNoteViewModel>(
      () => _i3.PlaythroughNoteViewModel());
  gh.factory<_i4.HiveInterface>(() => registerModule.hive);
  gh.singleton<_i5.EnvironmentService>(() => _i5.EnvironmentService());
  gh.singleton<_i6.FileService>(() => _i6.FileService());
  gh.singleton<_i7.FirebaseAnalytics>(() => registerModule.firebaseAnalytics);
  gh.singleton<_i7.FirebaseAnalyticsObserver>(
      () => registerModule.firebaseAnalyticsObserver);
  gh.singleton<_i8.BoardGamesGeekService>(
      () => registerModule.boardGameGeekService);
  gh.singleton<_i9.AppStore>(() => _i9.AppStore());
  gh.singleton<_i10.BoardGamesService>(() => _i10.BoardGamesService(
        gh<_i4.HiveInterface>(),
        gh<_i8.BoardGamesGeekService>(),
      ));
  gh.singleton<_i11.BoardGamesFiltersService>(
      () => _i11.BoardGamesFiltersService(gh<_i4.HiveInterface>()));
  gh.singleton<_i12.PlayerService>(() => _i12.PlayerService(
        gh<_i4.HiveInterface>(),
        gh<_i6.FileService>(),
      ));
  gh.singleton<_i13.BoardGamesSearchService>(
      () => _i13.BoardGamesSearchService(gh<_i5.EnvironmentService>()));
  gh.singleton<_i14.PreferencesService>(
      () => _i14.PreferencesService(gh<_i4.HiveInterface>()));
  gh.singleton<_i15.ScoreService>(
      () => _i15.ScoreService(gh<_i4.HiveInterface>()));
  gh.singleton<_i16.SearchService>(
      () => _i16.SearchService(gh<_i4.HiveInterface>()));
  gh.singleton<_i17.UserService>(
      () => _i17.UserService(gh<_i4.HiveInterface>()));
  gh.singleton<_i18.RateAndReviewService>(
      () => _i18.RateAndReviewService(gh<_i14.PreferencesService>()));
  gh.singleton<_i19.AnalyticsService>(() => _i19.AnalyticsService(
        gh<_i7.FirebaseAnalytics>(),
        gh<_i18.RateAndReviewService>(),
      ));
  gh.singleton<_i20.PlayersStore>(
      () => _i20.PlayersStore(gh<_i12.PlayerService>()));
  gh.singleton<_i21.PlaythroughService>(() => _i21.PlaythroughService(
        gh<_i4.HiveInterface>(),
        gh<_i15.ScoreService>(),
      ));
  gh.singleton<_i22.BoardGamesFiltersStore>(() => _i22.BoardGamesFiltersStore(
        gh<_i11.BoardGamesFiltersService>(),
        gh<_i19.AnalyticsService>(),
      ));
  gh.singleton<_i23.UserStore>(() => _i23.UserStore(gh<_i17.UserService>()));
  gh.singleton<_i24.ScoresStore>(
      () => _i24.ScoresStore(gh<_i15.ScoreService>()));
  gh.singleton<_i25.SearchStore>(
      () => _i25.SearchStore(gh<_i16.SearchService>()));
  gh.singleton<_i26.PlaythroughsStore>(() => _i26.PlaythroughsStore(
        gh<_i21.PlaythroughService>(),
        gh<_i24.ScoresStore>(),
      ));
  gh.factory<_i27.AnalyticsRouteObserver>(
      () => _i27.AnalyticsRouteObserver(gh<_i19.AnalyticsService>()));
  gh.singleton<_i28.BoardGamesStore>(() => _i28.BoardGamesStore(
        gh<_i10.BoardGamesService>(),
        gh<_i21.PlaythroughService>(),
      ));
  gh.factory<_i29.PlaysViewModel>(() => _i29.PlaysViewModel(
        gh<_i26.PlaythroughsStore>(),
        gh<_i28.BoardGamesStore>(),
        gh<_i20.PlayersStore>(),
        gh<_i24.ScoresStore>(),
        gh<_i19.AnalyticsService>(),
      ));
  gh.factory<_i30.PlayerViewModel>(
      () => _i30.PlayerViewModel(gh<_i20.PlayersStore>()));
  gh.factory<_i31.PlayersViewModel>(
      () => _i31.PlayersViewModel(gh<_i20.PlayersStore>()));
  gh.factory<_i32.PlaythroughPlayersSelectionViewModel>(
      () => _i32.PlaythroughPlayersSelectionViewModel(gh<_i20.PlayersStore>()));
  gh.singleton<_i33.SettingsViewModel>(() => _i33.SettingsViewModel(
        gh<_i6.FileService>(),
        gh<_i10.BoardGamesService>(),
        gh<_i11.BoardGamesFiltersService>(),
        gh<_i12.PlayerService>(),
        gh<_i17.UserService>(),
        gh<_i21.PlaythroughService>(),
        gh<_i15.ScoreService>(),
        gh<_i14.PreferencesService>(),
        gh<_i9.AppStore>(),
        gh<_i23.UserStore>(),
        gh<_i28.BoardGamesStore>(),
      ));
  gh.singleton<_i34.GamePlaythroughsDetailsStore>(
      () => _i34.GamePlaythroughsDetailsStore(
            gh<_i26.PlaythroughsStore>(),
            gh<_i24.ScoresStore>(),
            gh<_i20.PlayersStore>(),
            gh<_i28.BoardGamesStore>(),
          ));
  gh.factory<_i35.PlaythroughsGameSettingsViewModel>(
      () => _i35.PlaythroughsGameSettingsViewModel(
            gh<_i28.BoardGamesStore>(),
            gh<_i34.GamePlaythroughsDetailsStore>(),
          ));
  gh.factory<_i36.BoardGameDetailsViewModel>(
      () => _i36.BoardGameDetailsViewModel(
            gh<_i28.BoardGamesStore>(),
            gh<_i19.AnalyticsService>(),
          ));
  gh.singleton<_i37.HotBoardGamesViewModel>(() => _i37.HotBoardGamesViewModel(
        gh<_i28.BoardGamesStore>(),
        gh<_i8.BoardGamesGeekService>(),
        gh<_i19.AnalyticsService>(),
      ));
  gh.factory<_i38.PlaythroughsLogGameViewModel>(
      () => _i38.PlaythroughsLogGameViewModel(
            gh<_i20.PlayersStore>(),
            gh<_i34.GamePlaythroughsDetailsStore>(),
            gh<_i19.AnalyticsService>(),
          ));
  gh.factory<_i39.PlaythroughsViewModel>(() => _i39.PlaythroughsViewModel(
        gh<_i34.GamePlaythroughsDetailsStore>(),
        gh<_i20.PlayersStore>(),
        gh<_i19.AnalyticsService>(),
        gh<_i10.BoardGamesService>(),
        gh<_i23.UserStore>(),
      ));
  gh.factory<_i40.CollectionSearchResultViewModel>(
      () => _i40.CollectionSearchResultViewModel(gh<_i28.BoardGamesStore>()));
  gh.factory<_i41.CreateBoardGameViewModel>(() => _i41.CreateBoardGameViewModel(
        gh<_i28.BoardGamesStore>(),
        gh<_i6.FileService>(),
      ));
  gh.factory<_i42.CollectionsViewModel>(() => _i42.CollectionsViewModel(
        gh<_i23.UserStore>(),
        gh<_i28.BoardGamesStore>(),
        gh<_i22.BoardGamesFiltersStore>(),
        gh<_i24.ScoresStore>(),
        gh<_i26.PlaythroughsStore>(),
        gh<_i20.PlayersStore>(),
      ));
  gh.factory<_i43.EditPlaythoughViewModel>(() =>
      _i43.EditPlaythoughViewModel(gh<_i34.GamePlaythroughsDetailsStore>()));
  gh.singleton<_i44.PlaythroughStatisticsViewModel>(
      () => _i44.PlaythroughStatisticsViewModel(
            gh<_i12.PlayerService>(),
            gh<_i24.ScoresStore>(),
            gh<_i34.GamePlaythroughsDetailsStore>(),
          ));
  gh.factory<_i45.HomeViewModel>(() => _i45.HomeViewModel(
        gh<_i19.AnalyticsService>(),
        gh<_i18.RateAndReviewService>(),
        gh<_i31.PlayersViewModel>(),
        gh<_i22.BoardGamesFiltersStore>(),
        gh<_i42.CollectionsViewModel>(),
        gh<_i37.HotBoardGamesViewModel>(),
        gh<_i29.PlaysViewModel>(),
        gh<_i9.AppStore>(),
        gh<_i25.SearchStore>(),
        gh<_i28.BoardGamesStore>(),
        gh<_i13.BoardGamesSearchService>(),
      ));
  gh.factory<_i46.PlaythroughsHistoryViewModel>(() =>
      _i46.PlaythroughsHistoryViewModel(
          gh<_i34.GamePlaythroughsDetailsStore>()));
  gh.factory<_i47.PlaythroughMigrationViewModel>(() =>
      _i47.PlaythroughMigrationViewModel(
          gh<_i34.GamePlaythroughsDetailsStore>()));
  return getIt;
}

class _$RegisterModule extends _i48.RegisterModule {}
