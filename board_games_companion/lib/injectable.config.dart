// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:firebase_analytics/firebase_analytics.dart' as _i13;
import 'package:firebase_analytics/observer.dart' as _i14;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'pages/playthroughs/playthroughs_log_game_view_model.dart' as _i8;
import 'services/analytics_service.dart' as _i10;
import 'services/board_games_filters_service.dart' as _i11;
import 'services/board_games_geek_service.dart' as _i18;
import 'services/board_games_service.dart' as _i19;
import 'services/file_service.dart' as _i12;
import 'services/injectable_register_module.dart' as _i21;
import 'services/player_service.dart' as _i5;
import 'services/playthroughs_service.dart' as _i20;
import 'services/preferences_service.dart' as _i15;
import 'services/rate_and_review_service.dart' as _i16;
import 'services/score_service.dart' as _i6;
import 'services/user_service.dart' as _i17;
import 'stores/players_store.dart' as _i9;
import 'stores/playthrough_store.dart' as _i4;
import 'stores/playthroughs_store.dart' as _i7;
import 'utilities/custom_http_client_adapter.dart'
    as _i3; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.factory<_i3.CustomHttpClientAdapter>(() => _i3.CustomHttpClientAdapter());
  gh.factory<_i4.PlaythroughStore>(() => _i4.PlaythroughStore(
      get<_i5.PlayerService>(),
      get<_i6.ScoreService>(),
      get<_i7.PlaythroughsStore>()));
  gh.factory<_i8.PlaythroughsLogGameViewModel>(() =>
      _i8.PlaythroughsLogGameViewModel(get<_i9.PlayersStore>(),
          get<_i7.PlaythroughsStore>(), get<_i10.AnalyticsService>()));
  gh.singleton<_i11.BoardGamesFiltersService>(_i11.BoardGamesFiltersService());
  gh.singleton<_i12.FileService>(_i12.FileService());
  gh.singleton<_i13.FirebaseAnalytics>(registerModule.firebaseAnalytics);
  gh.singleton<_i14.FirebaseAnalyticsObserver>(
      registerModule.firebaseAnalyticsObserver);
  gh.singleton<_i5.PlayerService>(_i5.PlayerService(get<_i12.FileService>()));
  gh.singleton<_i9.PlayersStore>(_i9.PlayersStore(get<_i5.PlayerService>()));
  gh.singleton<_i15.PreferencesService>(_i15.PreferencesService());
  gh.singleton<_i16.RateAndReviewService>(
      _i16.RateAndReviewService(get<_i15.PreferencesService>()));
  gh.singleton<_i6.ScoreService>(_i6.ScoreService());
  gh.singleton<_i17.UserService>(_i17.UserService());
  gh.singleton<_i10.AnalyticsService>(_i10.AnalyticsService(
      get<_i13.FirebaseAnalytics>(), get<_i16.RateAndReviewService>()));
  gh.singleton<_i18.BoardGamesGeekService>(
      _i18.BoardGamesGeekService(get<_i3.CustomHttpClientAdapter>()));
  gh.singleton<_i19.BoardGamesService>(_i19.BoardGamesService(
      get<_i18.BoardGamesGeekService>(), get<_i15.PreferencesService>()));
  gh.singleton<_i20.PlaythroughService>(
      _i20.PlaythroughService(get<_i6.ScoreService>()));
  gh.singleton<_i7.PlaythroughsStore>(_i7.PlaythroughsStore(
      get<_i20.PlaythroughService>(), get<_i10.AnalyticsService>()));
  return get;
}

class _$RegisterModule extends _i21.RegisterModule {
  @override
  _i13.FirebaseAnalytics get firebaseAnalytics => _i13.FirebaseAnalytics();
}
