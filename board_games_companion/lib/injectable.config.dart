// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:firebase_analytics/firebase_analytics.dart' as _i16;
import 'package:firebase_analytics/observer.dart' as _i17;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'pages/players/players_view_model.dart' as _i18;
import 'pages/playthroughs/playthroughs_view_model.dart' as _i4;
import 'services/analytics_service.dart' as _i8;
import 'services/board_games_filters_service.dart' as _i14;
import 'services/board_games_geek_service.dart' as _i23;
import 'services/board_games_service.dart' as _i9;
import 'services/file_service.dart' as _i15;
import 'services/injectable_register_module.dart' as _i25;
import 'services/player_service.dart' as _i12;
import 'services/playthroughs_service.dart' as _i24;
import 'services/preferences_service.dart' as _i19;
import 'services/rate_and_review_service.dart' as _i20;
import 'services/score_service.dart' as _i13;
import 'services/user_service.dart' as _i21;
import 'stores/board_games_filters_store.dart' as _i22;
import 'stores/players_store.dart' as _i7;
import 'stores/playthrough_statistics_store.dart' as _i6;
import 'stores/playthrough_store.dart' as _i11;
import 'stores/playthroughs_store.dart' as _i5;
import 'utilities/analytics_route_observer.dart' as _i10;
import 'utilities/custom_http_client_adapter.dart'
    as _i3; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.factory<_i3.CustomHttpClientAdapter>(() => _i3.CustomHttpClientAdapter());
  gh.factory<_i4.PlaythroughsViewModel>(() => _i4.PlaythroughsViewModel(
      get<_i5.PlaythroughsStore>(),
      get<_i6.PlaythroughStatisticsStore>(),
      get<_i7.PlayersStore>(),
      get<_i8.AnalyticsService>(),
      get<_i9.BoardGamesService>()));
  gh.factory<_i10.AnalyticsRouteObserver>(
      () => _i10.AnalyticsRouteObserver(get<_i8.AnalyticsService>()));
  gh.factory<_i11.PlaythroughStore>(() => _i11.PlaythroughStore(
      get<_i12.PlayerService>(),
      get<_i13.ScoreService>(),
      get<_i5.PlaythroughsStore>()));
  gh.singleton<_i14.BoardGamesFiltersService>(_i14.BoardGamesFiltersService());
  gh.singleton<_i15.FileService>(_i15.FileService());
  gh.singleton<_i16.FirebaseAnalytics>(registerModule.firebaseAnalytics);
  gh.singleton<_i17.FirebaseAnalyticsObserver>(
      registerModule.firebaseAnalyticsObserver);
  gh.singleton<_i12.PlayerService>(_i12.PlayerService(get<_i15.FileService>()));
  gh.singleton<_i7.PlayersStore>(_i7.PlayersStore(get<_i12.PlayerService>()));
  gh.singleton<_i18.PlayersViewModel>(
      _i18.PlayersViewModel(get<_i7.PlayersStore>()));
  gh.singleton<_i19.PreferencesService>(_i19.PreferencesService());
  gh.singleton<_i20.RateAndReviewService>(
      _i20.RateAndReviewService(get<_i19.PreferencesService>()));
  gh.singleton<_i13.ScoreService>(_i13.ScoreService());
  gh.singleton<_i21.UserService>(_i21.UserService());
  gh.singleton<_i8.AnalyticsService>(_i8.AnalyticsService(
      get<_i16.FirebaseAnalytics>(), get<_i20.RateAndReviewService>()));
  gh.singleton<_i22.BoardGamesFiltersStore>(_i22.BoardGamesFiltersStore(
      get<_i14.BoardGamesFiltersService>(), get<_i8.AnalyticsService>()));
  gh.singleton<_i23.BoardGamesGeekService>(
      _i23.BoardGamesGeekService(get<_i3.CustomHttpClientAdapter>()));
  gh.singleton<_i9.BoardGamesService>(_i9.BoardGamesService(
      get<_i23.BoardGamesGeekService>(), get<_i19.PreferencesService>()));
  gh.singleton<_i24.PlaythroughService>(
      _i24.PlaythroughService(get<_i13.ScoreService>()));
  gh.singleton<_i6.PlaythroughStatisticsStore>(_i6.PlaythroughStatisticsStore(
      get<_i12.PlayerService>(),
      get<_i13.ScoreService>(),
      get<_i24.PlaythroughService>()));
  gh.singleton<_i5.PlaythroughsStore>(
      _i5.PlaythroughsStore(get<_i24.PlaythroughService>()));
  return get;
}

class _$RegisterModule extends _i25.RegisterModule {
  @override
  _i16.FirebaseAnalytics get firebaseAnalytics => _i16.FirebaseAnalytics();
}
