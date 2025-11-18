import 'api_interface.dart';
import '../core/utils/notion_environment.dart';
import 'interceptors/log.dart';

class ProdApiProvider extends ApiProvider {
  late final String baseUrl;

  ProdApiProvider() {
    final String? databaseId = NotionEnvironment.databaseId;
    if (databaseId == null || databaseId.isEmpty) {
      throw StateError('DATABASE_ID is not configured in .env');
    }
    baseUrl = 'https://api.notion.com/v1/databases/$databaseId';
    dio.options.baseUrl = baseUrl;
    dio.interceptors.add(LogInterceptor());
  }
}
