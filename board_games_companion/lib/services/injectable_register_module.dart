import 'package:board_games_companion/services/board_games_geek_service.dart';
import 'package:board_games_companion/utilities/caching_http_client.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_cache_manager/src/storage/file_system/file_system_io.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  static const String _gameDetailsCacheKey = 'bggGameDetails';
  static const Duration _gameDetailsCacheDuration = Duration(seconds: 30);
  // static const Duration _gameDetailsCacheDuration = Duration(hours: Duration.hoursPerDay * 7);
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
  BoardGamesGeekService get boardGameGeekService => BoardGamesGeekService(
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
        ),
      );
}
