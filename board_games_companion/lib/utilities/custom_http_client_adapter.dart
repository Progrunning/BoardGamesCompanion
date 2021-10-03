import 'dart:async';
import 'dart:typed_data';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@injectable
class CustomHttpClientAdapter extends HttpClientAdapter {
  final _adapter = DefaultHttpClientAdapter();
  final log = Logger(
    printer: PrettyPrinter(),
  );

  @override
  void close({bool force = false}) {
    _adapter.close(force: force);
  }

  @override
  Future<ResponseBody> fetch(
      RequestOptions options, Stream<Uint8List> requestStream, Future cancelFuture) async {
    log.d('[HTTP] Request ${options?.uri}...');
    final response = await _adapter.fetch(options, requestStream, cancelFuture);
    log.d('[HTTP] Response ${response?.statusCode}');
    return response;
  }
}
