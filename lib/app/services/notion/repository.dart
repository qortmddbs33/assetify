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
}
