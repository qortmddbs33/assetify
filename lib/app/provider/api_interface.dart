import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

import '../core/utils/notion_environment.dart';
import '../services/credentials/service.dart';
import 'model/response.dart';

abstract class ApiProvider {
  late final Dio dio;
  final CredentialsService credentialsService;

  ApiProvider({CredentialsService? credentialsService, String? baseUrl})
    : credentialsService =
          credentialsService ?? Get.find<CredentialsService>() {
    final String resolvedBaseUrl =
        (baseUrl ?? NotionEnvironment.apiBaseUrl).trim();
    if (resolvedBaseUrl.isEmpty) {
      throw StateError('NOTION_API_BASE_URL is not configured in .env');
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

  Future<CustomHttpResponse> delete(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    Response dioResponse = await dio.delete(path, data: data, options: options);
    return CustomHttpResponse.fromDioResponse(dioResponse);
  }

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

  Future<CustomHttpResponse> patch(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    Response dioResponse = await dio.patch(path, data: data, options: options);
    return CustomHttpResponse.fromDioResponse(dioResponse);
  }

  Future<CustomHttpResponse> put(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    Response dioResponse = await dio.put(path, data: data, options: options);
    return CustomHttpResponse.fromDioResponse(dioResponse);
  }
}
