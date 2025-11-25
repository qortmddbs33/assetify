/// 홈 페이지 컨트롤러
/// API 키 관리 및 페이지 네비게이션 처리
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/credentials/service.dart';

/// 홈 페이지 컨트롤러
/// Notion API 키 저장/삭제 및 메뉴 이동 기능 제공
class HomePageController extends GetxController {
  final CredentialsService credentialsService;
  final TextEditingController notionApiKeyController = TextEditingController();
  final RxBool _isSaving = false.obs;
  final RxnString storedApiKey = RxnString();

  HomePageController({CredentialsService? credentialsService})
    : credentialsService = credentialsService ?? Get.find<CredentialsService>();

  bool get isSaving => _isSaving.value;
  bool get hasStoredApiKey => storedApiKey.value?.isNotEmpty == true;

  @override
  void onInit() {
    super.onInit();
    storedApiKey.value = credentialsService.notionApiKey;
    if (storedApiKey.value?.isNotEmpty == true) {
      notionApiKeyController.text = storedApiKey.value!;
    }
  }

  /// API 키 저장
  Future<void> saveApiKey() async {
    if (isSaving) return;
    _isSaving.value = true;
    try {
      await credentialsService.saveNotionApiKey(notionApiKeyController.text);
      storedApiKey.value = credentialsService.notionApiKey;
      if (!hasStoredApiKey) {
        notionApiKeyController.clear();
      }
    } finally {
      _isSaving.value = false;
    }
  }

  /// API 키 삭제
  Future<void> clearApiKey() async {
    if (isSaving) return;
    _isSaving.value = true;
    try {
      await credentialsService.clearNotionApiKey();
      storedApiKey.value = null;
      notionApiKeyController.clear();
    } finally {
      _isSaving.value = false;
    }
  }

  /// API 키가 있으면 페이지 이동, 없으면 경고 표시
  void navigateOrWarn(String routeName) {
    if (!hasStoredApiKey) {
      Get.snackbar('Notion API 키 필요', '먼저 Notion API 키를 입력해주세요.');
      return;
    }
    Get.toNamed(routeName);
  }

  @override
  void onClose() {
    notionApiKeyController.dispose();
    super.onClose();
  }
}
