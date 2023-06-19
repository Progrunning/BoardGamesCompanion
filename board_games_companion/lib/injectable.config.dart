// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:board_games_companion/pages/board_game_details/board_game_details_view_model.dart'
    as _i45;
import 'package:board_games_companion/pages/collections/collection_search_result_view_model.dart'
    as _i32;
import 'package:board_games_companion/pages/collections/collections_view_model.dart'
    as _i33;
import 'package:board_games_companion/pages/create_board_game/create_board_game_view_model.dart'
    as _i34;
import 'package:board_games_companion/pages/edit_playthrough/edit_playthrough_view_model.dart'
    as _i46;
import 'package:board_games_companion/pages/edit_playthrough/playthrough_note_view_model.dart'
    as _i12;
import 'package:board_games_companion/pages/home/home_view_model.dart' as _i47;
import 'package:board_games_companion/pages/hot_board_games/hot_board_games_view_model.dart'
    as _i36;
import 'package:board_games_companion/pages/player/player_view_model.dart'
    as _i27;
import 'package:board_games_companion/pages/players/players_view_model.dart'
    as _i11;
import 'package:board_games_companion/pages/plays/plays_view_model.dart'
    as _i37;
import 'package:board_games_companion/pages/playthroughs/playthrough_migration_view_model.dart'
    as _i38;
import 'package:board_games_companion/pages/playthroughs/playthrough_players_selection_view_model.dart'
    as _i13;
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
import 'package:board_games_companion/services/analytics_service.dart' as _i22;
import 'package:board_games_companion/services/board_games_filters_service.dart'
    as _i4;
import 'package:board_games_companion/services/board_games_geek_service.dart'
    as _i24;
import 'package:board_games_companion/services/board_games_search_service.dart'
    as _i25;
import 'package:board_games_companion/services/board_games_service.dart'
    as _i26;
import 'package:board_games_companion/services/environment_service.dart' as _i6;
import 'package:board_games_companion/services/file_service.dart' as _i7;
import 'package:board_games_companion/services/player_service.dart' as _i9;
import 'package:board_games_companion/services/playthroughs_service.dart'
    as _i28;
import 'package:board_games_companion/services/preferences_service.dart'
    as _i14;
import 'package:board_games_companion/services/rate_and_review_service.dart'
    as _i15;
import 'package:board_games_companion/services/score_service.dart' as _i16;
import 'package:board_games_companion/services/search_service.dart' as _i18;
import 'package:board_games_companion/services/user_service.dart' as _i20;
import 'package:board_games_companion/stores/app_store.dart' as _i3;
import 'package:board_games_companion/stores/board_games_filters_store.dart'
    as _i23;
import 'package:board_games_companion/stores/board_games_store.dart' as _i31;
import 'package:board_games_companion/stores/game_playthroughs_details_store.dart'
    as _i35;
import 'package:board_games_companion/stores/players_store.dart' as _i10;
import 'package:board_games_companion/stores/playthroughs_store.dart' as _i29;
import 'package:board_games_companion/stores/scores_store.dart' as _i17;
import 'package:board_games_companion/stores/search_store.dart' as _i19;
import 'package:board_games_companion/stores/user_store.dart' as _i21;
import 'package:board_games_companion/utilities/analytics_route_observer.dart'
    as _i30;
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
  gh.factory<_i12.PlaythroughNoteViewModel>(
      () => _i12.PlaythroughNoteViewModel());
  gh.factory<_i13.PlaythroughPlayersSelectionViewModel>(
      () => _i13.PlaythroughPlayersSelectionViewModel(gh<_i10.PlayersStore>()));
  gh.singleton<_i14.PreferencesService>(_i14.PreferencesService());
  gh.singleton<_i15.RateAndReviewService>(
      _i15.RateAndReviewService(gh<_i14.PreferencesService>()));
  gh.singleton<_i16.ScoreService>(_i16.ScoreService());
  gh.singleton<_i17.ScoresStore>(_i17.ScoresStore(gh<_i16.ScoreService>()));
  gh.singleton<_i18.SearchService>(_i18.SearchService());
  gh.singleton<_i19.SearchStore>(_i19.SearchStore(gh<_i18.SearchService>()));
  gh.singleton<_i20.UserService>(_i20.UserService());
  gh.singleton<_i21.UserStore>(_i21.UserStore(gh<_i20.UserService>()));
  gh.singleton<_i22.AnalyticsService>(_i22.AnalyticsService(
    gh<_i8.FirebaseAnalytics>(),
    gh<_i15.RateAndReviewService>(),
  ));
  gh.singleton<_i23.BoardGamesFiltersStore>(_i23.BoardGamesFiltersStore(
    gh<_i4.BoardGamesFiltersService>(),
    gh<_i22.AnalyticsService>(),
  ));
  gh.singleton<_i24.BoardGamesGeekService>(
      _i24.BoardGamesGeekService(gh<_i5.CustomHttpClientAdapter>()));
  gh.singleton<_i25.BoardGamesSearchService>(
      _i25.BoardGamesSearchService(gh<_i6.EnvironmentService>()));
  gh.singleton<_i26.BoardGamesService>(
      _i26.BoardGamesService(gh<_i24.BoardGamesGeekService>()));
  gh.factory<_i27.PlayerViewModel>(
      () => _i27.PlayerViewModel(gh<_i10.PlayersStore>()));
  gh.singleton<_i28.PlaythroughService>(
      _i28.PlaythroughService(gh<_i16.ScoreService>()));
  gh.singleton<_i29.PlaythroughsStore>(_i29.PlaythroughsStore(
    gh<_i28.PlaythroughService>(),
    gh<_i17.ScoresStore>(),
  ));
  gh.factory<_i30.AnalyticsRouteObserver>(
      () => _i30.AnalyticsRouteObserver(gh<_i22.AnalyticsService>()));
  gh.singleton<_i31.BoardGamesStore>(_i31.BoardGamesStore(
    gh<_i26.BoardGamesService>(),
    gh<_i28.PlaythroughService>(),
  ));
  gh.factory<_i32.CollectionSearchResultViewModel>(
      () => _i32.CollectionSearchResultViewModel(gh<_i31.BoardGamesStore>()));
  gh.factory<_i33.CollectionsViewModel>(() => _i33.CollectionsViewModel(
        gh<_i21.UserStore>(),
        gh<_i31.BoardGamesStore>(),
        gh<_i23.BoardGamesFiltersStore>(),
        gh<_i17.ScoresStore>(),
        gh<_i29.PlaythroughsStore>(),
        gh<_i10.PlayersStore>(),
      ));
  gh.factory<_i34.CreateBoardGameViewModel>(() => _i34.CreateBoardGameViewModel(
        gh<_i31.BoardGamesStore>(),
        gh<_i7.FileService>(),
      ));
  gh.singleton<_i35.GamePlaythroughsDetailsStore>(
      _i35.GamePlaythroughsDetailsStore(
    gh<_i29.PlaythroughsStore>(),
    gh<_i17.ScoresStore>(),
    gh<_i10.PlayersStore>(),
    gh<_i31.BoardGamesStore>(),
  ));
  gh.singleton<_i36.HotBoardGamesViewModel>(_i36.HotBoardGamesViewModel(
    gh<_i31.BoardGamesStore>(),
    gh<_i24.BoardGamesGeekService>(),
    gh<_i22.AnalyticsService>(),
  ));
  gh.factory<_i37.PlaysViewModel>(() => _i37.PlaysViewModel(
        gh<_i29.PlaythroughsStore>(),
        gh<_i31.BoardGamesStore>(),
        gh<_i10.PlayersStore>(),
        gh<_i17.ScoresStore>(),
        gh<_i22.AnalyticsService>(),
      ));
  gh.factory<_i38.PlaythroughMigrationViewModel>(() =>
      _i38.PlaythroughMigrationViewModel(
          gh<_i35.GamePlaythroughsDetailsStore>()));
  gh.singleton<_i39.PlaythroughStatisticsViewModel>(
      _i39.PlaythroughStatisticsViewModel(
    gh<_i9.PlayerService>(),
    gh<_i17.ScoresStore>(),
    gh<_i35.GamePlaythroughsDetailsStore>(),
  ));
  gh.factory<_i40.PlaythroughsGameSettingsViewModel>(
      () => _i40.PlaythroughsGameSettingsViewModel(
            gh<_i31.BoardGamesStore>(),
            gh<_i35.GamePlaythroughsDetailsStore>(),
          ));
  gh.factory<_i41.PlaythroughsHistoryViewModel>(() =>
      _i41.PlaythroughsHistoryViewModel(
          gh<_i35.GamePlaythroughsDetailsStore>()));
  gh.factory<_i42.PlaythroughsLogGameViewModel>(
      () => _i42.PlaythroughsLogGameViewModel(
            gh<_i10.PlayersStore>(),
            gh<_i35.GamePlaythroughsDetailsStore>(),
            gh<_i22.AnalyticsService>(),
          ));
  gh.factory<_i43.PlaythroughsViewModel>(() => _i43.PlaythroughsViewModel(
        gh<_i35.GamePlaythroughsDetailsStore>(),
        gh<_i10.PlayersStore>(),
        gh<_i22.AnalyticsService>(),
        gh<_i26.BoardGamesService>(),
        gh<_i21.UserStore>(),
      ));
  gh.singleton<_i44.SettingsViewModel>(_i44.SettingsViewModel(
    gh<_i7.FileService>(),
    gh<_i26.BoardGamesService>(),
    gh<_i4.BoardGamesFiltersService>(),
    gh<_i9.PlayerService>(),
    gh<_i20.UserService>(),
    gh<_i28.PlaythroughService>(),
    gh<_i16.ScoreService>(),
    gh<_i14.PreferencesService>(),
    gh<_i3.AppStore>(),
    gh<_i21.UserStore>(),
    gh<_i31.BoardGamesStore>(),
  ));
  gh.factory<_i45.BoardGameDetailsViewModel>(
      () => _i45.BoardGameDetailsViewModel(
            gh<_i31.BoardGamesStore>(),
            gh<_i22.AnalyticsService>(),
          ));
  gh.factory<_i46.EditPlaythoughViewModel>(() =>
      _i46.EditPlaythoughViewModel(gh<_i35.GamePlaythroughsDetailsStore>()));
  gh.factory<_i47.HomeViewModel>(() => _i47.HomeViewModel(
        gh<_i22.AnalyticsService>(),
        gh<_i15.RateAndReviewService>(),
        gh<_i11.PlayersViewModel>(),
        gh<_i23.BoardGamesFiltersStore>(),
        gh<_i33.CollectionsViewModel>(),
        gh<_i36.HotBoardGamesViewModel>(),
        gh<_i37.PlaysViewModel>(),
        gh<_i3.AppStore>(),
        gh<_i19.SearchStore>(),
        gh<_i31.BoardGamesStore>(),
        gh<_i25.BoardGamesSearchService>(),
      ));
  return getIt;
}

class _$RegisterModule extends _i48.RegisterModule {}
