/// Notion API 환경 설정
/// API 엔드포인트와 데이터베이스 ID 관리

class NotionEnvironment {
  NotionEnvironment._();

  // Notion API 프록시 서버 URL
  static const String _baseUrl = 'https://notion-proxy.idsjasan.workers.dev';
  // 자산 관리 Notion 데이터베이스 ID
  static const String _databaseId = '29967f4bfdac8086b468ef3545b3e471';

  /// API 기본 URL 반환
  static String get apiBaseUrl => _baseUrl;

  /// 데이터베이스 ID 반환
  static String get databaseId => _databaseId;
}
