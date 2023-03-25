// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:board_games_companion/pages/board_game_details/board_game_details_view_model.dart'
    as _i41;
import 'package:board_games_companion/pages/collections/collection_search_result_view_model.dart'
    as _i28;
import 'package:board_games_companion/pages/collections/collections_view_model.dart'
    as _i29;
import 'package:board_games_companion/pages/create_board_game/create_board_game_view_model.dart'
    as _i30;
import 'package:board_games_companion/pages/edit_playthrough/edit_playthrough_view_model.dart'
    as _i42;
import 'package:board_games_companion/pages/edit_playthrough/playthrough_note_view_model.dart'
    as _i34;
import 'package:board_games_companion/pages/home/home_view_model.dart' as _i43;
import 'package:board_games_companion/pages/hot_board_games/hot_board_games_view_model.dart'
    as _i32;
import 'package:board_games_companion/pages/player/player_view_model.dart'
    as _i23;
import 'package:board_games_companion/pages/players/players_view_model.dart'
    as _i10;
import 'package:board_games_companion/pages/plays/plays_view_model.dart'
    as _i33;
import 'package:board_games_companion/pages/playthroughs/playthrough_statistics_view_model.dart'
    as _i35;
import 'package:board_games_companion/pages/playthroughs/playthroughs_game_settings_view_model.dart'
    as _i36;
import 'package:board_games_companion/pages/playthroughs/playthroughs_history_view_model.dart'
    as _i37;
import 'package:board_games_companion/pages/playthroughs/playthroughs_log_game_view_model.dart'
    as _i38;
import 'package:board_games_companion/pages/playthroughs/playthroughs_view_model.dart'
    as _i39;
import 'package:board_games_companion/pages/settings/settings_view_model.dart'
    as _i40;
import 'package:board_games_companion/services/analytics_service.dart' as _i19;
import 'package:board_games_companion/services/board_games_filters_service.dart'
    as _i4;
import 'package:board_games_companion/services/board_games_geek_service.dart'
    as _i21;
import 'package:board_games_companion/services/board_games_service.dart'
    as _i22;
import 'package:board_games_companion/services/file_service.dart' as _i6;
import 'package:board_games_companion/services/player_service.dart' as _i8;
import 'package:board_games_companion/services/playthroughs_service.dart'
    as _i24;
import 'package:board_games_companion/services/preferences_service.dart'
    as _i11;
import 'package:board_games_companion/services/rate_and_review_service.dart'
    as _i12;
import 'package:board_games_companion/services/score_service.dart' as _i13;
import 'package:board_games_companion/services/search_service.dart' as _i15;
import 'package:board_games_companion/services/user_service.dart' as _i17;
import 'package:board_games_companion/stores/app_store.dart' as _i3;
import 'package:board_games_companion/stores/board_games_filters_store.dart'
    as _i20;
import 'package:board_games_companion/stores/board_games_store.dart' as _i27;
import 'package:board_games_companion/stores/game_playthroughs_details_store.dart'
    as _i31;
import 'package:board_games_companion/stores/players_store.dart' as _i9;
import 'package:board_games_companion/stores/playthroughs_store.dart' as _i25;
import 'package:board_games_companion/stores/scores_store.dart' as _i14;
import 'package:board_games_companion/stores/search_store.dart' as _i16;
import 'package:board_games_companion/stores/user_store.dart' as _i18;
import 'package:board_games_companion/utilities/analytics_route_observer.dart'
    as _i26;
import 'package:board_games_companion/utilities/custom_http_client_adapter.dart'
    as _i5;
import 'package:firebase_analytics/firebase_analytics.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'services/injectable_register_module.dart' as _i44;

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  gh.singleton<_i3.AppStore>(_i3.AppStore());
  gh.singleton<_i4.BoardGamesFiltersService>(_i4.BoardGamesFiltersService());
  gh.factory<_i5.CustomHttpClientAdapter>(() => _i5.CustomHttpClientAdapter());
  gh.singleton<_i6.FileService>(_i6.FileService());
  gh.singleton<_i7.FirebaseAnalytics>(registerModule.firebaseAnalytics);
  gh.singleton<_i7.FirebaseAnalyticsObserver>(
      registerModule.firebaseAnalyticsObserver);
  gh.singleton<_i8.PlayerService>(_i8.PlayerService(gh<_i6.FileService>()));
  gh.singleton<_i9.PlayersStore>(_i9.PlayersStore(gh<_i8.PlayerService>()));
  gh.factory<_i10.PlayersViewModel>(
      () => _i10.PlayersViewModel(gh<_i9.PlayersStore>()));
  gh.singleton<_i11.PreferencesService>(_i11.PreferencesService());
  gh.singleton<_i12.RateAndReviewService>(
      _i12.RateAndReviewService(gh<_i11.PreferencesService>()));
  gh.singleton<_i13.ScoreService>(_i13.ScoreService());
  gh.singleton<_i14.ScoresStore>(_i14.ScoresStore(gh<_i13.ScoreService>()));
  gh.singleton<_i15.SearchService>(_i15.SearchService());
  gh.singleton<_i16.SearchStore>(_i16.SearchStore(gh<_i15.SearchService>()));
  gh.singleton<_i17.UserService>(_i17.UserService());
  gh.singleton<_i18.UserStore>(_i18.UserStore(gh<_i17.UserService>()));
  gh.singleton<_i19.AnalyticsService>(_i19.AnalyticsService(
    gh<_i7.FirebaseAnalytics>(),
    gh<_i12.RateAndReviewService>(),
  ));
  gh.singleton<_i20.BoardGamesFiltersStore>(_i20.BoardGamesFiltersStore(
    gh<_i4.BoardGamesFiltersService>(),
    gh<_i19.AnalyticsService>(),
  ));
  gh.singleton<_i21.BoardGamesGeekService>(
      _i21.BoardGamesGeekService(gh<_i5.CustomHttpClientAdapter>()));
  gh.singleton<_i22.BoardGamesService>(
      _i22.BoardGamesService(gh<_i21.BoardGamesGeekService>()));
  gh.factory<_i23.PlayerViewModel>(
      () => _i23.PlayerViewModel(gh<_i9.PlayersStore>()));
  gh.singleton<_i24.PlaythroughService>(
      _i24.PlaythroughService(gh<_i13.ScoreService>()));
  gh.singleton<_i25.PlaythroughsStore>(_i25.PlaythroughsStore(
    gh<_i24.PlaythroughService>(),
    gh<_i14.ScoresStore>(),
  ));
  gh.factory<_i26.AnalyticsRouteObserver>(
      () => _i26.AnalyticsRouteObserver(gh<_i19.AnalyticsService>()));
  gh.singleton<_i27.BoardGamesStore>(_i27.BoardGamesStore(
    gh<_i22.BoardGamesService>(),
    gh<_i24.PlaythroughService>(),
  ));
  gh.factory<_i28.CollectionSearchResultViewModel>(
      () => _i28.CollectionSearchResultViewModel(gh<_i27.BoardGamesStore>()));
  gh.factory<_i29.CollectionsViewModel>(() => _i29.CollectionsViewModel(
        gh<_i18.UserStore>(),
        gh<_i27.BoardGamesStore>(),
        gh<_i20.BoardGamesFiltersStore>(),
        gh<_i14.ScoresStore>(),
        gh<_i25.PlaythroughsStore>(),
        gh<_i9.PlayersStore>(),
      ));
  gh.factory<_i30.CreateBoardGameViewModel>(() => _i30.CreateBoardGameViewModel(
        gh<_i27.BoardGamesStore>(),
        gh<_i6.FileService>(),
      ));
  gh.singleton<_i31.GamePlaythroughsDetailsStore>(
      _i31.GamePlaythroughsDetailsStore(
    gh<_i25.PlaythroughsStore>(),
    gh<_i14.ScoresStore>(),
    gh<_i9.PlayersStore>(),
    gh<_i27.BoardGamesStore>(),
  ));
  gh.singleton<_i32.HotBoardGamesViewModel>(_i32.HotBoardGamesViewModel(
    gh<_i27.BoardGamesStore>(),
    gh<_i21.BoardGamesGeekService>(),
    gh<_i19.AnalyticsService>(),
  ));
  gh.factory<_i33.PlaysViewModel>(() => _i33.PlaysViewModel(
        gh<_i25.PlaythroughsStore>(),
        gh<_i27.BoardGamesStore>(),
        gh<_i9.PlayersStore>(),
        gh<_i14.ScoresStore>(),
        gh<_i19.AnalyticsService>(),
      ));
  gh.factory<_i34.PlaythroughNoteViewModel>(() =>
      _i34.PlaythroughNoteViewModel(gh<_i31.GamePlaythroughsDetailsStore>()));
  gh.singleton<_i35.PlaythroughStatisticsViewModel>(
      _i35.PlaythroughStatisticsViewModel(
    gh<_i8.PlayerService>(),
    gh<_i14.ScoresStore>(),
    gh<_i31.GamePlaythroughsDetailsStore>(),
  ));
  gh.factory<_i36.PlaythroughsGameSettingsViewModel>(
      () => _i36.PlaythroughsGameSettingsViewModel(
            gh<_i27.BoardGamesStore>(),
            gh<_i31.GamePlaythroughsDetailsStore>(),
          ));
  gh.factory<_i37.PlaythroughsHistoryViewModel>(() =>
      _i37.PlaythroughsHistoryViewModel(
          gh<_i31.GamePlaythroughsDetailsStore>()));
  gh.factory<_i38.PlaythroughsLogGameViewModel>(
      () => _i38.PlaythroughsLogGameViewModel(
            gh<_i9.PlayersStore>(),
            gh<_i31.GamePlaythroughsDetailsStore>(),
            gh<_i19.AnalyticsService>(),
          ));
  gh.factory<_i39.PlaythroughsViewModel>(() => _i39.PlaythroughsViewModel(
        gh<_i31.GamePlaythroughsDetailsStore>(),
        gh<_i9.PlayersStore>(),
        gh<_i19.AnalyticsService>(),
        gh<_i22.BoardGamesService>(),
        gh<_i18.UserStore>(),
      ));
  gh.singleton<_i40.SettingsViewModel>(_i40.SettingsViewModel(
    gh<_i6.FileService>(),
    gh<_i22.BoardGamesService>(),
    gh<_i4.BoardGamesFiltersService>(),
    gh<_i8.PlayerService>(),
    gh<_i17.UserService>(),
    gh<_i24.PlaythroughService>(),
    gh<_i13.ScoreService>(),
    gh<_i11.PreferencesService>(),
    gh<_i3.AppStore>(),
    gh<_i18.UserStore>(),
    gh<_i27.BoardGamesStore>(),
  ));
  gh.factory<_i41.BoardGameDetailsViewModel>(
      () => _i41.BoardGameDetailsViewModel(
            gh<_i27.BoardGamesStore>(),
            gh<_i19.AnalyticsService>(),
          ));
  gh.factory<_i42.EditPlaythoughViewModel>(() =>
      _i42.EditPlaythoughViewModel(gh<_i31.GamePlaythroughsDetailsStore>()));
  gh.factory<_i43.HomeViewModel>(() => _i43.HomeViewModel(
        gh<_i19.AnalyticsService>(),
        gh<_i12.RateAndReviewService>(),
        gh<_i10.PlayersViewModel>(),
        gh<_i20.BoardGamesFiltersStore>(),
        gh<_i29.CollectionsViewModel>(),
        gh<_i32.HotBoardGamesViewModel>(),
        gh<_i33.PlaysViewModel>(),
        gh<_i3.AppStore>(),
        gh<_i16.SearchStore>(),
        gh<_i27.BoardGamesStore>(),
        gh<_i21.BoardGamesGeekService>(),
      ));
  return getIt;
}

class _$RegisterModule extends _i44.RegisterModule {}
