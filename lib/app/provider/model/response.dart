import 'package:dio/dio.dart';

class CustomHttpResponse {
  dynamic data;

  CustomHttpResponse({
    this.data,
  });

  factory CustomHttpResponse.fromDioResponse(Response dioResponse) =>
      CustomHttpResponse(
        data: dioResponse.data,
      );
}