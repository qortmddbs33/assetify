import 'dart:developer';

import 'package:get/get.dart';

import 'model.dart';
import 'repository.dart';

class NotionService extends GetxController with StateMixin<List<NotionPage>?> {
  final NotionRepository repository;

  NotionService({NotionRepository? repository})
    : repository = repository ?? NotionRepository();

  final Rx<List<NotionPage>?> _items = Rx(null);

  List<NotionPage>? get items => _items.value;

  Future<List<NotionPage>?> loadItems() async {
    try {
      NotionDatabase data = await repository.fetchNotionItems();
      _items.value = data.results;
      return _items.value;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
