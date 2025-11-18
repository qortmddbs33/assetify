import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'api_interface.dart';
import 'interceptors/log.dart';

class ProdApiProvider extends ApiProvider {
  final baseUrl =
      'https://api.notion.com/v1/databases/${dotenv.env['DEV_DATABASE_ID']}';

  ProdApiProvider() {
    dio.options.baseUrl = baseUrl;
    dio.interceptors.add(LogInterceptor());
  }
}
