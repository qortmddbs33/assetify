import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/routes.dart';
import '../../services/notion/model.dart';
import '../../services/notion/service.dart';

class AssetLookupController extends GetxController {
  AssetLookupController();

  final NotionService notionService = Get.find<NotionService>();
  final TextEditingController assetNumberController = TextEditingController();

  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onClose() {
    assetNumberController.dispose();
    super.onClose();
  }

  Future<void> searchAsset() async {
    final assetNumber = assetNumberController.text.trim();
    if (assetNumber.isEmpty) {
      _errorMessage.value = '자산번호를 입력해주세요.';
      return;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    final NotionPage? page =
        await notionService.fetchAssetByNumber(assetNumber);

    _isLoading.value = false;

    if (page == null) {
      _errorMessage.value = '해당 자산번호를 찾을 수 없어요.';
      return;
    }

    Get.toNamed(Routes.ASSET_DETAIL, arguments: page);
  }
}
