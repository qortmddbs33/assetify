/// 테스트 페이지 UI
/// 개발 중 모든 라우트로 이동할 수 있는 테스트 화면

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/routes.dart';
import 'controller.dart';

/// 테스트 페이지 위젯
/// 모든 라우트 링크 목록 표시
class TestPage extends GetView<TestPageController> {
  const TestPage({super.key});

  Widget linkToRoute(String route) {
    return TextButton(onPressed: () => Get.toNamed(route), child: Text(route));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Routes'), centerTitle: true),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          linkToRoute(Routes.HOME),
          linkToRoute(Routes.LICENSE),
          linkToRoute(Routes.ASSET_LOOKUP),
          linkToRoute(Routes.QUICK_STATUS),
          linkToRoute(Routes.ASSET_DETAIL),
        ],
      ),
    );
  }
}
