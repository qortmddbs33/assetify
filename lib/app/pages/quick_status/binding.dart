/// 빠른 상태 변경 페이지 의존성 바인딩
library;

import 'package:get/get.dart';

import '../../services/notion/service.dart';
import 'controller.dart';

/// 빠른 상태 변경 페이지 바인딩
class QuickStatusBinding implements Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<NotionService>()) {
      Get.lazyPut<NotionService>(() => NotionService());
    }
    Get.lazyPut<QuickStatusController>(() => QuickStatusController());
  }
}
