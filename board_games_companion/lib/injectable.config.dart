// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:firebase_analytics/firebase_analytics.dart' as _i8;
import 'package:firebase_analytics/observer.dart' as _i9;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'pages/board_game_details/board_game_details_view_model.dart' as _i42;
import 'pages/collections/collection_search_result_view_model.dart' as _i30;
import 'pages/collections/collections_view_model.dart' as _i31;
import 'pages/create_board_game/create_board_game_view_model.dart' as _i5;
import 'pages/edit_playthrough/edit_playthrough_view_model.dart' as _i43;
import 'pages/edit_playthrough/playthrough_note_view_model.dart' as _i35;
import 'pages/home/home_view_model.dart' as _i44;
import 'pages/hot_board_games/hot_board_games_view_model.dart' as _i33;
import 'pages/player/player_view_model.dart' as _i25;
import 'pages/players/players_view_model.dart' as _i12;
import 'pages/plays/plays_view_model.dart' as _i34;
import 'pages/playthroughs/playthrough_statistics_view_model.dart' as _i36;
import 'pages/playthroughs/playthroughs_game_settings_view_model.dart' as _i37;
import 'pages/playthroughs/playthroughs_history_view_model.dart' as _i38;
import 'pages/playthroughs/playthroughs_log_game_view_model.dart' as _i39;
import 'pages/playthroughs/playthroughs_view_model.dart' as _i40;
import 'pages/settings/settings_view_model.dart' as _i41;
import 'services/analytics_service.dart' as _i21;
import 'services/board_games_filters_service.dart' as _i4;
import 'services/board_games_geek_service.dart' as _i23;
import 'services/board_games_service.dart' as _i24;
import 'services/file_service.dart' as _i7;
import 'services/injectable_register_module.dart' as _i45;
import 'services/player_service.dart' as _i10;
import 'services/playthroughs_service.dart' as _i26;
import 'services/preferences_service.dart' as _i13;
import 'services/rate_and_review_service.dart' as _i14;
import 'services/score_service.dart' as _i15;
import 'services/search_service.dart' as _i17;
import 'services/user_service.dart' as _i19;
import 'stores/app_store.dart' as _i3;
import 'stores/board_games_filters_store.dart' as _i22;
import 'stores/board_games_store.dart' as _i29;
import 'stores/game_playthroughs_details_store.dart' as _i32;
import 'stores/players_store.dart' as _i11;
import 'stores/playthroughs_store.dart' as _i27;
import 'stores/scores_store.dart' as _i16;
import 'stores/search_store.dart' as _i18;
import 'stores/user_store.dart' as _i20;
import 'utilities/analytics_route_observer.dart' as _i28;
import 'utilities/custom_http_client_adapter.dart'
    as _i6; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.singleton<_i3.AppStore>(_i3.AppStore());
  gh.singleton<_i4.BoardGamesFiltersService>(_i4.BoardGamesFiltersService());
  gh.factory<_i5.CreateBoardGameViewModel>(
      () => _i5.CreateBoardGameViewModel());
  gh.factory<_i6.CustomHttpClientAdapter>(() => _i6.CustomHttpClientAdapter());
  gh.singleton<_i7.FileService>(_i7.FileService());
  gh.singleton<_i8.FirebaseAnalytics>(registerModule.firebaseAnalytics);
  gh.singleton<_i9.FirebaseAnalyticsObserver>(
      registerModule.firebaseAnalyticsObserver);
  gh.singleton<_i10.PlayerService>(_i10.PlayerService(get<_i7.FileService>()));
  gh.singleton<_i11.PlayersStore>(_i11.PlayersStore(get<_i10.PlayerService>()));
  gh.factory<_i12.PlayersViewModel>(
      () => _i12.PlayersViewModel(get<_i11.PlayersStore>()));
  gh.singleton<_i13.PreferencesService>(_i13.PreferencesService());
  gh.singleton<_i14.RateAndReviewService>(
      _i14.RateAndReviewService(get<_i13.PreferencesService>()));
  gh.singleton<_i15.ScoreService>(_i15.ScoreService());
  gh.singleton<_i16.ScoresStore>(_i16.ScoresStore(get<_i15.ScoreService>()));
  gh.singleton<_i17.SearchService>(_i17.SearchService());
  gh.singleton<_i18.SearchStore>(_i18.SearchStore(get<_i17.SearchService>()));
  gh.singleton<_i19.UserService>(_i19.UserService());
  gh.singleton<_i20.UserStore>(_i20.UserStore(get<_i19.UserService>()));
  gh.singleton<_i21.AnalyticsService>(_i21.AnalyticsService(
      get<_i8.FirebaseAnalytics>(), get<_i14.RateAndReviewService>()));
  gh.singleton<_i22.BoardGamesFiltersStore>(_i22.BoardGamesFiltersStore(
      get<_i4.BoardGamesFiltersService>(), get<_i21.AnalyticsService>()));
  gh.singleton<_i23.BoardGamesGeekService>(
      _i23.BoardGamesGeekService(get<_i6.CustomHttpClientAdapter>()));
  gh.singleton<_i24.BoardGamesService>(
      _i24.BoardGamesService(get<_i23.BoardGamesGeekService>()));
  gh.factory<_i25.PlayerViewModel>(
      () => _i25.PlayerViewModel(get<_i11.PlayersStore>()));
  gh.singleton<_i26.PlaythroughService>(
      _i26.PlaythroughService(get<_i15.ScoreService>()));
  gh.singleton<_i27.PlaythroughsStore>(_i27.PlaythroughsStore(
      get<_i26.PlaythroughService>(), get<_i16.ScoresStore>()));
  gh.factory<_i28.AnalyticsRouteObserver>(
      () => _i28.AnalyticsRouteObserver(get<_i21.AnalyticsService>()));
  gh.singleton<_i29.BoardGamesStore>(_i29.BoardGamesStore(
      get<_i24.BoardGamesService>(), get<_i26.PlaythroughService>()));
  gh.factory<_i30.CollectionSearchResultViewModel>(
      () => _i30.CollectionSearchResultViewModel(get<_i29.BoardGamesStore>()));
  gh.factory<_i31.CollectionsViewModel>(() => _i31.CollectionsViewModel(
      get<_i20.UserStore>(),
      get<_i29.BoardGamesStore>(),
      get<_i22.BoardGamesFiltersStore>(),
      get<_i16.ScoresStore>(),
      get<_i27.PlaythroughsStore>(),
      get<_i11.PlayersStore>()));
  gh.singleton<_i32.GamePlaythroughsDetailsStore>(
      _i32.GamePlaythroughsDetailsStore(get<_i27.PlaythroughsStore>(),
          get<_i16.ScoresStore>(), get<_i11.PlayersStore>()));
  gh.singleton<_i33.HotBoardGamesViewModel>(_i33.HotBoardGamesViewModel(
      get<_i29.BoardGamesStore>(),
      get<_i23.BoardGamesGeekService>(),
      get<_i21.AnalyticsService>()));
  gh.factory<_i34.PlaysViewModel>(() => _i34.PlaysViewModel(
      get<_i27.PlaythroughsStore>(),
      get<_i29.BoardGamesStore>(),
      get<_i11.PlayersStore>(),
      get<_i16.ScoresStore>(),
      get<_i21.AnalyticsService>()));
  gh.factory<_i35.PlaythroughNoteViewModel>(() =>
      _i35.PlaythroughNoteViewModel(get<_i32.GamePlaythroughsDetailsStore>()));
  gh.singleton<_i36.PlaythroughStatisticsViewModel>(
      _i36.PlaythroughStatisticsViewModel(get<_i10.PlayerService>(),
          get<_i16.ScoresStore>(), get<_i32.GamePlaythroughsDetailsStore>()));
  gh.factory<_i37.PlaythroughsGameSettingsViewModel>(() =>
      _i37.PlaythroughsGameSettingsViewModel(get<_i29.BoardGamesStore>(),
          get<_i32.GamePlaythroughsDetailsStore>()));
  gh.factory<_i38.PlaythroughsHistoryViewModel>(() =>
      _i38.PlaythroughsHistoryViewModel(
          get<_i32.GamePlaythroughsDetailsStore>()));
  gh.factory<_i39.PlaythroughsLogGameViewModel>(() =>
      _i39.PlaythroughsLogGameViewModel(
          get<_i11.PlayersStore>(),
          get<_i32.GamePlaythroughsDetailsStore>(),
          get<_i21.AnalyticsService>()));
  gh.factory<_i40.PlaythroughsViewModel>(() => _i40.PlaythroughsViewModel(
      get<_i32.GamePlaythroughsDetailsStore>(),
      get<_i11.PlayersStore>(),
      get<_i21.AnalyticsService>(),
      get<_i24.BoardGamesService>(),
      get<_i20.UserStore>()));
  gh.singleton<_i41.SettingsViewModel>(_i41.SettingsViewModel(
      get<_i7.FileService>(),
      get<_i24.BoardGamesService>(),
      get<_i4.BoardGamesFiltersService>(),
      get<_i10.PlayerService>(),
      get<_i19.UserService>(),
      get<_i26.PlaythroughService>(),
      get<_i15.ScoreService>(),
      get<_i13.PreferencesService>(),
      get<_i3.AppStore>(),
      get<_i20.UserStore>(),
      get<_i29.BoardGamesStore>()));
  gh.factory<_i42.BoardGameDetailsViewModel>(() =>
      _i42.BoardGameDetailsViewModel(
          get<_i29.BoardGamesStore>(), get<_i21.AnalyticsService>()));
  gh.factory<_i43.EditPlaythoughViewModel>(() => _i43.EditPlaythoughViewModel(
      get<_i32.GamePlaythroughsDetailsStore>(), get<_i29.BoardGamesStore>()));
  gh.factory<_i44.HomeViewModel>(() => _i44.HomeViewModel(
      get<_i21.AnalyticsService>(),
      get<_i14.RateAndReviewService>(),
      get<_i12.PlayersViewModel>(),
      get<_i22.BoardGamesFiltersStore>(),
      get<_i31.CollectionsViewModel>(),
      get<_i33.HotBoardGamesViewModel>(),
      get<_i34.PlaysViewModel>(),
      get<_i3.AppStore>(),
      get<_i18.SearchStore>(),
      get<_i29.BoardGamesStore>(),
      get<_i23.BoardGamesGeekService>()));
  return get;
}

class _$RegisterModule extends _i45.RegisterModule {
  @override
  _i8.FirebaseAnalytics get firebaseAnalytics => _i8.FirebaseAnalytics();
}
