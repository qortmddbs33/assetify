import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NotionEnvironment {
  NotionEnvironment._();

  static String get apiBaseUrl {
    final String? raw =
        kReleaseMode ? dotenv.env['PROD_NOTION_API_BASE_URL'] : dotenv.env['DEV_NOTION_API_BASE_URL'];
    final String trimmed =
        (raw != null && raw.isNotEmpty ? raw : 'https://api.notion.com/v1').trim();
    return trimmed.replaceAll(RegExp(r'/+$'), '');
  }

  static String? get databaseId {
    if (kReleaseMode) {
      return dotenv.env['PROD_DATABASE_ID'];
    }
    return dotenv.env['DEV_DATABASE_ID'];
  }
}
