// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:firebase_analytics/firebase_analytics.dart' as _i8;
import 'package:firebase_analytics/observer.dart' as _i9;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'pages/playthroughs/playthroughs_log_game_view_model.dart' as _i4;
import 'services/analytics_service.dart' as _i15;
import 'services/board_games_filters_service.dart' as _i6;
import 'services/board_games_geek_service.dart' as _i16;
import 'services/board_games_service.dart' as _i17;
import 'services/file_service.dart' as _i7;
import 'services/injectable_register_module.dart' as _i20;
import 'services/player_service.dart' as _i10;
import 'services/playthroughs_service.dart' as _i18;
import 'services/preferences_service.dart' as _i11;
import 'services/rate_and_review_service.dart' as _i12;
import 'services/score_service.dart' as _i13;
import 'services/user_service.dart' as _i14;
import 'stores/players_store.dart' as _i5;
import 'stores/playthroughs_store.dart' as _i19;
import 'utilities/custom_http_client_adapter.dart'
    as _i3; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String environment, _i2.EnvironmentFilter environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.factory<_i3.CustomHttpClientAdapter>(() => _i3.CustomHttpClientAdapter());
  gh.factory<_i4.PlaythroughsLogGameViewModel>(
      () => _i4.PlaythroughsLogGameViewModel(get<_i5.PlayersStore>()));
  gh.singleton<_i6.BoardGamesFiltersService>(_i6.BoardGamesFiltersService());
  gh.singleton<_i7.FileService>(_i7.FileService());
  gh.singleton<_i8.FirebaseAnalytics>(registerModule.firebaseAnalytics);
  gh.singleton<_i9.FirebaseAnalyticsObserver>(
      registerModule.firebaseAnalyticsObserver);
  gh.singleton<_i10.PlayerService>(_i10.PlayerService(get<_i7.FileService>()));
  gh.singleton<_i5.PlayersStore>(_i5.PlayersStore(get<_i10.PlayerService>()));
  gh.singleton<_i11.PreferencesService>(_i11.PreferencesService());
  gh.singleton<_i12.RateAndReviewService>(
      _i12.RateAndReviewService(get<_i11.PreferencesService>()));
  gh.singleton<_i13.ScoreService>(_i13.ScoreService());
  gh.singleton<_i14.UserService>(_i14.UserService());
  gh.singleton<_i15.AnalyticsService>(_i15.AnalyticsService(
      get<_i8.FirebaseAnalytics>(), get<_i12.RateAndReviewService>()));
  gh.singleton<_i16.BoardGamesGeekService>(
      _i16.BoardGamesGeekService(get<_i3.CustomHttpClientAdapter>()));
  gh.singleton<_i17.BoardGamesService>(_i17.BoardGamesService(
      get<_i16.BoardGamesGeekService>(), get<_i11.PreferencesService>()));
  gh.singleton<_i18.PlaythroughService>(
      _i18.PlaythroughService(get<_i13.ScoreService>()));
  gh.singleton<_i19.PlaythroughsStore>(_i19.PlaythroughsStore(
      get<_i18.PlaythroughService>(), get<_i15.AnalyticsService>()));
  return get;
}

class _$RegisterModule extends _i20.RegisterModule {
  @override
  _i8.FirebaseAnalytics get firebaseAnalytics => _i8.FirebaseAnalytics();
}
