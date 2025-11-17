import 'package:get/get.dart';

import '../../services/notion/model.dart';

class AssetDetailController extends GetxController {
  late final NotionPage page;

  @override
  void onInit() {
    super.onInit();
    page = Get.arguments as NotionPage;
  }
}
