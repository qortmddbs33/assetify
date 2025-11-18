import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NotionEnvironment {
  NotionEnvironment._();

  static String? get databaseId {
    if (kReleaseMode) {
      return dotenv.env['PROD_DATABASE_ID'];
    }
    return dotenv.env['DEV_DATABASE_ID'];
  }
}
