import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

class RetryInterceptor extends Interceptor {
  static const int _retryStatusCode = 202;
  static const int _retryNumber = 5;
  static const Duration _retryInterval = const Duration(milliseconds: 500);

  RetryInterceptor({
    @required this.dio,
    this.retryNumber = _retryNumber,
  });

  final Dio dio;
  int retryNumber;
  int retriesCount = 0;

  @override
  Future onResponse(Response response) async {
    if (response.statusCode == _retryStatusCode && retriesCount < retryNumber) {
      await Future.delayed(_retryInterval * retriesCount);
      retriesCount++;
      return await this.dio.request(
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

  @override
  onError(DioError err) async {
    return super.onError(err);
  }
}
