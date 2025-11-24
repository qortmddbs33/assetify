/// 앱 페이지 라우트 설정
/// GetX 라우팅 시스템의 페이지 정의

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

import '../pages/asset_detail/binding.dart';
import '../pages/asset_detail/page.dart';
import '../pages/asset_lookup/binding.dart';
import '../pages/asset_lookup/page.dart';
import '../pages/home/binding.dart';
import '../pages/home/page.dart';
import '../pages/quick_status/binding.dart';
import '../pages/quick_status/page.dart';
import '../pages/test/binding.dart';
import '../pages/test/page.dart';
import 'routes.dart';

/// 앱 페이지 정의 클래스
/// 각 라우트에 대한 페이지, 바인딩, 전환 효과 설정
class AppPages {
  static final pages = [
    GetPage(
      name: Routes.TEST,
      page: () => const TestPage(),
      binding: TestPageBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.LICENSE,
      page: () => const LicensePage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
      binding: HomePageBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.ASSET_LOOKUP,
      page: () => const AssetLookupPage(),
      binding: AssetLookupBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.ASSET_DETAIL,
      page: () => const AssetDetailPage(),
      binding: AssetDetailBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.QUICK_STATUS,
      page: () => const QuickStatusPage(),
      binding: QuickStatusBinding(),
      transition: Transition.cupertino,
    ),
  ];
}
