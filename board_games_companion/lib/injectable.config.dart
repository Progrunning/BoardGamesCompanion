// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:firebase_analytics/firebase_analytics.dart' as _i6;
import 'package:firebase_analytics/observer.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'pages/board_game_details/board_game_details_view_model.dart' as _i33;
import 'pages/edit_playthrough/edit_playthrough_view_model.dart' as _i26;
import 'pages/games/collection_search_result_view_model.dart' as _i25;
import 'pages/games/games_view_model.dart' as _i27;
import 'pages/players/players_view_model.dart' as _i10;
import 'pages/playthroughs/playthrough_statistics_view_model.dart' as _i28;
import 'pages/playthroughs/playthroughs_game_settings_view_model.dart' as _i29;
import 'pages/playthroughs/playthroughs_history_view_model.dart' as _i30;
import 'pages/playthroughs/playthroughs_log_game_view_model.dart' as _i31;
import 'pages/playthroughs/playthroughs_view_model.dart' as _i22;
import 'pages/search_board_games/search_board_games_view_model.dart' as _i32;
import 'pages/settings/settings_view_model.dart' as _i14;
import 'services/analytics_service.dart' as _i16;
import 'services/board_games_filters_service.dart' as _i3;
import 'services/board_games_geek_service.dart' as _i18;
import 'services/board_games_service.dart' as _i19;
import 'services/file_service.dart' as _i5;
import 'services/injectable_register_module.dart' as _i34;
import 'services/player_service.dart' as _i8;
import 'services/playthroughs_service.dart' as _i20;
import 'services/preferences_service.dart' as _i11;
import 'services/rate_and_review_service.dart' as _i12;
import 'services/score_service.dart' as _i13;
import 'services/user_service.dart' as _i15;
import 'stores/board_games_filters_store.dart' as _i17;
import 'stores/board_games_store.dart' as _i24;
import 'stores/players_store.dart' as _i9;
import 'stores/playthroughs_store.dart' as _i21;
import 'utilities/analytics_route_observer.dart' as _i23;
import 'utilities/custom_http_client_adapter.dart'
    as _i4; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.singleton<_i3.BoardGamesFiltersService>(_i3.BoardGamesFiltersService());
  gh.factory<_i4.CustomHttpClientAdapter>(() => _i4.CustomHttpClientAdapter());
  gh.singleton<_i5.FileService>(_i5.FileService());
  gh.singleton<_i6.FirebaseAnalytics>(registerModule.firebaseAnalytics);
  gh.singleton<_i7.FirebaseAnalyticsObserver>(
      registerModule.firebaseAnalyticsObserver);
  gh.singleton<_i8.PlayerService>(_i8.PlayerService(get<_i5.FileService>()));
  gh.singleton<_i9.PlayersStore>(_i9.PlayersStore(get<_i8.PlayerService>()));
  gh.singleton<_i10.PlayersViewModel>(
      _i10.PlayersViewModel(get<_i9.PlayersStore>()));
  gh.singleton<_i11.PreferencesService>(_i11.PreferencesService());
  gh.singleton<_i12.RateAndReviewService>(
      _i12.RateAndReviewService(get<_i11.PreferencesService>()));
  gh.singleton<_i13.ScoreService>(_i13.ScoreService());
  gh.singleton<_i14.SettingsViewModel>(
      _i14.SettingsViewModel(get<_i5.FileService>()));
  gh.singleton<_i15.UserService>(_i15.UserService());
  gh.singleton<_i16.AnalyticsService>(_i16.AnalyticsService(
      get<_i6.FirebaseAnalytics>(), get<_i12.RateAndReviewService>()));
  gh.singleton<_i17.BoardGamesFiltersStore>(_i17.BoardGamesFiltersStore(
      get<_i3.BoardGamesFiltersService>(), get<_i16.AnalyticsService>()));
  gh.singleton<_i18.BoardGamesGeekService>(
      _i18.BoardGamesGeekService(get<_i4.CustomHttpClientAdapter>()));
  gh.singleton<_i19.BoardGamesService>(
      _i19.BoardGamesService(get<_i18.BoardGamesGeekService>()));
  gh.singleton<_i20.PlaythroughService>(
      _i20.PlaythroughService(get<_i13.ScoreService>()));
  gh.singleton<_i21.PlaythroughsStore>(_i21.PlaythroughsStore(
      get<_i20.PlaythroughService>(),
      get<_i13.ScoreService>(),
      get<_i8.PlayerService>()));
  gh.factory<_i22.PlaythroughsViewModel>(() => _i22.PlaythroughsViewModel(
      get<_i21.PlaythroughsStore>(),
      get<_i9.PlayersStore>(),
      get<_i16.AnalyticsService>(),
      get<_i19.BoardGamesService>()));
  gh.factory<_i23.AnalyticsRouteObserver>(
      () => _i23.AnalyticsRouteObserver(get<_i16.AnalyticsService>()));
  gh.singleton<_i24.BoardGamesStore>(_i24.BoardGamesStore(
      get<_i19.BoardGamesService>(), get<_i20.PlaythroughService>()));
  gh.factory<_i25.CollectionSearchResultViewModel>(
      () => _i25.CollectionSearchResultViewModel(get<_i24.BoardGamesStore>()));
  gh.factory<_i26.EditPlaythoughViewModel>(
      () => _i26.EditPlaythoughViewModel(get<_i21.PlaythroughsStore>()));
  gh.factory<_i27.GamesViewModel>(() => _i27.GamesViewModel(
      get<_i24.BoardGamesStore>(), get<_i17.BoardGamesFiltersStore>()));
  gh.singleton<_i28.PlaythroughStatisticsViewModel>(
      _i28.PlaythroughStatisticsViewModel(
          get<_i8.PlayerService>(),
          get<_i13.ScoreService>(),
          get<_i20.PlaythroughService>(),
          get<_i21.PlaythroughsStore>()));
  gh.factory<_i29.PlaythroughsGameSettingsViewModel>(() =>
      _i29.PlaythroughsGameSettingsViewModel(
          get<_i24.BoardGamesStore>(), get<_i21.PlaythroughsStore>()));
  gh.factory<_i30.PlaythroughsHistoryViewModel>(
      () => _i30.PlaythroughsHistoryViewModel(get<_i21.PlaythroughsStore>()));
  gh.factory<_i31.PlaythroughsLogGameViewModel>(() =>
      _i31.PlaythroughsLogGameViewModel(get<_i9.PlayersStore>(),
          get<_i21.PlaythroughsStore>(), get<_i16.AnalyticsService>()));
  gh.singleton<_i32.SearchBoardGamesViewModel>(_i32.SearchBoardGamesViewModel(
      get<_i24.BoardGamesStore>(),
      get<_i18.BoardGamesGeekService>(),
      get<_i16.AnalyticsService>()));
  gh.factory<_i33.BoardGameDetailsViewModel>(() =>
      _i33.BoardGameDetailsViewModel(
          get<_i24.BoardGamesStore>(), get<_i16.AnalyticsService>()));
  return get;
}

class _$RegisterModule extends _i34.RegisterModule {
  @override
  _i6.FirebaseAnalytics get firebaseAnalytics => _i6.FirebaseAnalytics();
}
