// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:firebase_analytics/firebase_analytics.dart' as _i16;
import 'package:firebase_analytics/observer.dart' as _i17;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'pages/players/players_view_model.dart' as _i18;
import 'pages/playthroughs/playthroughs_log_game_view_model.dart' as _i10;
import 'services/analytics_service.dart' as _i5;
import 'services/board_games_filters_service.dart' as _i14;
import 'services/board_games_geek_service.dart' as _i22;
import 'services/board_games_service.dart' as _i13;
import 'services/file_service.dart' as _i15;
import 'services/injectable_register_module.dart' as _i24;
import 'services/player_service.dart' as _i7;
import 'services/playthroughs_service.dart' as _i23;
import 'services/preferences_service.dart' as _i19;
import 'services/rate_and_review_service.dart' as _i20;
import 'services/score_service.dart' as _i8;
import 'services/user_service.dart' as _i21;
import 'stores/players_store.dart' as _i12;
import 'stores/playthrough_statistics_store.dart' as _i11;
import 'stores/playthrough_store.dart' as _i6;
import 'stores/playthroughs_store.dart' as _i9;
import 'utilities/analytics_route_observer.dart' as _i4;
import 'utilities/custom_http_client_adapter.dart'
    as _i3; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.factory<_i3.CustomHttpClientAdapter>(() => _i3.CustomHttpClientAdapter());
  gh.factory<_i4.AnalyticsRouteObserver>(
      () => _i4.AnalyticsRouteObserver(get<_i5.AnalyticsService>()));
  gh.factory<_i6.PlaythroughStore>(() => _i6.PlaythroughStore(
      get<_i7.PlayerService>(),
      get<_i8.ScoreService>(),
      get<_i9.PlaythroughsStore>()));
  gh.factory<_i10.PlaythroughsLogGameViewModel>(() =>
      _i10.PlaythroughsLogGameViewModel(
          get<_i9.PlaythroughsStore>(),
          get<_i11.PlaythroughStatisticsStore>(),
          get<_i12.PlayersStore>(),
          get<_i5.AnalyticsService>(),
          get<_i13.BoardGamesService>()));
  gh.singleton<_i14.BoardGamesFiltersService>(_i14.BoardGamesFiltersService());
  gh.singleton<_i15.FileService>(_i15.FileService());
  gh.singleton<_i16.FirebaseAnalytics>(registerModule.firebaseAnalytics);
  gh.singleton<_i17.FirebaseAnalyticsObserver>(
      registerModule.firebaseAnalyticsObserver);
  gh.singleton<_i7.PlayerService>(_i7.PlayerService(get<_i15.FileService>()));
  gh.singleton<_i12.PlayersStore>(_i12.PlayersStore(get<_i7.PlayerService>()));
  gh.singleton<_i18.PlayersViewModel>(
      _i18.PlayersViewModel(get<_i12.PlayersStore>()));
  gh.singleton<_i19.PreferencesService>(_i19.PreferencesService());
  gh.singleton<_i20.RateAndReviewService>(
      _i20.RateAndReviewService(get<_i19.PreferencesService>()));
  gh.singleton<_i8.ScoreService>(_i8.ScoreService());
  gh.singleton<_i21.UserService>(_i21.UserService());
  gh.singleton<_i5.AnalyticsService>(_i5.AnalyticsService(
      get<_i16.FirebaseAnalytics>(), get<_i20.RateAndReviewService>()));
  gh.singleton<_i22.BoardGamesGeekService>(
      _i22.BoardGamesGeekService(get<_i3.CustomHttpClientAdapter>()));
  gh.singleton<_i13.BoardGamesService>(_i13.BoardGamesService(
      get<_i22.BoardGamesGeekService>(), get<_i19.PreferencesService>()));
  gh.singleton<_i23.PlaythroughService>(
      _i23.PlaythroughService(get<_i8.ScoreService>()));
  gh.singleton<_i11.PlaythroughStatisticsStore>(_i11.PlaythroughStatisticsStore(
      get<_i7.PlayerService>(),
      get<_i8.ScoreService>(),
      get<_i23.PlaythroughService>()));
  gh.singleton<_i9.PlaythroughsStore>(
      _i9.PlaythroughsStore(get<_i23.PlaythroughService>()));
  return get;
}

class _$RegisterModule extends _i24.RegisterModule {
  @override
  _i16.FirebaseAnalytics get firebaseAnalytics => _i16.FirebaseAnalytics();
}
