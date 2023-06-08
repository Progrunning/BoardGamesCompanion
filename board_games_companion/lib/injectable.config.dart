// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:board_games_companion/pages/board_game_details/board_game_details_view_model.dart'
    as _i45;
import 'package:board_games_companion/pages/collections/collection_search_result_view_model.dart'
    as _i31;
import 'package:board_games_companion/pages/collections/collections_view_model.dart'
    as _i32;
import 'package:board_games_companion/pages/create_board_game/create_board_game_view_model.dart'
    as _i33;
import 'package:board_games_companion/pages/edit_playthrough/edit_playthrough_view_model.dart'
    as _i46;
import 'package:board_games_companion/pages/edit_playthrough/playthrough_note_view_model.dart'
    as _i38;
import 'package:board_games_companion/pages/home/home_view_model.dart' as _i47;
import 'package:board_games_companion/pages/hot_board_games/hot_board_games_view_model.dart'
    as _i35;
import 'package:board_games_companion/pages/player/player_view_model.dart'
    as _i26;
import 'package:board_games_companion/pages/players/players_view_model.dart'
    as _i11;
import 'package:board_games_companion/pages/plays/plays_view_model.dart'
    as _i36;
import 'package:board_games_companion/pages/playthroughs/playthrough_migration_view_model.dart'
    as _i37;
import 'package:board_games_companion/pages/playthroughs/playthrough_players_selection_view_model.dart'
    as _i12;
import 'package:board_games_companion/pages/playthroughs/playthrough_statistics_view_model.dart'
    as _i39;
import 'package:board_games_companion/pages/playthroughs/playthroughs_game_settings_view_model.dart'
    as _i40;
import 'package:board_games_companion/pages/playthroughs/playthroughs_history_view_model.dart'
    as _i41;
import 'package:board_games_companion/pages/playthroughs/playthroughs_log_game_view_model.dart'
    as _i42;
import 'package:board_games_companion/pages/playthroughs/playthroughs_view_model.dart'
    as _i43;
import 'package:board_games_companion/pages/settings/settings_view_model.dart'
    as _i44;
import 'package:board_games_companion/services/analytics_service.dart' as _i21;
import 'package:board_games_companion/services/board_games_filters_service.dart'
    as _i4;
import 'package:board_games_companion/services/board_games_geek_service.dart'
    as _i23;
import 'package:board_games_companion/services/board_games_search_service.dart'
    as _i24;
import 'package:board_games_companion/services/board_games_service.dart'
    as _i25;
import 'package:board_games_companion/services/environment_service.dart' as _i6;
import 'package:board_games_companion/services/file_service.dart' as _i7;
import 'package:board_games_companion/services/player_service.dart' as _i9;
import 'package:board_games_companion/services/playthroughs_service.dart'
    as _i27;
import 'package:board_games_companion/services/preferences_service.dart'
    as _i13;
import 'package:board_games_companion/services/rate_and_review_service.dart'
    as _i14;
import 'package:board_games_companion/services/score_service.dart' as _i15;
import 'package:board_games_companion/services/search_service.dart' as _i17;
import 'package:board_games_companion/services/user_service.dart' as _i19;
import 'package:board_games_companion/stores/app_store.dart' as _i3;
import 'package:board_games_companion/stores/board_games_filters_store.dart'
    as _i22;
import 'package:board_games_companion/stores/board_games_store.dart' as _i30;
import 'package:board_games_companion/stores/game_playthroughs_details_store.dart'
    as _i34;
import 'package:board_games_companion/stores/players_store.dart' as _i10;
import 'package:board_games_companion/stores/playthroughs_store.dart' as _i28;
import 'package:board_games_companion/stores/scores_store.dart' as _i16;
import 'package:board_games_companion/stores/search_store.dart' as _i18;
import 'package:board_games_companion/stores/user_store.dart' as _i20;
import 'package:board_games_companion/utilities/analytics_route_observer.dart'
    as _i29;
import 'package:board_games_companion/utilities/custom_http_client_adapter.dart'
    as _i5;
import 'package:firebase_analytics/firebase_analytics.dart' as _i8;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'services/injectable_register_module.dart' as _i48;

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
  gh.singleton<_i4.BoardGamesFiltersService>(_i4.BoardGamesFiltersService());
  gh.factory<_i5.CustomHttpClientAdapter>(() => _i5.CustomHttpClientAdapter());
  gh.singleton<_i6.EnvironmentService>(_i6.EnvironmentService());
  gh.singleton<_i7.FileService>(_i7.FileService());
  gh.singleton<_i8.FirebaseAnalytics>(registerModule.firebaseAnalytics);
  gh.singleton<_i8.FirebaseAnalyticsObserver>(
      registerModule.firebaseAnalyticsObserver);
  gh.singleton<_i9.PlayerService>(_i9.PlayerService(gh<_i7.FileService>()));
  gh.singleton<_i10.PlayersStore>(_i10.PlayersStore(gh<_i9.PlayerService>()));
  gh.factory<_i11.PlayersViewModel>(
      () => _i11.PlayersViewModel(gh<_i10.PlayersStore>()));
  gh.factory<_i12.PlaythroughPlayersSelectionViewModel>(
      () => _i12.PlaythroughPlayersSelectionViewModel(gh<_i10.PlayersStore>()));
  gh.singleton<_i13.PreferencesService>(_i13.PreferencesService());
  gh.singleton<_i14.RateAndReviewService>(
      _i14.RateAndReviewService(gh<_i13.PreferencesService>()));
  gh.singleton<_i15.ScoreService>(_i15.ScoreService());
  gh.singleton<_i16.ScoresStore>(_i16.ScoresStore(gh<_i15.ScoreService>()));
  gh.singleton<_i17.SearchService>(_i17.SearchService());
  gh.singleton<_i18.SearchStore>(_i18.SearchStore(gh<_i17.SearchService>()));
  gh.singleton<_i19.UserService>(_i19.UserService());
  gh.singleton<_i20.UserStore>(_i20.UserStore(gh<_i19.UserService>()));
  gh.singleton<_i21.AnalyticsService>(_i21.AnalyticsService(
    gh<_i8.FirebaseAnalytics>(),
    gh<_i14.RateAndReviewService>(),
  ));
  gh.singleton<_i22.BoardGamesFiltersStore>(_i22.BoardGamesFiltersStore(
    gh<_i4.BoardGamesFiltersService>(),
    gh<_i21.AnalyticsService>(),
  ));
  gh.singleton<_i23.BoardGamesGeekService>(
      _i23.BoardGamesGeekService(gh<_i5.CustomHttpClientAdapter>()));
  gh.singleton<_i24.BoardGamesSearchService>(
      _i24.BoardGamesSearchService(gh<_i6.EnvironmentService>()));
  gh.singleton<_i25.BoardGamesService>(
      _i25.BoardGamesService(gh<_i23.BoardGamesGeekService>()));
  gh.factory<_i26.PlayerViewModel>(
      () => _i26.PlayerViewModel(gh<_i10.PlayersStore>()));
  gh.singleton<_i27.PlaythroughService>(
      _i27.PlaythroughService(gh<_i15.ScoreService>()));
  gh.singleton<_i28.PlaythroughsStore>(_i28.PlaythroughsStore(
    gh<_i27.PlaythroughService>(),
    gh<_i16.ScoresStore>(),
  ));
  gh.factory<_i29.AnalyticsRouteObserver>(
      () => _i29.AnalyticsRouteObserver(gh<_i21.AnalyticsService>()));
  gh.singleton<_i30.BoardGamesStore>(_i30.BoardGamesStore(
    gh<_i25.BoardGamesService>(),
    gh<_i27.PlaythroughService>(),
  ));
  gh.factory<_i31.CollectionSearchResultViewModel>(
      () => _i31.CollectionSearchResultViewModel(gh<_i30.BoardGamesStore>()));
  gh.factory<_i32.CollectionsViewModel>(() => _i32.CollectionsViewModel(
        gh<_i20.UserStore>(),
        gh<_i30.BoardGamesStore>(),
        gh<_i22.BoardGamesFiltersStore>(),
        gh<_i16.ScoresStore>(),
        gh<_i28.PlaythroughsStore>(),
        gh<_i10.PlayersStore>(),
      ));
  gh.factory<_i33.CreateBoardGameViewModel>(() => _i33.CreateBoardGameViewModel(
        gh<_i30.BoardGamesStore>(),
        gh<_i7.FileService>(),
      ));
  gh.singleton<_i34.GamePlaythroughsDetailsStore>(
      _i34.GamePlaythroughsDetailsStore(
    gh<_i28.PlaythroughsStore>(),
    gh<_i16.ScoresStore>(),
    gh<_i10.PlayersStore>(),
    gh<_i30.BoardGamesStore>(),
  ));
  gh.singleton<_i35.HotBoardGamesViewModel>(_i35.HotBoardGamesViewModel(
    gh<_i30.BoardGamesStore>(),
    gh<_i23.BoardGamesGeekService>(),
    gh<_i21.AnalyticsService>(),
  ));
  gh.factory<_i36.PlaysViewModel>(() => _i36.PlaysViewModel(
        gh<_i28.PlaythroughsStore>(),
        gh<_i30.BoardGamesStore>(),
        gh<_i10.PlayersStore>(),
        gh<_i16.ScoresStore>(),
        gh<_i21.AnalyticsService>(),
      ));
  gh.factory<_i37.PlaythroughMigrationViewModel>(() =>
      _i37.PlaythroughMigrationViewModel(
          gh<_i34.GamePlaythroughsDetailsStore>()));
  gh.factory<_i38.PlaythroughNoteViewModel>(() =>
      _i38.PlaythroughNoteViewModel(gh<_i34.GamePlaythroughsDetailsStore>()));
  gh.singleton<_i39.PlaythroughStatisticsViewModel>(
      _i39.PlaythroughStatisticsViewModel(
    gh<_i9.PlayerService>(),
    gh<_i16.ScoresStore>(),
    gh<_i34.GamePlaythroughsDetailsStore>(),
  ));
  gh.factory<_i40.PlaythroughsGameSettingsViewModel>(
      () => _i40.PlaythroughsGameSettingsViewModel(
            gh<_i30.BoardGamesStore>(),
            gh<_i34.GamePlaythroughsDetailsStore>(),
          ));
  gh.factory<_i41.PlaythroughsHistoryViewModel>(() =>
      _i41.PlaythroughsHistoryViewModel(
          gh<_i34.GamePlaythroughsDetailsStore>()));
  gh.factory<_i42.PlaythroughsLogGameViewModel>(
      () => _i42.PlaythroughsLogGameViewModel(
            gh<_i10.PlayersStore>(),
            gh<_i34.GamePlaythroughsDetailsStore>(),
            gh<_i21.AnalyticsService>(),
          ));
  gh.factory<_i43.PlaythroughsViewModel>(() => _i43.PlaythroughsViewModel(
        gh<_i34.GamePlaythroughsDetailsStore>(),
        gh<_i10.PlayersStore>(),
        gh<_i21.AnalyticsService>(),
        gh<_i25.BoardGamesService>(),
        gh<_i20.UserStore>(),
      ));
  gh.singleton<_i44.SettingsViewModel>(_i44.SettingsViewModel(
    gh<_i7.FileService>(),
    gh<_i25.BoardGamesService>(),
    gh<_i4.BoardGamesFiltersService>(),
    gh<_i9.PlayerService>(),
    gh<_i19.UserService>(),
    gh<_i27.PlaythroughService>(),
    gh<_i15.ScoreService>(),
    gh<_i13.PreferencesService>(),
    gh<_i3.AppStore>(),
    gh<_i20.UserStore>(),
    gh<_i30.BoardGamesStore>(),
  ));
  gh.factory<_i45.BoardGameDetailsViewModel>(
      () => _i45.BoardGameDetailsViewModel(
            gh<_i30.BoardGamesStore>(),
            gh<_i21.AnalyticsService>(),
          ));
  gh.factory<_i46.EditPlaythoughViewModel>(() =>
      _i46.EditPlaythoughViewModel(gh<_i34.GamePlaythroughsDetailsStore>()));
  gh.factory<_i47.HomeViewModel>(() => _i47.HomeViewModel(
        gh<_i21.AnalyticsService>(),
        gh<_i14.RateAndReviewService>(),
        gh<_i11.PlayersViewModel>(),
        gh<_i22.BoardGamesFiltersStore>(),
        gh<_i32.CollectionsViewModel>(),
        gh<_i35.HotBoardGamesViewModel>(),
        gh<_i36.PlaysViewModel>(),
        gh<_i3.AppStore>(),
        gh<_i18.SearchStore>(),
        gh<_i30.BoardGamesStore>(),
        gh<_i24.BoardGamesSearchService>(),
      ));
  return getIt;
}

class _$RegisterModule extends _i48.RegisterModule {}
