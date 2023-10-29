import 'dart:io';

import 'package:fimber/fimber.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart';

class CachingHttpClient extends BaseClient {
  CachingHttpClient({
    required this.cacheManger,
    required this.innerHttpClient,
    required this.cacheDuration,
  });

  final CacheManager cacheManger;
  final Client innerHttpClient;
  final Duration cacheDuration;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final cacheKey = request.url.toString();

    Fimber.i('[HTTP] Retrieving data from $cacheKey.');

    final cachedResponseStream = await _getCachedResponseStream(cacheKey);
    if (cachedResponseStream != null) {
      Fimber.i('[HTTP] Cached response found');
      return StreamedResponse(cachedResponseStream, HttpStatus.ok);
    }

    Fimber.i('[HTTP] Sending request...');
    final streamedResponse = await innerHttpClient.send(request);
    Fimber.i('[HTTP] Response retrieved with status code ${streamedResponse.statusCode}');

    if (streamedResponse.statusCode == HttpStatus.ok) {
      Fimber.i(
        '[HTTP] Caching response until ${DateTime.now().add(cacheDuration).toIso8601String()}',
      );
      await cacheManger.putFileStream(cacheKey, streamedResponse.stream);
      Fimber.i('[HTTP] Response cached');
    }

    // "Copying" of the [StreamedResponse] is done here because the [StreamedResponse.stream]
    // can be only listend to once and we're doing it when caching the response.
    // If we didn't create a new stream (like below from cache) we would ran into an exception.
    // TODO Consider caching the data in the API service and make this only "cache" aware client
    return StreamedResponse(
      await _getCachedResponseStream(cacheKey) ?? const Stream.empty(),
      streamedResponse.statusCode,
      contentLength: streamedResponse.contentLength,
      headers: streamedResponse.headers,
      isRedirect: streamedResponse.isRedirect,
      persistentConnection: streamedResponse.persistentConnection,
      reasonPhrase: streamedResponse.reasonPhrase,
      request: streamedResponse.request,
    );
  }

  Future<Stream<List<int>>?> _getCachedResponseStream(String cacheKey) async {
    final cachedResponse = await cacheManger.getFileFromCache(cacheKey);

    return cachedResponse?.file.openRead();
  }
}
