// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:board_games_companion/pages/board_game_details/board_game_details_view_model.dart'
    as _i43;
import 'package:board_games_companion/pages/collections/collection_search_result_view_model.dart'
    as _i29;
import 'package:board_games_companion/pages/collections/collections_view_model.dart'
    as _i30;
import 'package:board_games_companion/pages/create_board_game/create_board_game_view_model.dart'
    as _i31;
import 'package:board_games_companion/pages/edit_playthrough/edit_playthrough_view_model.dart'
    as _i44;
import 'package:board_games_companion/pages/edit_playthrough/playthrough_note_view_model.dart'
    as _i36;
import 'package:board_games_companion/pages/home/home_view_model.dart' as _i45;
import 'package:board_games_companion/pages/hot_board_games/hot_board_games_view_model.dart'
    as _i33;
import 'package:board_games_companion/pages/player/player_view_model.dart'
    as _i24;
import 'package:board_games_companion/pages/players/players_view_model.dart'
    as _i10;
import 'package:board_games_companion/pages/plays/plays_view_model.dart'
    as _i34;
import 'package:board_games_companion/pages/playthroughs/playthrough_migration_view_model.dart'
    as _i35;
import 'package:board_games_companion/pages/playthroughs/playthrough_players_selection_view_model.dart'
    as _i11;
import 'package:board_games_companion/pages/playthroughs/playthrough_statistics_view_model.dart'
    as _i37;
import 'package:board_games_companion/pages/playthroughs/playthroughs_game_settings_view_model.dart'
    as _i38;
import 'package:board_games_companion/pages/playthroughs/playthroughs_history_view_model.dart'
    as _i39;
import 'package:board_games_companion/pages/playthroughs/playthroughs_log_game_view_model.dart'
    as _i40;
import 'package:board_games_companion/pages/playthroughs/playthroughs_view_model.dart'
    as _i41;
import 'package:board_games_companion/pages/settings/settings_view_model.dart'
    as _i42;
import 'package:board_games_companion/services/analytics_service.dart' as _i20;
import 'package:board_games_companion/services/board_games_filters_service.dart'
    as _i4;
import 'package:board_games_companion/services/board_games_geek_service.dart'
    as _i22;
import 'package:board_games_companion/services/board_games_service.dart'
    as _i23;
import 'package:board_games_companion/services/file_service.dart' as _i6;
import 'package:board_games_companion/services/player_service.dart' as _i8;
import 'package:board_games_companion/services/playthroughs_service.dart'
    as _i25;
import 'package:board_games_companion/services/preferences_service.dart'
    as _i12;
import 'package:board_games_companion/services/rate_and_review_service.dart'
    as _i13;
import 'package:board_games_companion/services/score_service.dart' as _i14;
import 'package:board_games_companion/services/search_service.dart' as _i16;
import 'package:board_games_companion/services/user_service.dart' as _i18;
import 'package:board_games_companion/stores/app_store.dart' as _i3;
import 'package:board_games_companion/stores/board_games_filters_store.dart'
    as _i21;
import 'package:board_games_companion/stores/board_games_store.dart' as _i28;
import 'package:board_games_companion/stores/game_playthroughs_details_store.dart'
    as _i32;
import 'package:board_games_companion/stores/players_store.dart' as _i9;
import 'package:board_games_companion/stores/playthroughs_store.dart' as _i26;
import 'package:board_games_companion/stores/scores_store.dart' as _i15;
import 'package:board_games_companion/stores/search_store.dart' as _i17;
import 'package:board_games_companion/stores/user_store.dart' as _i19;
import 'package:board_games_companion/utilities/analytics_route_observer.dart'
    as _i27;
import 'package:board_games_companion/utilities/custom_http_client_adapter.dart'
    as _i5;
import 'package:firebase_analytics/firebase_analytics.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'services/injectable_register_module.dart' as _i46;

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
  gh.singleton<_i6.FileService>(_i6.FileService());
  gh.singleton<_i7.FirebaseAnalytics>(registerModule.firebaseAnalytics);
  gh.singleton<_i7.FirebaseAnalyticsObserver>(
      registerModule.firebaseAnalyticsObserver);
  gh.singleton<_i8.PlayerService>(_i8.PlayerService(gh<_i6.FileService>()));
  gh.singleton<_i9.PlayersStore>(_i9.PlayersStore(gh<_i8.PlayerService>()));
  gh.factory<_i10.PlayersViewModel>(
      () => _i10.PlayersViewModel(gh<_i9.PlayersStore>()));
  gh.factory<_i11.PlaythroughPlayersSelectionViewModel>(
      () => _i11.PlaythroughPlayersSelectionViewModel(gh<_i9.PlayersStore>()));
  gh.singleton<_i12.PreferencesService>(_i12.PreferencesService());
  gh.singleton<_i13.RateAndReviewService>(
      _i13.RateAndReviewService(gh<_i12.PreferencesService>()));
  gh.singleton<_i14.ScoreService>(_i14.ScoreService());
  gh.singleton<_i15.ScoresStore>(_i15.ScoresStore(gh<_i14.ScoreService>()));
  gh.singleton<_i16.SearchService>(_i16.SearchService());
  gh.singleton<_i17.SearchStore>(_i17.SearchStore(gh<_i16.SearchService>()));
  gh.singleton<_i18.UserService>(_i18.UserService());
  gh.singleton<_i19.UserStore>(_i19.UserStore(gh<_i18.UserService>()));
  gh.singleton<_i20.AnalyticsService>(_i20.AnalyticsService(
    gh<_i7.FirebaseAnalytics>(),
    gh<_i13.RateAndReviewService>(),
  ));
  gh.singleton<_i21.BoardGamesFiltersStore>(_i21.BoardGamesFiltersStore(
    gh<_i4.BoardGamesFiltersService>(),
    gh<_i20.AnalyticsService>(),
  ));
  gh.singleton<_i22.BoardGamesGeekService>(
      _i22.BoardGamesGeekService(gh<_i5.CustomHttpClientAdapter>()));
  gh.singleton<_i23.BoardGamesService>(
      _i23.BoardGamesService(gh<_i22.BoardGamesGeekService>()));
  gh.factory<_i24.PlayerViewModel>(
      () => _i24.PlayerViewModel(gh<_i9.PlayersStore>()));
  gh.singleton<_i25.PlaythroughService>(
      _i25.PlaythroughService(gh<_i14.ScoreService>()));
  gh.singleton<_i26.PlaythroughsStore>(_i26.PlaythroughsStore(
    gh<_i25.PlaythroughService>(),
    gh<_i15.ScoresStore>(),
  ));
  gh.factory<_i27.AnalyticsRouteObserver>(
      () => _i27.AnalyticsRouteObserver(gh<_i20.AnalyticsService>()));
  gh.singleton<_i28.BoardGamesStore>(_i28.BoardGamesStore(
    gh<_i23.BoardGamesService>(),
    gh<_i25.PlaythroughService>(),
  ));
  gh.factory<_i29.CollectionSearchResultViewModel>(
      () => _i29.CollectionSearchResultViewModel(gh<_i28.BoardGamesStore>()));
  gh.factory<_i30.CollectionsViewModel>(() => _i30.CollectionsViewModel(
        gh<_i19.UserStore>(),
        gh<_i28.BoardGamesStore>(),
        gh<_i21.BoardGamesFiltersStore>(),
        gh<_i15.ScoresStore>(),
        gh<_i26.PlaythroughsStore>(),
        gh<_i9.PlayersStore>(),
      ));
  gh.factory<_i31.CreateBoardGameViewModel>(() => _i31.CreateBoardGameViewModel(
        gh<_i28.BoardGamesStore>(),
        gh<_i6.FileService>(),
      ));
  gh.singleton<_i32.GamePlaythroughsDetailsStore>(
      _i32.GamePlaythroughsDetailsStore(
    gh<_i26.PlaythroughsStore>(),
    gh<_i15.ScoresStore>(),
    gh<_i9.PlayersStore>(),
    gh<_i28.BoardGamesStore>(),
  ));
  gh.singleton<_i33.HotBoardGamesViewModel>(_i33.HotBoardGamesViewModel(
    gh<_i28.BoardGamesStore>(),
    gh<_i22.BoardGamesGeekService>(),
    gh<_i20.AnalyticsService>(),
  ));
  gh.factory<_i34.PlaysViewModel>(() => _i34.PlaysViewModel(
        gh<_i26.PlaythroughsStore>(),
        gh<_i28.BoardGamesStore>(),
        gh<_i9.PlayersStore>(),
        gh<_i15.ScoresStore>(),
        gh<_i20.AnalyticsService>(),
      ));
  gh.factory<_i35.PlaythroughMigrationViewModel>(
      () => _i35.PlaythroughMigrationViewModel(
            gh<_i15.ScoresStore>(),
            gh<_i32.GamePlaythroughsDetailsStore>(),
          ));
  gh.factory<_i36.PlaythroughNoteViewModel>(() =>
      _i36.PlaythroughNoteViewModel(gh<_i32.GamePlaythroughsDetailsStore>()));
  gh.singleton<_i37.PlaythroughStatisticsViewModel>(
      _i37.PlaythroughStatisticsViewModel(
    gh<_i8.PlayerService>(),
    gh<_i15.ScoresStore>(),
    gh<_i32.GamePlaythroughsDetailsStore>(),
  ));
  gh.factory<_i38.PlaythroughsGameSettingsViewModel>(
      () => _i38.PlaythroughsGameSettingsViewModel(
            gh<_i28.BoardGamesStore>(),
            gh<_i32.GamePlaythroughsDetailsStore>(),
          ));
  gh.factory<_i39.PlaythroughsHistoryViewModel>(() =>
      _i39.PlaythroughsHistoryViewModel(
          gh<_i32.GamePlaythroughsDetailsStore>()));
  gh.factory<_i40.PlaythroughsLogGameViewModel>(
      () => _i40.PlaythroughsLogGameViewModel(
            gh<_i9.PlayersStore>(),
            gh<_i32.GamePlaythroughsDetailsStore>(),
            gh<_i20.AnalyticsService>(),
          ));
  gh.factory<_i41.PlaythroughsViewModel>(() => _i41.PlaythroughsViewModel(
        gh<_i32.GamePlaythroughsDetailsStore>(),
        gh<_i9.PlayersStore>(),
        gh<_i20.AnalyticsService>(),
        gh<_i23.BoardGamesService>(),
        gh<_i19.UserStore>(),
      ));
  gh.singleton<_i42.SettingsViewModel>(_i42.SettingsViewModel(
    gh<_i6.FileService>(),
    gh<_i23.BoardGamesService>(),
    gh<_i4.BoardGamesFiltersService>(),
    gh<_i8.PlayerService>(),
    gh<_i18.UserService>(),
    gh<_i25.PlaythroughService>(),
    gh<_i14.ScoreService>(),
    gh<_i12.PreferencesService>(),
    gh<_i3.AppStore>(),
    gh<_i19.UserStore>(),
    gh<_i28.BoardGamesStore>(),
  ));
  gh.factory<_i43.BoardGameDetailsViewModel>(
      () => _i43.BoardGameDetailsViewModel(
            gh<_i28.BoardGamesStore>(),
            gh<_i20.AnalyticsService>(),
          ));
  gh.factory<_i44.EditPlaythoughViewModel>(() =>
      _i44.EditPlaythoughViewModel(gh<_i32.GamePlaythroughsDetailsStore>()));
  gh.factory<_i45.HomeViewModel>(() => _i45.HomeViewModel(
        gh<_i20.AnalyticsService>(),
        gh<_i13.RateAndReviewService>(),
        gh<_i10.PlayersViewModel>(),
        gh<_i21.BoardGamesFiltersStore>(),
        gh<_i30.CollectionsViewModel>(),
        gh<_i33.HotBoardGamesViewModel>(),
        gh<_i34.PlaysViewModel>(),
        gh<_i3.AppStore>(),
        gh<_i17.SearchStore>(),
        gh<_i28.BoardGamesStore>(),
        gh<_i22.BoardGamesGeekService>(),
      ));
  return getIt;
}

class _$RegisterModule extends _i46.RegisterModule {}
