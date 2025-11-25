/// HTTP API 클라이언트 인터페이스
/// Dio를 사용한 REST API 통신 추상 클래스
library;

import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

import '../core/utils/notion_environment.dart';
import '../services/credentials/service.dart';
import 'model/response.dart';

/// API 프로바이더 추상 클래스
/// Notion API와의 통신을 담당
abstract class ApiProvider {
  late final Dio dio;
  final CredentialsService credentialsService;

  ApiProvider({CredentialsService? credentialsService, String? baseUrl})
    : credentialsService =
          credentialsService ?? Get.find<CredentialsService>() {
    final String resolvedBaseUrl =
        (baseUrl ?? NotionEnvironment.apiBaseUrl).trim();
    if (resolvedBaseUrl.isEmpty) {
      throw StateError('BASE_URL is not configured in .env');
    }
    dio = Dio(
      BaseOptions(
        baseUrl: resolvedBaseUrl,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Notion-Version': '2022-02-22',
        },
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final String? apiKey = this.credentialsService.notionApiKey;
          if (apiKey == null || apiKey.isEmpty) {
            handler.reject(
              DioException(
                requestOptions: options,
                error: 'NOTION_API_KEY_MISSING',
                message: 'Notion API key is not configured.',
                type: DioExceptionType.unknown,
              ),
            );
            return;
          }
          options.headers['Authorization'] = 'Bearer $apiKey';
          handler.next(options);
        },
      ),
    );
  }

  /// GET 요청 수행
  Future<CustomHttpResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Response dioResponse = await dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
    return CustomHttpResponse.fromDioResponse(dioResponse);
  }

  /// 스트림 GET 요청 (SSE 지원)
  Future<Stream<Map<String, dynamic>>> getStream(String path) async {
    Response<ResponseBody> dioResponse = await dio.get(
      path,
      options: Options(
        headers: {"Accept": "text/event-stream"},
        responseType: ResponseType.stream,
      ),
    );
    return dioResponse.data!.stream.transform(
      StreamTransformer.fromHandlers(
        handleData: (rawdata, sink) {
          String strData = String.fromCharCodes(rawdata);
          String formatedData = strData.substring(
            strData.indexOf('{'),
            strData.indexOf('}') + 1,
          );
          Map<String, dynamic> data = json.decode(formatedData);

          sink.add(data);
        },
      ),
    );
  }

  /// DELETE 요청 수행
  Future<CustomHttpResponse> delete(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    Response dioResponse = await dio.delete(path, data: data, options: options);
    return CustomHttpResponse.fromDioResponse(dioResponse);
  }

  /// POST 요청 수행
  Future<CustomHttpResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Response dioResponse = await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
    return CustomHttpResponse.fromDioResponse(dioResponse);
  }

  /// PATCH 요청 수행
  Future<CustomHttpResponse> patch(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    Response dioResponse = await dio.patch(path, data: data, options: options);
    return CustomHttpResponse.fromDioResponse(dioResponse);
  }

  /// PUT 요청 수행
  Future<CustomHttpResponse> put(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    Response dioResponse = await dio.put(path, data: data, options: options);
    return CustomHttpResponse.fromDioResponse(dioResponse);
  }
}
