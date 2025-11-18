import 'package:get/get.dart';

import '../../services/notion/model.dart';
import '../../services/notion/service.dart';

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

  Future<void> refreshPage() async {
    final NotionPage? refreshed =
        await notionService.fetchAssetById(page.value.id);
    if (refreshed != null) {
      page.value = refreshed;
      _optionsCache.clear();
    }
  }

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
