import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    @required this.dio,
    this.retryNumber = 5,
  });

  static const int _retryStatusCode = 202;
  static const Duration _retryInterval = Duration(milliseconds: 500);

  final Dio dio;
  int retryNumber;
  int retriesCount = 0;

  @override
  Future<dynamic> onResponse(Response<dynamic> response) async {
    if (response.statusCode == _retryStatusCode && retriesCount < retryNumber) {
      await Future<dynamic>.delayed(_retryInterval * retriesCount);
      retriesCount++;
      return dio.request<dynamic>(
        response.request.path,
        cancelToken: response.request.cancelToken,
        data: response.request.data,
        onReceiveProgress: response.request.onReceiveProgress,
        onSendProgress: response.request.onSendProgress,
        queryParameters: response.request.queryParameters,
        options: response.request,
      );
    }

    return super.onResponse(response);
  }
}
