import 'package:get/get.dart';

import '../../services/notion/service.dart';
import 'controller.dart';

class AssetOverviewBinding implements Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<NotionService>()) {
      Get.lazyPut<NotionService>(() => NotionService());
    }
    Get.lazyPut<AssetOverviewController>(() => AssetOverviewController());
  }
}
