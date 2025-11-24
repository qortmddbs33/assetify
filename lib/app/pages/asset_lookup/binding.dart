/// 자산 조회 페이지 의존성 바인딩

import 'package:get/get.dart';

import '../../services/notion/service.dart';
import 'controller.dart';

/// 자산 조회 페이지 바인딩
/// NotionService와 AssetLookupController 등록
class AssetLookupBinding implements Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<NotionService>()) {
      Get.lazyPut<NotionService>(() => NotionService());
    }
    Get.lazyPut<AssetLookupController>(() => AssetLookupController());
  }
}
