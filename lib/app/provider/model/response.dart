/// HTTP 응답 모델
/// Dio 응답을 래핑한 커스텀 응답 클래스

import 'package:dio/dio.dart';

/// 커스텀 HTTP 응답 클래스
/// API 응답 데이터를 일관된 형태로 제공
class CustomHttpResponse {
  dynamic data; // 응답 데이터

  CustomHttpResponse({
    this.data,
  });

  /// Dio 응답을 CustomHttpResponse로 변환
  factory CustomHttpResponse.fromDioResponse(Response dioResponse) =>
      CustomHttpResponse(
        data: dioResponse.data,
      );
}