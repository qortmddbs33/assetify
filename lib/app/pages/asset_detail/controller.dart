/// 자산 상세 페이지 컨트롤러
/// 자산 속성 조회, 수정, 새로고침 기능
library;

import 'package:get/get.dart';

import '../../services/notion/model.dart';
import '../../services/notion/service.dart';

/// 자산 상세 컨트롤러
class AssetDetailController extends GetxController {
  late final Rx<NotionPage> page;
  final RxBool isUpdating = false.obs;
  final NotionService notionService = Get.find<NotionService>();
  final Map<String, List<NotionPropertyOption>> _optionsCache = {};

  @override
  void onInit() {
    super.onInit();
    page = (Get.arguments as NotionPage).obs;
  }

  NotionProperties get properties => page.value.properties;

  NotionPropertyField? propertyField(String propertyName) =>
      page.value.field(propertyName);

  bool canEdit(String propertyName) =>
      propertyField(propertyName)?.isEditable ?? false;

  String hintFor(String propertyName) =>
      propertyField(propertyName)?.inputHint ?? '';

  /// 속성 값 업데이트
  Future<bool> updateProperty(String propertyName, String newValue) async {
    final NotionPropertyField? field = propertyField(propertyName);
    if (field == null || !field.isEditable) return false;
    if (isUpdating.value) return false;

    isUpdating.value = true;
    try {
      final NotionPage? updated = await notionService.updateAssetProperties(
        page: page.value,
        updates: {propertyName: newValue},
      );
      if (updated != null) {
        page.value = updated;
        return true;
      }
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  /// 페이지 새로고침
  Future<void> refreshPage() async {
    final NotionPage? refreshed =
        await notionService.fetchAssetById(page.value.id);
    if (refreshed != null) {
      page.value = refreshed;
      _optionsCache.clear();
    }
  }

  /// 속성의 선택 가능한 옵션 목록 조회
  Future<List<NotionPropertyOption>> fetchPropertyOptions(
      String propertyName) async {
    if (_optionsCache.containsKey(propertyName)) {
      return _optionsCache[propertyName]!;
    }
    final List<NotionPropertyOption> options =
        await notionService.fetchPropertyOptions(page.value, propertyName);
    _optionsCache[propertyName] = options;
    return options;
  }
}
