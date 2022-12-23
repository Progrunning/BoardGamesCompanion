// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:firebase_analytics/firebase_analytics.dart' as _i7;
import 'package:firebase_analytics/observer.dart' as _i8;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'pages/board_game_details/board_game_details_view_model.dart' as _i41;
import 'pages/collections/collection_search_result_view_model.dart' as _i29;
import 'pages/collections/collections_view_model.dart' as _i30;
import 'pages/edit_playthrough/edit_playthrough_view_model.dart' as _i42;
import 'pages/edit_playthrough/playthrough_note_view_model.dart' as _i33;
import 'pages/home/home_view_model.dart' as _i43;
import 'pages/player/player_view_model.dart' as _i24;
import 'pages/players/players_view_model.dart' as _i11;
import 'pages/plays/plays_view_model.dart' as _i32;
import 'pages/playthroughs/playthrough_statistics_view_model.dart' as _i34;
import 'pages/playthroughs/playthroughs_game_settings_view_model.dart' as _i35;
import 'pages/playthroughs/playthroughs_history_view_model.dart' as _i36;
import 'pages/playthroughs/playthroughs_log_game_view_model.dart' as _i37;
import 'pages/playthroughs/playthroughs_view_model.dart' as _i38;
import 'pages/search_board_games/search_board_games_view_model.dart' as _i39;
import 'pages/settings/settings_view_model.dart' as _i40;
import 'services/analytics_service.dart' as _i20;
import 'services/board_games_filters_service.dart' as _i4;
import 'services/board_games_geek_service.dart' as _i22;
import 'services/board_games_service.dart' as _i23;
import 'services/file_service.dart' as _i6;
import 'services/injectable_register_module.dart' as _i44;
import 'services/player_service.dart' as _i9;
import 'services/playthroughs_service.dart' as _i25;
import 'services/preferences_service.dart' as _i12;
import 'services/rate_and_review_service.dart' as _i13;
import 'services/score_service.dart' as _i14;
import 'services/search_service.dart' as _i16;
import 'services/user_service.dart' as _i18;
import 'stores/app_store.dart' as _i3;
import 'stores/board_games_filters_store.dart' as _i21;
import 'stores/board_games_store.dart' as _i28;
import 'stores/game_playthroughs_details_store.dart' as _i31;
import 'stores/players_store.dart' as _i10;
import 'stores/playthroughs_store.dart' as _i26;
import 'stores/scores_store.dart' as _i15;
import 'stores/search_store.dart' as _i17;
import 'stores/user_store.dart' as _i19;
import 'utilities/analytics_route_observer.dart' as _i27;
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
  gh.singleton<_i15.ScoresStore>(_i15.ScoresStore(get<_i14.ScoreService>()));
  gh.singleton<_i16.SearchService>(_i16.SearchService());
  gh.singleton<_i17.SearchStore>(_i17.SearchStore(get<_i16.SearchService>()));
  gh.singleton<_i18.UserService>(_i18.UserService());
  gh.singleton<_i19.UserStore>(
      _i19.UserStore(get<_i18.UserService>(), get<_i3.AppStore>()));
  gh.singleton<_i20.AnalyticsService>(_i20.AnalyticsService(
      get<_i7.FirebaseAnalytics>(), get<_i13.RateAndReviewService>()));
  gh.singleton<_i21.BoardGamesFiltersStore>(_i21.BoardGamesFiltersStore(
      get<_i4.BoardGamesFiltersService>(), get<_i20.AnalyticsService>()));
  gh.singleton<_i22.BoardGamesGeekService>(
      _i22.BoardGamesGeekService(get<_i5.CustomHttpClientAdapter>()));
  gh.singleton<_i23.BoardGamesService>(
      _i23.BoardGamesService(get<_i22.BoardGamesGeekService>()));
  gh.factory<_i24.PlayerViewModel>(
      () => _i24.PlayerViewModel(get<_i10.PlayersStore>()));
  gh.singleton<_i25.PlaythroughService>(
      _i25.PlaythroughService(get<_i14.ScoreService>()));
  gh.singleton<_i26.PlaythroughsStore>(_i26.PlaythroughsStore(
      get<_i25.PlaythroughService>(), get<_i15.ScoresStore>()));
  gh.factory<_i27.AnalyticsRouteObserver>(
      () => _i27.AnalyticsRouteObserver(get<_i20.AnalyticsService>()));
  gh.singleton<_i28.BoardGamesStore>(_i28.BoardGamesStore(
      get<_i23.BoardGamesService>(),
      get<_i25.PlaythroughService>(),
      get<_i3.AppStore>()));
  gh.factory<_i29.CollectionSearchResultViewModel>(
      () => _i29.CollectionSearchResultViewModel(get<_i28.BoardGamesStore>()));
  gh.factory<_i30.CollectionsViewModel>(() => _i30.CollectionsViewModel(
      get<_i19.UserStore>(),
      get<_i28.BoardGamesStore>(),
      get<_i21.BoardGamesFiltersStore>(),
      get<_i15.ScoresStore>(),
      get<_i26.PlaythroughsStore>(),
      get<_i10.PlayersStore>(),
      get<_i17.SearchStore>(),
      get<_i20.AnalyticsService>()));
  gh.singleton<_i31.GamePlaythroughsDetailsStore>(
      _i31.GamePlaythroughsDetailsStore(get<_i26.PlaythroughsStore>(),
          get<_i15.ScoresStore>(), get<_i10.PlayersStore>()));
  gh.factory<_i32.PlaysViewModel>(() => _i32.PlaysViewModel(
      get<_i26.PlaythroughsStore>(),
      get<_i28.BoardGamesStore>(),
      get<_i10.PlayersStore>(),
      get<_i15.ScoresStore>(),
      get<_i20.AnalyticsService>()));
  gh.factory<_i33.PlaythroughNoteViewModel>(() =>
      _i33.PlaythroughNoteViewModel(get<_i31.GamePlaythroughsDetailsStore>()));
  gh.singleton<_i34.PlaythroughStatisticsViewModel>(
      _i34.PlaythroughStatisticsViewModel(get<_i9.PlayerService>(),
          get<_i15.ScoresStore>(), get<_i31.GamePlaythroughsDetailsStore>()));
  gh.factory<_i35.PlaythroughsGameSettingsViewModel>(() =>
      _i35.PlaythroughsGameSettingsViewModel(get<_i28.BoardGamesStore>(),
          get<_i31.GamePlaythroughsDetailsStore>()));
  gh.factory<_i36.PlaythroughsHistoryViewModel>(() =>
      _i36.PlaythroughsHistoryViewModel(
          get<_i31.GamePlaythroughsDetailsStore>()));
  gh.factory<_i37.PlaythroughsLogGameViewModel>(() =>
      _i37.PlaythroughsLogGameViewModel(
          get<_i10.PlayersStore>(),
          get<_i31.GamePlaythroughsDetailsStore>(),
          get<_i20.AnalyticsService>()));
  gh.factory<_i38.PlaythroughsViewModel>(() => _i38.PlaythroughsViewModel(
      get<_i31.GamePlaythroughsDetailsStore>(),
      get<_i10.PlayersStore>(),
      get<_i20.AnalyticsService>(),
      get<_i23.BoardGamesService>(),
      get<_i19.UserStore>()));
  gh.singleton<_i39.SearchBoardGamesViewModel>(_i39.SearchBoardGamesViewModel(
      get<_i28.BoardGamesStore>(),
      get<_i22.BoardGamesGeekService>(),
      get<_i20.AnalyticsService>()));
  gh.singleton<_i40.SettingsViewModel>(_i40.SettingsViewModel(
      get<_i6.FileService>(),
      get<_i23.BoardGamesService>(),
      get<_i4.BoardGamesFiltersService>(),
      get<_i9.PlayerService>(),
      get<_i18.UserService>(),
      get<_i25.PlaythroughService>(),
      get<_i14.ScoreService>(),
      get<_i12.PreferencesService>(),
      get<_i3.AppStore>(),
      get<_i19.UserStore>(),
      get<_i28.BoardGamesStore>()));
  gh.factory<_i41.BoardGameDetailsViewModel>(() =>
      _i41.BoardGameDetailsViewModel(
          get<_i28.BoardGamesStore>(), get<_i20.AnalyticsService>()));
  gh.factory<_i42.EditPlaythoughViewModel>(() => _i42.EditPlaythoughViewModel(
      get<_i31.GamePlaythroughsDetailsStore>(), get<_i28.BoardGamesStore>()));
  gh.factory<_i43.HomeViewModel>(() => _i43.HomeViewModel(
      get<_i20.AnalyticsService>(),
      get<_i13.RateAndReviewService>(),
      get<_i11.PlayersViewModel>(),
      get<_i21.BoardGamesFiltersStore>(),
      get<_i30.CollectionsViewModel>(),
      get<_i39.SearchBoardGamesViewModel>(),
      get<_i32.PlaysViewModel>()));
  return get;
}

class _$RegisterModule extends _i44.RegisterModule {
  @override
  _i7.FirebaseAnalytics get firebaseAnalytics => _i7.FirebaseAnalytics();
}
