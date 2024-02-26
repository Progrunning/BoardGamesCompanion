import 'dart:io';
import 'dart:typed_data';

import 'package:fimber/fimber.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart';

import 'base_http_client.dart';

class CachingHttpClient extends BaseHttpClient {
  CachingHttpClient({
    required this.cacheManger,
    required super.innerHttpClient,
    required this.cacheDuration,
  });

  final CacheManager cacheManger;
  final Duration cacheDuration;

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) async {
    final cacheKey = url.toString();

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
}
