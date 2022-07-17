// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:firebase_analytics/firebase_analytics.dart' as _i14;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'pages/players/players_view_model.dart' as _i8;
import 'pages/playthroughs/playthroughs_view_model.dart' as _i21;
import 'services/analytics_service.dart' as _i13;
import 'services/board_games_filters_service.dart' as _i3;
import 'services/board_games_geek_service.dart' as _i16;
import 'services/board_games_service.dart' as _i17;
import 'services/file_service.dart' as _i5;
import 'services/player_service.dart' as _i6;
import 'services/playthroughs_service.dart' as _i18;
import 'services/preferences_service.dart' as _i9;
import 'services/rate_and_review_service.dart' as _i10;
import 'services/score_service.dart' as _i11;
import 'services/user_service.dart' as _i12;
import 'stores/board_games_filters_store.dart' as _i15;
import 'stores/players_store.dart' as _i7;
import 'stores/playthrough_statistics_store.dart' as _i19;
import 'stores/playthrough_store.dart' as _i23;
import 'stores/playthroughs_store.dart' as _i20;
import 'utilities/analytics_route_observer.dart' as _i22;
import 'utilities/custom_http_client_adapter.dart'
    as _i4; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.singleton<_i3.BoardGamesFiltersService>(_i3.BoardGamesFiltersService());
  gh.factory<_i4.CustomHttpClientAdapter>(() => _i4.CustomHttpClientAdapter());
  gh.singleton<_i5.FileService>(_i5.FileService());
  gh.singleton<_i6.PlayerService>(_i6.PlayerService(get<_i5.FileService>()));
  gh.singleton<_i7.PlayersStore>(_i7.PlayersStore(get<_i6.PlayerService>()));
  gh.singleton<_i8.PlayersViewModel>(
      _i8.PlayersViewModel(get<_i7.PlayersStore>()));
  gh.singleton<_i9.PreferencesService>(_i9.PreferencesService());
  gh.singleton<_i10.RateAndReviewService>(
      _i10.RateAndReviewService(get<_i9.PreferencesService>()));
  gh.singleton<_i11.ScoreService>(_i11.ScoreService());
  gh.singleton<_i12.UserService>(_i12.UserService());
  gh.singleton<_i13.AnalyticsService>(_i13.AnalyticsService(
      get<_i14.FirebaseAnalytics>(), get<_i10.RateAndReviewService>()));
  gh.singleton<_i15.BoardGamesFiltersStore>(_i15.BoardGamesFiltersStore(
      get<_i3.BoardGamesFiltersService>(), get<_i13.AnalyticsService>()));
  gh.singleton<_i16.BoardGamesGeekService>(
      _i16.BoardGamesGeekService(get<_i4.CustomHttpClientAdapter>()));
  gh.singleton<_i17.BoardGamesService>(_i17.BoardGamesService(
      get<_i16.BoardGamesGeekService>(), get<_i9.PreferencesService>()));
  gh.singleton<_i18.PlaythroughService>(
      _i18.PlaythroughService(get<_i11.ScoreService>()));
  gh.singleton<_i19.PlaythroughStatisticsStore>(_i19.PlaythroughStatisticsStore(
      get<_i6.PlayerService>(),
      get<_i11.ScoreService>(),
      get<_i18.PlaythroughService>()));
  gh.singleton<_i20.PlaythroughsStore>(
      _i20.PlaythroughsStore(get<_i18.PlaythroughService>()));
  gh.factory<_i21.PlaythroughsViewModel>(() => _i21.PlaythroughsViewModel(
      get<_i20.PlaythroughsStore>(),
      get<_i19.PlaythroughStatisticsStore>(),
      get<_i7.PlayersStore>(),
      get<_i13.AnalyticsService>(),
      get<_i17.BoardGamesService>()));
  gh.factory<_i22.AnalyticsRouteObserver>(
      () => _i22.AnalyticsRouteObserver(get<_i13.AnalyticsService>()));
  gh.factory<_i23.PlaythroughStore>(() => _i23.PlaythroughStore(
      get<_i6.PlayerService>(),
      get<_i11.ScoreService>(),
      get<_i20.PlaythroughsStore>()));
  return get;
}
