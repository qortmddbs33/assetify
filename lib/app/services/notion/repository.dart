import 'package:get/get.dart';

import '../../provider/api_interface.dart';
import '../../provider/model/response.dart';
import 'model.dart';

class NotionRepository {
  final ApiProvider api;

  NotionRepository({ApiProvider? api}) : api = api ?? Get.find<ApiProvider>();

  Future<NotionDatabase> fetchNotionItems({
    String? assetNumber,
  }) async {
    const String url = '/query';

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

  Future<NotionPage> fetchPageById(String pageId) async {
    assert(pageId.isNotEmpty, 'pageId must not be empty');
    CustomHttpResponse response =
        await api.get('https://api.notion.com/v1/pages/$pageId');

    final Map<String, dynamic> data =
        Map<String, dynamic>.from(response.data as Map);
    return NotionPage.fromJson(data);
  }

  Future<NotionPage> updatePage({
    required String pageId,
    required Map<String, dynamic> properties,
  }) async {
    assert(pageId.isNotEmpty, 'pageId must not be empty');
    if (properties.isEmpty) {
      throw ArgumentError('properties must not be empty');
    }

    CustomHttpResponse response = await api.patch(
      'https://api.notion.com/v1/pages/$pageId',
      data: {'properties': properties},
    );

    final Map<String, dynamic> data =
        Map<String, dynamic>.from(response.data as Map);
    return NotionPage.fromJson(data);
  }

  Future<Map<String, NotionPropertyDefinition>> fetchDatabaseSchema(
      String databaseId) async {
    assert(databaseId.isNotEmpty, 'databaseId must not be empty');
    final CustomHttpResponse response =
        await api.get('https://api.notion.com/v1/databases/$databaseId');
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
}
