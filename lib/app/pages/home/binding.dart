/// 홈 페이지 의존성 바인딩

import 'package:get/get.dart';

import 'controller.dart';

/// 홈 페이지 바인딩
/// 페이지 진입 시 HomePageController를 등록
class HomePageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomePageController>(() => HomePageController());
  }
}
