import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/notion/model.dart';
import '../../services/notion/service.dart';

class QuickStatusController extends GetxController {
  QuickStatusController();

  final NotionService notionService = Get.find<NotionService>();

  final TextEditingController assetNumberController = TextEditingController();
  final RxList<NotionPropertyOption> statusOptions =
      <NotionPropertyOption>[].obs;
  final RxString selectedStatus = ''.obs;
  final RxBool isLoadingOptions = true.obs;
  final RxBool isSubmitting = false.obs;
  final RxBool continuousModeEnabled = false.obs;
  final RxList<QuickStatusResult> results = <QuickStatusResult>[].obs;

  static const String _statusPropertyName = '사용/재고/폐기/기타';

  @override
  void onInit() {
    super.onInit();
    loadStatusOptions();
  }

  @override
  void onClose() {
    assetNumberController.dispose();
    super.onClose();
  }

  Future<void> loadStatusOptions() async {
    isLoadingOptions.value = true;
    try {
      final List<NotionPropertyOption> options =
          await notionService.fetchPropertyOptionsByName(_statusPropertyName);
      statusOptions.assignAll(options);
      if (options.isNotEmpty) {
        selectedStatus.value = options.first.name;
      }
    } finally {
      isLoadingOptions.value = false;
    }
  }

  void selectStatus(String name) {
    selectedStatus.value = name;
  }

  void setContinuousMode(bool enabled) {
    continuousModeEnabled.value = enabled;
  }

  Future<void> submitStatusChange() async {
    final String assetNumber = assetNumberController.text.trim();
    if (assetNumber.isEmpty || selectedStatus.value.isEmpty) {
      return;
    }
    await _processStatusChange(assetNumber);
  }

  Future<bool> _processStatusChange(String assetNumber) async {
    if (isSubmitting.value) return false;
    isSubmitting.value = true;
    final String status = selectedStatus.value;
    var wasSuccessful = false;
    try {
      final NotionPage? page =
          await notionService.fetchAssetByNumber(assetNumber);
      if (page == null) {
        _appendResult(
          QuickStatusResult(
            assetNumber: assetNumber,
            status: status,
            success: false,
            message: '자산 정보를 찾을 수 없어요.',
          ),
        );
        return false;
      }

      final NotionPage? updated = await notionService.updateAssetProperties(
        page: page,
        updates: {_statusPropertyName: status},
      );

      if (updated == null) {
        _appendResult(
          QuickStatusResult(
            assetNumber: assetNumber,
            status: status,
            success: false,
            message: 'Notion 업데이트에 실패했어요.',
          ),
        );
      } else {
        _appendResult(
          QuickStatusResult(
            assetNumber: assetNumber,
            status: status,
            success: true,
            message: '상태가 변경되었어요.',
          ),
        );
        wasSuccessful = true;
      }
    } finally {
      isSubmitting.value = false;
      assetNumberController.clear();
    }
    return wasSuccessful;
  }

  void _appendResult(QuickStatusResult result) {
    results.insert(0, result);
    if (results.length > 20) {
      results.removeLast();
    }
  }

  Future<bool> handleScannedValue(String value) async {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return false;
    assetNumberController.text = trimmed;
    return _processStatusChange(trimmed);
  }
}

class QuickStatusResult {
  final String assetNumber;
  final String status;
  final bool success;
  final String message;
  final DateTime timestamp;

  QuickStatusResult({
    required this.assetNumber,
    required this.status,
    required this.success,
    required this.message,
  }) : timestamp = DateTime.now();
}
