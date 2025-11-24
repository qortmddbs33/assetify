/// HTTP 요청/응답 로깅 인터셉터
/// 디버깅용 네트워크 로그 출력

import 'package:dio/dio.dart';
import 'dart:developer' as dev;

/// Dio 로그 인터셉터
/// 성공/실패 응답을 개발자 콘솔에 출력
class LogInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    dev.log('${response.requestOptions.method}[${response.statusCode}] => PATH: ${response.requestOptions.path}', name: 'DIO');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      dev.log('${err.response!.requestOptions.method}[${err.response!.statusCode}] => PATH: ${err.response!.requestOptions.path}', name: 'DIO');
      dev.log('${err.response!.data}');
    }
    handler.next(err);
  }
}