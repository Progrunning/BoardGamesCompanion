import 'package:board_games_companion/services/board_games_geek_service.dart';
import 'package:board_games_companion/utilities/base_http_client.dart';
import 'package:board_games_companion/utilities/caching_http_client.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';

import 'environment_service.dart';

@module
abstract class RegisterModule {
  static const String _gameDetailsCacheKey = 'bggGameDetails';
  static const Duration _gameDetailsCacheDuration = Duration(hours: Duration.hoursPerDay * 7);
  static const String _hotGamesCacheKey = 'bggHotGames';
  static const Duration _hotGamesCacheDuration = Duration(hours: Duration.hoursPerDay);

  @singleton
  FirebaseAnalytics get firebaseAnalytics => FirebaseAnalytics.instance;

  @injectable
  HiveInterface get hive => Hive;

  @singleton
  FirebaseAnalyticsObserver get firebaseAnalyticsObserver =>
      FirebaseAnalyticsObserver(analytics: firebaseAnalytics);

  @singleton
  EnvironmentService get environmentService => EnvironmentService();

  @singleton
  BoardGamesGeekService get boardGameGeekService {
    final headers = <String, String>{
      'Authorization': 'Bearer ${environmentService.bggApiKey}',
    };
    return BoardGamesGeekService(
      gameDetailsCachingHttpClient: CachingHttpClient(
        cacheManger: CacheManager(
          Config(
            _gameDetailsCacheKey,
            stalePeriod: _gameDetailsCacheDuration,
            maxNrOfCacheObjects: 100,
            repo: JsonCacheInfoRepository(databaseName: _gameDetailsCacheKey),
            fileSystem: IOFileSystem(_gameDetailsCacheKey),
            fileService: HttpFileService(),
          ),
        ),
        innerHttpClient: Client(),
        cacheDuration: _gameDetailsCacheDuration,
        headers: headers,
      ),
      hotGamesCachingHttpClient: CachingHttpClient(
        cacheManger: CacheManager(
          Config(
            _hotGamesCacheKey,
            stalePeriod: _hotGamesCacheDuration,
            maxNrOfCacheObjects: 1,
            repo: JsonCacheInfoRepository(databaseName: _hotGamesCacheKey),
            fileSystem: IOFileSystem(_hotGamesCacheKey),
            fileService: HttpFileService(),
          ),
        ),
        innerHttpClient: Client(),
        cacheDuration: _hotGamesCacheDuration,
        headers: headers,
      ),
      baseHttpClient: BaseHttpClient(
        innerHttpClient: Client(),
        headers: headers,
      ),
    );
  }
}
