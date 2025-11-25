/// Notion API 데이터 접근 레이어
/// API 호출과 데이터 변환을 담당
library;

import 'package:get/get.dart';

import '../../core/utils/notion_environment.dart';
import '../../provider/api_interface.dart';
import '../../provider/model/response.dart';
import 'model.dart';

/// Notion 데이터 레포지토리
/// 데이터베이스 쿼리, 페이지 조회/수정 등 API 호출 담당
class NotionRepository {
  final ApiProvider api;

  NotionRepository({ApiProvider? api}) : api = api ?? Get.find<ApiProvider>();

  /// 데이터베이스에서 자산 목록 조회
  Future<NotionDatabase> fetchNotionItems({
    String? assetNumber,
  }) async {
    final String databaseId = _requireDatabaseId();
    final String url = '/databases/$databaseId/query';

    final Map<String, dynamic> payload = {};
    if (assetNumber != null && assetNumber.isNotEmpty) {
      payload['filter'] = {
        'property': '자산번호',
        'rich_text': {'equals': assetNumber},
      };
    }

    CustomHttpResponse response =
        await api.post(url, data: payload.isEmpty ? null : payload);

    return NotionDatabase.fromJson(response.data);
  }

  /// 페이지 ID로 단일 페이지 조회
  Future<NotionPage> fetchPageById(String pageId) async {
    assert(pageId.isNotEmpty, 'pageId must not be empty');
    CustomHttpResponse response = await api.get('/pages/$pageId');

    final Map<String, dynamic> data =
        Map<String, dynamic>.from(response.data as Map);
    return NotionPage.fromJson(data);
  }

  /// 페이지 속성 업데이트
  Future<NotionPage> updatePage({
    required String pageId,
    required Map<String, dynamic> properties,
  }) async {
    assert(pageId.isNotEmpty, 'pageId must not be empty');
    if (properties.isEmpty) {
      throw ArgumentError('properties must not be empty');
    }

    CustomHttpResponse response =
        await api.patch('/pages/$pageId', data: {'properties': properties});

    final Map<String, dynamic> data =
        Map<String, dynamic>.from(response.data as Map);
    return NotionPage.fromJson(data);
  }

  /// 데이터베이스 스키마(속성 정의) 조회
  Future<Map<String, NotionPropertyDefinition>> fetchDatabaseSchema(
      String databaseId) async {
    assert(databaseId.isNotEmpty, 'databaseId must not be empty');
    final CustomHttpResponse response =
        await api.get('/databases/$databaseId');
    final Map<String, dynamic> data =
        Map<String, dynamic>.from(response.data as Map);
    final Map<String, dynamic>? properties =
        data['properties'] is Map<String, dynamic>
            ? data['properties'] as Map<String, dynamic>
            : data['properties'] is Map
                ? Map<String, dynamic>.from(data['properties'] as Map)
                : null;
    return NotionPropertyDefinition.mapFromDatabase(properties);
  }

  String _requireDatabaseId() {
    final String databaseId = NotionEnvironment.databaseId;
    if (databaseId.isEmpty) {
      throw StateError('DATABASE_ID is not configured in .env');
    }
    return databaseId;
  }
}
