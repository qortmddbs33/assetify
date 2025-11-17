import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class TestPage extends GetView<TestPageController> {
  const TestPage({super.key});

  Widget linkToRoute(String route) {
    return TextButton(
      onPressed: () {
        Get.toNamed(route);
      },
      child: Text(route),
    );
  }

  Widget linkToRouteWithArgs(
      String route, String title, Map<String, dynamic> args) {
    return TextButton(
      onPressed: () {
        Get.toNamed(route, arguments: args);
      },
      child: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Routes"),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          linkToRoute('/license'),
          linkToRoute('/'),
        ],
      ),
    );
  }
}
