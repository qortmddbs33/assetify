import 'package:get/get.dart';

import 'controller.dart';

class AssetDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssetDetailController>(() => AssetDetailController());
  }
}
