import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'model/response.dart';

abstract class ApiProvider {
  late Dio dio = Dio();

  ApiProvider() {
    dio = Dio(BaseOptions(
      headers: {
        'Authorization': 'Bearer ${dotenv.env['NOTION_API_KEY']}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Notion-Version': '2022-02-22',
      },
    ));
  }

  Future<CustomHttpResponse> get(String path,
      {Map<String, dynamic>? queryParameters, Options? options}) async {
    Response dioResponse =
        await dio.get(path, queryParameters: queryParameters, options: options);
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
          String formatedData =
              strData.substring(strData.indexOf('{'), strData.indexOf('}') + 1);
          Map<String, dynamic> data = json.decode(formatedData);

          sink.add(data);
        },
      ),
    );
  }

  Future<CustomHttpResponse> delete(String path,
      {dynamic data, Options? options}) async {
    Response dioResponse = await dio.delete(path, data: data, options: options);
    return CustomHttpResponse.fromDioResponse(dioResponse);
  }

  Future<CustomHttpResponse> post(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options}) async {
    Response dioResponse = await dio.post(path,
        data: data, queryParameters: queryParameters, options: options);
    return CustomHttpResponse.fromDioResponse(dioResponse);
  }

  Future<CustomHttpResponse> patch(String path,
      {dynamic data, Options? options}) async {
    Response dioResponse = await dio.patch(path, data: data, options: options);
    return CustomHttpResponse.fromDioResponse(dioResponse);
  }

  Future<CustomHttpResponse> put(String path,
      {dynamic data, Options? options}) async {
    Response dioResponse = await dio.put(path, data: data, options: options);
    return CustomHttpResponse.fromDioResponse(dioResponse);
  }
}
