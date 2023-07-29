// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:board_games_companion/pages/board_game_details/board_game_details_view_model.dart'
    as _i46;
import 'package:board_games_companion/pages/collections/collection_search_result_view_model.dart'
    as _i33;
import 'package:board_games_companion/pages/collections/collections_view_model.dart'
    as _i34;
import 'package:board_games_companion/pages/create_board_game/create_board_game_view_model.dart'
    as _i35;
import 'package:board_games_companion/pages/edit_playthrough/edit_playthrough_view_model.dart'
    as _i47;
import 'package:board_games_companion/pages/edit_playthrough/playthrough_note_view_model.dart'
    as _i12;
import 'package:board_games_companion/pages/home/home_view_model.dart' as _i48;
import 'package:board_games_companion/pages/hot_board_games/hot_board_games_view_model.dart'
    as _i37;
import 'package:board_games_companion/pages/player/player_view_model.dart'
    as _i28;
import 'package:board_games_companion/pages/players/players_view_model.dart'
    as _i11;
import 'package:board_games_companion/pages/plays/plays_view_model.dart'
    as _i38;
import 'package:board_games_companion/pages/playthroughs/playthrough_migration_view_model.dart'
    as _i39;
import 'package:board_games_companion/pages/playthroughs/playthrough_players_selection_view_model.dart'
    as _i13;
import 'package:board_games_companion/pages/playthroughs/playthrough_statistics_view_model.dart'
    as _i40;
import 'package:board_games_companion/pages/playthroughs/playthroughs_game_settings_view_model.dart'
    as _i41;
import 'package:board_games_companion/pages/playthroughs/playthroughs_history_view_model.dart'
    as _i42;
import 'package:board_games_companion/pages/playthroughs/playthroughs_log_game_view_model.dart'
    as _i43;
import 'package:board_games_companion/pages/playthroughs/playthroughs_view_model.dart'
    as _i44;
import 'package:board_games_companion/pages/settings/settings_view_model.dart'
    as _i45;
import 'package:board_games_companion/services/analytics_service.dart' as _i22;
import 'package:board_games_companion/services/board_games_filters_service.dart'
    as _i23;
import 'package:board_games_companion/services/board_games_geek_service.dart'
    as _i25;
import 'package:board_games_companion/services/board_games_search_service.dart'
    as _i26;
import 'package:board_games_companion/services/board_games_service.dart'
    as _i27;
import 'package:board_games_companion/services/environment_service.dart' as _i5;
import 'package:board_games_companion/services/file_service.dart' as _i6;
import 'package:board_games_companion/services/player_service.dart' as _i9;
import 'package:board_games_companion/services/playthroughs_service.dart'
    as _i29;
import 'package:board_games_companion/services/preferences_service.dart'
    as _i14;
import 'package:board_games_companion/services/rate_and_review_service.dart'
    as _i15;
import 'package:board_games_companion/services/score_service.dart' as _i16;
import 'package:board_games_companion/services/search_service.dart' as _i18;
import 'package:board_games_companion/services/user_service.dart' as _i20;
import 'package:board_games_companion/stores/app_store.dart' as _i3;
import 'package:board_games_companion/stores/board_games_filters_store.dart'
    as _i24;
import 'package:board_games_companion/stores/board_games_store.dart' as _i32;
import 'package:board_games_companion/stores/game_playthroughs_details_store.dart'
    as _i36;
import 'package:board_games_companion/stores/players_store.dart' as _i10;
import 'package:board_games_companion/stores/playthroughs_store.dart' as _i30;
import 'package:board_games_companion/stores/scores_store.dart' as _i17;
import 'package:board_games_companion/stores/search_store.dart' as _i19;
import 'package:board_games_companion/stores/user_store.dart' as _i21;
import 'package:board_games_companion/utilities/analytics_route_observer.dart'
    as _i31;
import 'package:board_games_companion/utilities/custom_http_client_adapter.dart'
    as _i4;
import 'package:firebase_analytics/firebase_analytics.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:hive/hive.dart' as _i8;
import 'package:injectable/injectable.dart' as _i2;

import 'services/injectable_register_module.dart' as _i49;

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
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
  gh.factory<_i4.CustomHttpClientAdapter>(() => _i4.CustomHttpClientAdapter());
  gh.singleton<_i5.EnvironmentService>(_i5.EnvironmentService());
  gh.singleton<_i6.FileService>(_i6.FileService());
  gh.singleton<_i7.FirebaseAnalytics>(registerModule.firebaseAnalytics);
  gh.singleton<_i7.FirebaseAnalyticsObserver>(
      registerModule.firebaseAnalyticsObserver);
  gh.factory<_i8.HiveInterface>(() => registerModule.hive);
  gh.singleton<_i9.PlayerService>(_i9.PlayerService(
    gh<_i8.HiveInterface>(),
    gh<_i6.FileService>(),
  ));
  gh.singleton<_i10.PlayersStore>(_i10.PlayersStore(gh<_i9.PlayerService>()));
  gh.factory<_i11.PlayersViewModel>(
      () => _i11.PlayersViewModel(gh<_i10.PlayersStore>()));
  gh.factory<_i12.PlaythroughNoteViewModel>(
      () => _i12.PlaythroughNoteViewModel());
  gh.factory<_i13.PlaythroughPlayersSelectionViewModel>(
      () => _i13.PlaythroughPlayersSelectionViewModel(gh<_i10.PlayersStore>()));
  gh.singleton<_i14.PreferencesService>(
      _i14.PreferencesService(gh<_i8.HiveInterface>()));
  gh.singleton<_i15.RateAndReviewService>(
      _i15.RateAndReviewService(gh<_i14.PreferencesService>()));
  gh.singleton<_i16.ScoreService>(_i16.ScoreService(gh<_i8.HiveInterface>()));
  gh.singleton<_i17.ScoresStore>(_i17.ScoresStore(gh<_i16.ScoreService>()));
  gh.singleton<_i18.SearchService>(_i18.SearchService(gh<_i8.HiveInterface>()));
  gh.singleton<_i19.SearchStore>(_i19.SearchStore(gh<_i18.SearchService>()));
  gh.singleton<_i20.UserService>(_i20.UserService(gh<_i8.HiveInterface>()));
  gh.singleton<_i21.UserStore>(_i21.UserStore(gh<_i20.UserService>()));
  gh.singleton<_i22.AnalyticsService>(_i22.AnalyticsService(
    gh<_i7.FirebaseAnalytics>(),
    gh<_i15.RateAndReviewService>(),
  ));
  gh.singleton<_i23.BoardGamesFiltersService>(
      _i23.BoardGamesFiltersService(gh<_i8.HiveInterface>()));
  gh.singleton<_i24.BoardGamesFiltersStore>(_i24.BoardGamesFiltersStore(
    gh<_i23.BoardGamesFiltersService>(),
    gh<_i22.AnalyticsService>(),
  ));
  gh.singleton<_i25.BoardGamesGeekService>(
      _i25.BoardGamesGeekService(gh<_i4.CustomHttpClientAdapter>()));
  gh.singleton<_i26.BoardGamesSearchService>(
      _i26.BoardGamesSearchService(gh<_i5.EnvironmentService>()));
  gh.singleton<_i27.BoardGamesService>(_i27.BoardGamesService(
    gh<_i8.HiveInterface>(),
    gh<_i25.BoardGamesGeekService>(),
  ));
  gh.factory<_i28.PlayerViewModel>(
      () => _i28.PlayerViewModel(gh<_i10.PlayersStore>()));
  gh.singleton<_i29.PlaythroughService>(_i29.PlaythroughService(
    gh<_i8.HiveInterface>(),
    gh<_i16.ScoreService>(),
  ));
  gh.singleton<_i30.PlaythroughsStore>(_i30.PlaythroughsStore(
    gh<_i29.PlaythroughService>(),
    gh<_i17.ScoresStore>(),
  ));
  gh.factory<_i31.AnalyticsRouteObserver>(
      () => _i31.AnalyticsRouteObserver(gh<_i22.AnalyticsService>()));
  gh.singleton<_i32.BoardGamesStore>(_i32.BoardGamesStore(
    gh<_i27.BoardGamesService>(),
    gh<_i29.PlaythroughService>(),
  ));
  gh.factory<_i33.CollectionSearchResultViewModel>(
      () => _i33.CollectionSearchResultViewModel(gh<_i32.BoardGamesStore>()));
  gh.factory<_i34.CollectionsViewModel>(() => _i34.CollectionsViewModel(
        gh<_i21.UserStore>(),
        gh<_i32.BoardGamesStore>(),
        gh<_i24.BoardGamesFiltersStore>(),
        gh<_i17.ScoresStore>(),
        gh<_i30.PlaythroughsStore>(),
        gh<_i10.PlayersStore>(),
      ));
  gh.factory<_i35.CreateBoardGameViewModel>(() => _i35.CreateBoardGameViewModel(
        gh<_i32.BoardGamesStore>(),
        gh<_i6.FileService>(),
      ));
  gh.singleton<_i36.GamePlaythroughsDetailsStore>(
      _i36.GamePlaythroughsDetailsStore(
    gh<_i30.PlaythroughsStore>(),
    gh<_i17.ScoresStore>(),
    gh<_i10.PlayersStore>(),
    gh<_i32.BoardGamesStore>(),
  ));
  gh.singleton<_i37.HotBoardGamesViewModel>(_i37.HotBoardGamesViewModel(
    gh<_i32.BoardGamesStore>(),
    gh<_i25.BoardGamesGeekService>(),
    gh<_i22.AnalyticsService>(),
  ));
  gh.factory<_i38.PlaysViewModel>(() => _i38.PlaysViewModel(
        gh<_i30.PlaythroughsStore>(),
        gh<_i32.BoardGamesStore>(),
        gh<_i10.PlayersStore>(),
        gh<_i17.ScoresStore>(),
        gh<_i22.AnalyticsService>(),
      ));
  gh.factory<_i39.PlaythroughMigrationViewModel>(() =>
      _i39.PlaythroughMigrationViewModel(
          gh<_i36.GamePlaythroughsDetailsStore>()));
  gh.singleton<_i40.PlaythroughStatisticsViewModel>(
      _i40.PlaythroughStatisticsViewModel(
    gh<_i9.PlayerService>(),
    gh<_i17.ScoresStore>(),
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
            gh<_i10.PlayersStore>(),
            gh<_i36.GamePlaythroughsDetailsStore>(),
            gh<_i22.AnalyticsService>(),
          ));
  gh.factory<_i44.PlaythroughsViewModel>(() => _i44.PlaythroughsViewModel(
        gh<_i36.GamePlaythroughsDetailsStore>(),
        gh<_i10.PlayersStore>(),
        gh<_i22.AnalyticsService>(),
        gh<_i27.BoardGamesService>(),
        gh<_i21.UserStore>(),
      ));
  gh.singleton<_i45.SettingsViewModel>(_i45.SettingsViewModel(
    gh<_i6.FileService>(),
    gh<_i27.BoardGamesService>(),
    gh<_i23.BoardGamesFiltersService>(),
    gh<_i9.PlayerService>(),
    gh<_i20.UserService>(),
    gh<_i29.PlaythroughService>(),
    gh<_i16.ScoreService>(),
    gh<_i14.PreferencesService>(),
    gh<_i3.AppStore>(),
    gh<_i21.UserStore>(),
    gh<_i32.BoardGamesStore>(),
  ));
  gh.factory<_i46.BoardGameDetailsViewModel>(
      () => _i46.BoardGameDetailsViewModel(
            gh<_i32.BoardGamesStore>(),
            gh<_i22.AnalyticsService>(),
          ));
  gh.factory<_i47.EditPlaythoughViewModel>(() =>
      _i47.EditPlaythoughViewModel(gh<_i36.GamePlaythroughsDetailsStore>()));
  gh.factory<_i48.HomeViewModel>(() => _i48.HomeViewModel(
        gh<_i22.AnalyticsService>(),
        gh<_i15.RateAndReviewService>(),
        gh<_i11.PlayersViewModel>(),
        gh<_i24.BoardGamesFiltersStore>(),
        gh<_i34.CollectionsViewModel>(),
        gh<_i37.HotBoardGamesViewModel>(),
        gh<_i38.PlaysViewModel>(),
        gh<_i3.AppStore>(),
        gh<_i19.SearchStore>(),
        gh<_i32.BoardGamesStore>(),
        gh<_i26.BoardGamesSearchService>(),
      ));
  return getIt;
}

class _$RegisterModule extends _i49.RegisterModule {}
