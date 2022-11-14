// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:firebase_analytics/firebase_analytics.dart' as _i7;
import 'package:firebase_analytics/observer.dart' as _i8;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'pages/board_game_details/board_game_details_view_model.dart' as _i38;
import 'pages/edit_playthrough/edit_playthrough_view_model.dart' as _i39;
import 'pages/edit_playthrough/playthrough_note_view_model.dart' as _i29;
import 'pages/games/collection_search_result_view_model.dart' as _i26;
import 'pages/games/games_view_model.dart' as _i28;
import 'pages/home/home_view_model.dart' as _i40;
import 'pages/player/player_view_model.dart' as _i21;
import 'pages/players/players_view_model.dart' as _i11;
import 'pages/playthroughs/playthrough_statistics_view_model.dart' as _i30;
import 'pages/playthroughs/playthroughs_game_settings_view_model.dart' as _i31;
import 'pages/playthroughs/playthroughs_history_view_model.dart' as _i32;
import 'pages/playthroughs/playthroughs_log_game_view_model.dart' as _i34;
import 'pages/playthroughs/playthroughs_view_model.dart' as _i35;
import 'pages/playthroughs_history/playthroughs_history_view_model.dart'
    as _i33;
import 'pages/search_board_games/search_board_games_view_model.dart' as _i36;
import 'pages/settings/settings_view_model.dart' as _i37;
import 'services/analytics_service.dart' as _i17;
import 'services/board_games_filters_service.dart' as _i4;
import 'services/board_games_geek_service.dart' as _i19;
import 'services/board_games_service.dart' as _i20;
import 'services/file_service.dart' as _i6;
import 'services/injectable_register_module.dart' as _i41;
import 'services/player_service.dart' as _i9;
import 'services/playthroughs_service.dart' as _i22;
import 'services/preferences_service.dart' as _i12;
import 'services/rate_and_review_service.dart' as _i13;
import 'services/score_service.dart' as _i14;
import 'services/user_service.dart' as _i15;
import 'stores/app_store.dart' as _i3;
import 'stores/board_games_filters_store.dart' as _i18;
import 'stores/board_games_store.dart' as _i25;
import 'stores/game_playthroughs_store.dart' as _i27;
import 'stores/players_store.dart' as _i10;
import 'stores/playthroughs_store.dart' as _i23;
import 'stores/user_store.dart' as _i16;
import 'utilities/analytics_route_observer.dart' as _i24;
import 'utilities/custom_http_client_adapter.dart'
    as _i5; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.singleton<_i3.AppStore>(_i3.AppStore());
  gh.singleton<_i4.BoardGamesFiltersService>(_i4.BoardGamesFiltersService());
  gh.factory<_i5.CustomHttpClientAdapter>(() => _i5.CustomHttpClientAdapter());
  gh.singleton<_i6.FileService>(_i6.FileService());
  gh.singleton<_i7.FirebaseAnalytics>(registerModule.firebaseAnalytics);
  gh.singleton<_i8.FirebaseAnalyticsObserver>(
      registerModule.firebaseAnalyticsObserver);
  gh.singleton<_i9.PlayerService>(_i9.PlayerService(get<_i6.FileService>()));
  gh.singleton<_i10.PlayersStore>(
      _i10.PlayersStore(get<_i9.PlayerService>(), get<_i3.AppStore>()));
  gh.factory<_i11.PlayersViewModel>(
      () => _i11.PlayersViewModel(get<_i10.PlayersStore>()));
  gh.singleton<_i12.PreferencesService>(_i12.PreferencesService());
  gh.singleton<_i13.RateAndReviewService>(
      _i13.RateAndReviewService(get<_i12.PreferencesService>()));
  gh.singleton<_i14.ScoreService>(_i14.ScoreService());
  gh.singleton<_i15.UserService>(_i15.UserService());
  gh.singleton<_i16.UserStore>(
      _i16.UserStore(get<_i15.UserService>(), get<_i3.AppStore>()));
  gh.singleton<_i17.AnalyticsService>(_i17.AnalyticsService(
      get<_i7.FirebaseAnalytics>(), get<_i13.RateAndReviewService>()));
  gh.singleton<_i18.BoardGamesFiltersStore>(_i18.BoardGamesFiltersStore(
      get<_i4.BoardGamesFiltersService>(), get<_i17.AnalyticsService>()));
  gh.singleton<_i19.BoardGamesGeekService>(
      _i19.BoardGamesGeekService(get<_i5.CustomHttpClientAdapter>()));
  gh.singleton<_i20.BoardGamesService>(
      _i20.BoardGamesService(get<_i19.BoardGamesGeekService>()));
  gh.factory<_i21.PlayerViewModel>(
      () => _i21.PlayerViewModel(get<_i10.PlayersStore>()));
  gh.singleton<_i22.PlaythroughService>(
      _i22.PlaythroughService(get<_i14.ScoreService>()));
  gh.singleton<_i23.PlaythroughsStore>(
      _i23.PlaythroughsStore(get<_i22.PlaythroughService>()));
  gh.factory<_i24.AnalyticsRouteObserver>(
      () => _i24.AnalyticsRouteObserver(get<_i17.AnalyticsService>()));
  gh.singleton<_i25.BoardGamesStore>(_i25.BoardGamesStore(
      get<_i20.BoardGamesService>(),
      get<_i22.PlaythroughService>(),
      get<_i3.AppStore>()));
  gh.factory<_i26.CollectionSearchResultViewModel>(
      () => _i26.CollectionSearchResultViewModel(get<_i25.BoardGamesStore>()));
  gh.singleton<_i27.GamePlaythroughsStore>(_i27.GamePlaythroughsStore(
      get<_i22.PlaythroughService>(),
      get<_i14.ScoreService>(),
      get<_i9.PlayerService>()));
  gh.factory<_i28.GamesViewModel>(() => _i28.GamesViewModel(
      get<_i16.UserStore>(),
      get<_i25.BoardGamesStore>(),
      get<_i18.BoardGamesFiltersStore>()));
  gh.factory<_i29.PlaythroughNoteViewModel>(
      () => _i29.PlaythroughNoteViewModel(get<_i27.GamePlaythroughsStore>()));
  gh.singleton<_i30.PlaythroughStatisticsViewModel>(
      _i30.PlaythroughStatisticsViewModel(
          get<_i9.PlayerService>(),
          get<_i14.ScoreService>(),
          get<_i22.PlaythroughService>(),
          get<_i27.GamePlaythroughsStore>()));
  gh.factory<_i31.PlaythroughsGameSettingsViewModel>(() =>
      _i31.PlaythroughsGameSettingsViewModel(
          get<_i25.BoardGamesStore>(), get<_i27.GamePlaythroughsStore>()));
  gh.factory<_i32.PlaythroughsHistoryViewModel>(() =>
      _i32.PlaythroughsHistoryViewModel(get<_i27.GamePlaythroughsStore>()));
  gh.factory<_i33.PlaythroughsHistoryViewModel>(() =>
      _i33.PlaythroughsHistoryViewModel(
          get<_i23.PlaythroughsStore>(), get<_i25.BoardGamesStore>()));
  gh.factory<_i34.PlaythroughsLogGameViewModel>(() =>
      _i34.PlaythroughsLogGameViewModel(get<_i10.PlayersStore>(),
          get<_i27.GamePlaythroughsStore>(), get<_i17.AnalyticsService>()));
  gh.factory<_i35.PlaythroughsViewModel>(() => _i35.PlaythroughsViewModel(
      get<_i27.GamePlaythroughsStore>(),
      get<_i10.PlayersStore>(),
      get<_i17.AnalyticsService>(),
      get<_i20.BoardGamesService>(),
      get<_i16.UserStore>()));
  gh.singleton<_i36.SearchBoardGamesViewModel>(_i36.SearchBoardGamesViewModel(
      get<_i25.BoardGamesStore>(),
      get<_i19.BoardGamesGeekService>(),
      get<_i17.AnalyticsService>()));
  gh.singleton<_i37.SettingsViewModel>(_i37.SettingsViewModel(
      get<_i6.FileService>(),
      get<_i20.BoardGamesService>(),
      get<_i4.BoardGamesFiltersService>(),
      get<_i9.PlayerService>(),
      get<_i15.UserService>(),
      get<_i22.PlaythroughService>(),
      get<_i14.ScoreService>(),
      get<_i12.PreferencesService>(),
      get<_i3.AppStore>(),
      get<_i16.UserStore>(),
      get<_i25.BoardGamesStore>()));
  gh.factory<_i38.BoardGameDetailsViewModel>(() =>
      _i38.BoardGameDetailsViewModel(
          get<_i25.BoardGamesStore>(), get<_i17.AnalyticsService>()));
  gh.factory<_i39.EditPlaythoughViewModel>(
      () => _i39.EditPlaythoughViewModel(get<_i27.GamePlaythroughsStore>()));
  gh.factory<_i40.HomeViewModel>(() => _i40.HomeViewModel(
      get<_i17.AnalyticsService>(),
      get<_i13.RateAndReviewService>(),
      get<_i11.PlayersViewModel>(),
      get<_i18.BoardGamesFiltersStore>(),
      get<_i28.GamesViewModel>(),
      get<_i36.SearchBoardGamesViewModel>(),
      get<_i33.PlaythroughsHistoryViewModel>()));
  return get;
}

class _$RegisterModule extends _i41.RegisterModule {
  @override
  _i7.FirebaseAnalytics get firebaseAnalytics => _i7.FirebaseAnalytics();
}
