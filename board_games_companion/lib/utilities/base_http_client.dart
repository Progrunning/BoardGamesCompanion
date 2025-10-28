import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class BaseHttpClient extends BaseClient {
  BaseHttpClient({
    required this.innerHttpClient,
    this.headers = const {},
  });

  var headers = <String, String>{};

  @protected
  final Client innerHttpClient;

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    Fimber.i('[HTTP] Sending a request ${request.url.toString()}.');
    request.headers.addAll(headers);
    return innerHttpClient.send(request);
  }
}
