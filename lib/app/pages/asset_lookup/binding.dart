import 'package:get/get.dart';

import '../../services/notion/service.dart';
import 'controller.dart';

class AssetLookupBinding implements Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<NotionService>()) {
      Get.lazyPut<NotionService>(() => NotionService());
    }
    Get.lazyPut<AssetLookupController>(() => AssetLookupController());
  }
}
