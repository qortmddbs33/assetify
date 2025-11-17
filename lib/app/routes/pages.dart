import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

import '../pages/asset_detail/binding.dart';
import '../pages/asset_detail/page.dart';
import '../pages/asset_lookup/binding.dart';
import '../pages/asset_lookup/page.dart';
import '../pages/home/binding.dart';
import '../pages/home/page.dart';
import '../pages/test/binding.dart';
import '../pages/test/page.dart';
import 'routes.dart';

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
  ];
}
