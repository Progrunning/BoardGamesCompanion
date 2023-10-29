import 'dart:io';
import 'dart:typed_data';

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
  Future<Response> get(Uri url, {Map<String, String>? headers}) async {
    final cacheKey = url.toString();

    Fimber.i('[HTTP] Retrieving data from $url.');

    final cachedResponseBody = await _getCachedResponse(cacheKey);
    if (cachedResponseBody != null) {
      Fimber.i('[HTTP] Cached response found');
      return Response.bytes(cachedResponseBody, HttpStatus.ok);
    }

    Fimber.i('[HTTP] Sending request...');
    final response = await super.get(url);
    Fimber.i('[HTTP] Response retrieved with status code ${response.statusCode}');

    if (response.statusCode == HttpStatus.ok) {
      Fimber.i(
        '[HTTP] Caching response until ${DateTime.now().add(cacheDuration).toIso8601String()}',
      );
      await cacheManger.putFile(cacheKey, response.bodyBytes);
      Fimber.i('[HTTP] Response cached');
    }

    return response;
  }

  Future<Uint8List?> _getCachedResponse(String cacheKey) async {
    final cachedResponse = await cacheManger.getFileFromCache(cacheKey);

    return await cachedResponse?.file.readAsBytes();
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    return innerHttpClient.send(request);
  }
}
