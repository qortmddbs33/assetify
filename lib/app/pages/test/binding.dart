/// 테스트 페이지 의존성 바인딩
library;

import 'package:get/get.dart';

import 'controller.dart';

/// 테스트 페이지 바인딩
class TestPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TestPageController());
  }
}
