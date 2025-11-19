import 'package:flutter_dotenv/flutter_dotenv.dart';

class NotionEnvironment {
  NotionEnvironment._();

  static String get apiBaseUrl {
    final String? raw = dotenv.env['BASE_URL'];
    final String fallback = 'https://api.notion.com/v1';
    if (raw == null || raw.trim().isEmpty) {
      return fallback;
    }
    final String trimmed = raw.trim().replaceAll(RegExp(r'/+$'), '');
    return trimmed.isEmpty ? fallback : trimmed;
  }

  static String? get databaseId {
    return dotenv.env['DATABASE_ID'];
  }
}
