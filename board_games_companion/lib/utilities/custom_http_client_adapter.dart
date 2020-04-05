import 'dart:async';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'package:logging/logging.dart';

class CustomHttpClientAdapter extends HttpClientAdapter {
  final _adapter = DefaultHttpClientAdapter();
  final log = Logger('HTTP');

  @override
  void close({bool force = false}) {
    _adapter.close(force: force);
  }

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<List<int>> requestStream, Future cancelFuture) async {
    log.fine('[HTTP] Request ${options?.uri}...');
    final response = await _adapter.fetch(options, requestStream, cancelFuture);
    log.fine('[HTTP] Response ${response?.statusCode}');
    return response;
  }
}
