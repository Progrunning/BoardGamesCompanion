// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:firebase_analytics/firebase_analytics.dart' as _i6;
import 'package:firebase_analytics/observer.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'services/analytics_service.dart' as _i13;
import 'services/board_games_filters_service.dart' as _i4;
import 'services/board_games_geek_service.dart' as _i14;
import 'services/board_games_service.dart' as _i15;
import 'services/file_service.dart' as _i5;
import 'services/injectable_register_module.dart' as _i18;
import 'services/player_service.dart' as _i8;
import 'services/playthroughs_service.dart' as _i16;
import 'services/preferences_service.dart' as _i9;
import 'services/rate_and_review_service.dart' as _i10;
import 'services/score_service.dart' as _i11;
import 'services/user_service.dart' as _i12;
import 'stores/playthroughs_store.dart' as _i17;
import 'utilities/custom_http_client_adapter.dart'
    as _i3; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String environment, _i2.EnvironmentFilter environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.factory<_i3.CustomHttpClientAdapter>(() => _i3.CustomHttpClientAdapter());
  gh.singleton<_i4.BoardGamesFiltersService>(_i4.BoardGamesFiltersService());
  gh.singleton<_i5.FileService>(_i5.FileService());
  gh.singleton<_i6.FirebaseAnalytics>(registerModule.firebaseAnalytics);
  gh.singleton<_i7.FirebaseAnalyticsObserver>(
      registerModule.firebaseAnalyticsObserver);
  gh.singleton<_i8.PlayerService>(_i8.PlayerService(get<_i5.FileService>()));
  gh.singleton<_i9.PreferencesService>(_i9.PreferencesService());
  gh.singleton<_i10.RateAndReviewService>(
      _i10.RateAndReviewService(get<_i9.PreferencesService>()));
  gh.singleton<_i11.ScoreService>(_i11.ScoreService());
  gh.singleton<_i12.UserService>(_i12.UserService());
  gh.singleton<_i13.AnalyticsService>(_i13.AnalyticsService(
      get<_i6.FirebaseAnalytics>(), get<_i10.RateAndReviewService>()));
  gh.singleton<_i14.BoardGamesGeekService>(
      _i14.BoardGamesGeekService(get<_i3.CustomHttpClientAdapter>()));
  gh.singleton<_i15.BoardGamesService>(_i15.BoardGamesService(
      get<_i14.BoardGamesGeekService>(), get<_i9.PreferencesService>()));
  gh.singleton<_i16.PlaythroughService>(
      _i16.PlaythroughService(get<_i11.ScoreService>()));
  gh.singleton<_i17.PlaythroughsStore>(_i17.PlaythroughsStore(
      get<_i16.PlaythroughService>(), get<_i13.AnalyticsService>()));
  return get;
}

class _$RegisterModule extends _i18.RegisterModule {
  @override
  _i6.FirebaseAnalytics get firebaseAnalytics => _i6.FirebaseAnalytics();
}
