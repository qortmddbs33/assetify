/// 자산 상세 페이지 의존성 바인딩

import 'package:get/get.dart';

import 'controller.dart';

/// 자산 상세 페이지 바인딩
class AssetDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssetDetailController>(() => AssetDetailController());
  }
}
