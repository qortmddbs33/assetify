import 'package:get/get.dart';

import '../../services/notion/model.dart';
import '../../services/notion/service.dart';

class AssetOverviewController extends GetxController {
  AssetOverviewController();

  final NotionService notionService = Get.find<NotionService>();

  final RxBool _isLoading = true.obs;
  final RxString _errorMessage = ''.obs;
  final RxList<NotionPage> _items = <NotionPage>[].obs;

  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  List<NotionPage> get items => _items;

  @override
  void onInit() {
    super.onInit();
    loadAssets();
  }

  Future<void> loadAssets() async {
    _isLoading.value = true;
    _errorMessage.value = '';
    try {
      final data = await notionService.loadItems();
      if (data == null) {
        _items.clear();
        _errorMessage.value = '자산 정보를 불러오지 못했어요.';
      } else {
        _items.assignAll(data);
      }
    } catch (_) {
      _errorMessage.value = '자산 정보를 불러오는 중 문제가 발생했어요.';
    } finally {
      _isLoading.value = false;
    }
  }
}
