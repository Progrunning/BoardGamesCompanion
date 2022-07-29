// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:firebase_analytics/firebase_analytics.dart' as _i6;
import 'package:firebase_analytics/observer.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'pages/games/games_view_model.dart' as _i25;
import 'pages/players/players_view_model.dart' as _i10;
import 'pages/playthroughs/playthroughs_view_model.dart' as _i22;
import 'services/analytics_service.dart' as _i15;
import 'services/board_games_filters_service.dart' as _i3;
import 'services/board_games_geek_service.dart' as _i17;
import 'services/board_games_service.dart' as _i18;
import 'services/file_service.dart' as _i5;
import 'services/injectable_register_module.dart' as _i27;
import 'services/player_service.dart' as _i8;
import 'services/playthroughs_service.dart' as _i19;
import 'services/preferences_service.dart' as _i11;
import 'services/rate_and_review_service.dart' as _i12;
import 'services/score_service.dart' as _i13;
import 'services/user_service.dart' as _i14;
import 'stores/board_games_filters_store.dart' as _i16;
import 'stores/board_games_store.dart' as _i24;
import 'stores/players_store.dart' as _i9;
import 'stores/playthrough_statistics_store.dart' as _i20;
import 'stores/playthrough_store.dart' as _i26;
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
  gh.singleton<_i14.UserService>(_i14.UserService());
  gh.singleton<_i15.AnalyticsService>(_i15.AnalyticsService(
      get<_i6.FirebaseAnalytics>(), get<_i12.RateAndReviewService>()));
  gh.singleton<_i16.BoardGamesFiltersStore>(_i16.BoardGamesFiltersStore(
      get<_i3.BoardGamesFiltersService>(), get<_i15.AnalyticsService>()));
  gh.singleton<_i17.BoardGamesGeekService>(
      _i17.BoardGamesGeekService(get<_i4.CustomHttpClientAdapter>()));
  gh.singleton<_i18.BoardGamesService>(_i18.BoardGamesService(
      get<_i17.BoardGamesGeekService>(), get<_i11.PreferencesService>()));
  gh.singleton<_i19.PlaythroughService>(
      _i19.PlaythroughService(get<_i13.ScoreService>()));
  gh.singleton<_i20.PlaythroughStatisticsStore>(_i20.PlaythroughStatisticsStore(
      get<_i8.PlayerService>(),
      get<_i13.ScoreService>(),
      get<_i19.PlaythroughService>()));
  gh.singleton<_i21.PlaythroughsStore>(
      _i21.PlaythroughsStore(get<_i19.PlaythroughService>()));
  gh.factory<_i22.PlaythroughsViewModel>(() => _i22.PlaythroughsViewModel(
      get<_i21.PlaythroughsStore>(),
      get<_i20.PlaythroughStatisticsStore>(),
      get<_i9.PlayersStore>(),
      get<_i15.AnalyticsService>(),
      get<_i18.BoardGamesService>()));
  gh.factory<_i23.AnalyticsRouteObserver>(
      () => _i23.AnalyticsRouteObserver(get<_i15.AnalyticsService>()));
  gh.singleton<_i24.BoardGamesStore>(_i24.BoardGamesStore(
      get<_i18.BoardGamesService>(), get<_i19.PlaythroughService>()));
  gh.factory<_i25.GamesViewModel>(() => _i25.GamesViewModel(
      get<_i24.BoardGamesStore>(), get<_i16.BoardGamesFiltersStore>()));
  gh.factory<_i26.PlaythroughStore>(() => _i26.PlaythroughStore(
      get<_i8.PlayerService>(),
      get<_i13.ScoreService>(),
      get<_i21.PlaythroughsStore>()));
  return get;
}

class _$RegisterModule extends _i27.RegisterModule {
  @override
  _i6.FirebaseAnalytics get firebaseAnalytics => _i6.FirebaseAnalytics();
}
