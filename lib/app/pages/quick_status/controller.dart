import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
  static const String _usageDatePropertyName = '사용일자';
  static const String _returnDatePropertyName = '반납일자';
  static const String _repairDatePropertyName = '수리일자';
  static const String _returnReasonPropertyName = '반납사유';
  static const String _repairWorkTypePropertyName = '수리 작업 유형';
  static const String _repairStatusPropertyName = '수리진행상황';
  static const String _shipmentStatusPropertyName = '출고진행상황';
  static const String clearSelectionValue = '__quick_status_clear__';

  final Rx<QuickStatusDateAction> usageDateAction =
      QuickStatusDateAction.none.obs;
  final Rx<QuickStatusDateAction> returnDateAction =
      QuickStatusDateAction.none.obs;
  final Rx<QuickStatusDateAction> repairDateAction =
      QuickStatusDateAction.none.obs;
  final RxList<NotionPropertyOption> returnReasonOptions =
      <NotionPropertyOption>[].obs;
  final RxList<NotionPropertyOption> repairWorkTypeOptions =
      <NotionPropertyOption>[].obs;
  final RxList<NotionPropertyOption> repairStatusOptions =
      <NotionPropertyOption>[].obs;
  final RxList<NotionPropertyOption> shipmentStatusOptions =
      <NotionPropertyOption>[].obs;
  final Rx<String?> selectedReturnReason = Rx<String?>(null);
  final Rx<String?> selectedRepairWorkType = Rx<String?>(null);
  final Rx<String?> selectedRepairStatus = Rx<String?>(null);
  final Rx<String?> selectedShipmentStatus = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    loadStatusOptions();
    _loadAdditionalOptions();
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

  Future<void> _loadAdditionalOptions() async {
    await Future.wait([
      _loadOptionsFor(returnReasonOptions, _returnReasonPropertyName),
      _loadOptionsFor(repairWorkTypeOptions, _repairWorkTypePropertyName),
      _loadOptionsFor(repairStatusOptions, _repairStatusPropertyName),
      _loadOptionsFor(shipmentStatusOptions, _shipmentStatusPropertyName),
    ]);
  }

  Future<void> _loadOptionsFor(
    RxList<NotionPropertyOption> target,
    String propertyName,
  ) async {
    final List<NotionPropertyOption> options =
        await notionService.fetchPropertyOptionsByName(propertyName);
    target.assignAll(options);
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

      final Map<String, String> updates = {_statusPropertyName: status};
      _applyDateActions(updates);
      _applySelectionOptions(updates);

      final NotionPage? updated = await notionService.updateAssetProperties(
        page: page,
        updates: updates,
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

  void setUsageDateAction(QuickStatusDateAction action) {
    usageDateAction.value = action;
  }

  void setReturnDateAction(QuickStatusDateAction action) {
    returnDateAction.value = action;
  }

  void setRepairDateAction(QuickStatusDateAction action) {
    repairDateAction.value = action;
  }

  void setReturnReasonSelection(String? value) {
    selectedReturnReason.value = value;
  }

  void setRepairWorkTypeSelection(String? value) {
    selectedRepairWorkType.value = value;
  }

  void setRepairStatusSelection(String? value) {
    selectedRepairStatus.value = value;
  }

  void setShipmentStatusSelection(String? value) {
    selectedShipmentStatus.value = value;
  }

  void _applyDateActions(Map<String, String> updates) {
    _applyDateAction(
      action: usageDateAction.value,
      propertyName: _usageDatePropertyName,
      updates: updates,
    );
    _applyDateAction(
      action: returnDateAction.value,
      propertyName: _returnDatePropertyName,
      updates: updates,
    );
    _applyDateAction(
      action: repairDateAction.value,
      propertyName: _repairDatePropertyName,
      updates: updates,
    );
  }

  void _applySelectionOptions(Map<String, String> updates) {
    _applySelection(
      value: selectedReturnReason.value,
      propertyName: _returnReasonPropertyName,
      updates: updates,
    );
    _applySelection(
      value: selectedRepairWorkType.value,
      propertyName: _repairWorkTypePropertyName,
      updates: updates,
    );
    _applySelection(
      value: selectedRepairStatus.value,
      propertyName: _repairStatusPropertyName,
      updates: updates,
    );
    _applySelection(
      value: selectedShipmentStatus.value,
      propertyName: _shipmentStatusPropertyName,
      updates: updates,
    );
  }

  void _applyDateAction({
    required QuickStatusDateAction action,
    required String propertyName,
    required Map<String, String> updates,
  }) {
    switch (action) {
      case QuickStatusDateAction.none:
        return;
      case QuickStatusDateAction.setToday:
        updates[propertyName] = _currentDateString();
        return;
      case QuickStatusDateAction.clear:
        updates[propertyName] = '';
        return;
    }
  }

  void _applySelection({
    required String? value,
    required String propertyName,
    required Map<String, String> updates,
  }) {
    if (value == null) return;
    if (value == clearSelectionValue) {
      updates[propertyName] = '';
    } else {
      updates[propertyName] = value;
    }
  }

  String _currentDateString() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
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

enum QuickStatusDateAction { none, setToday, clear }
