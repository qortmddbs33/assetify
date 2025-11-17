import 'package:get/get.dart';

import '../../provider/api_interface.dart';
import '../../provider/model/response.dart';
import 'model.dart';

class NotionRepository {
  final ApiProvider api;

  NotionRepository({ApiProvider? api}) : api = api ?? Get.find<ApiProvider>();

  Future<NotionDatabase> fetchNotionItems() async {
    String url = '/query';

    CustomHttpResponse response = await api.post(url);

    NotionDatabase db = NotionDatabase.fromJson(response.data);

    return db;
  }
}
