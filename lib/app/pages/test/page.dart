import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/routes.dart';
import 'controller.dart';

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
