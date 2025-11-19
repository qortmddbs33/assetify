class NotionEnvironment {
  NotionEnvironment._();

  static const String _baseUrl = 'https://notion-proxy.sspyorea.workers.dev';
  static const String _databaseId = '29967f4bfdac8086b468ef3545b3e471';

  static String get apiBaseUrl => _baseUrl;

  static String get databaseId => _databaseId;
}
